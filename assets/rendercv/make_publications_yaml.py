#!/usr/bin/env python3
"""Derive a publications-only rendercv input from the full CV YAML.

Why: the companion "publication list" PDF (assets/rendercv/woody_publications.pdf)
must stay formatted identically to the CV and never drift from it, so it is
generated from the same source (Rebecca_Woody_CV.yaml) at build time rather
than maintained by hand.

What it keeps: the name/contact header fields and ONLY the publication sections.
What it changes: drops each entry's `url`, so the `journal` citation
(e.g. "ApJ, 978, 152" or "arXiv:2204.09057") renders instead of the ADS link.

Usage: make_publications_yaml.py <cv.yaml> <out.yaml>
The output is generated — do not edit it by hand.
"""
from __future__ import annotations

import sys

from ruamel.yaml import YAML

PUB_SECTIONS = ("First-Author Publications", "Co-Author Publications")
HEADER_KEYS = (
    "name",
    "headline",
    "location",
    "email",
    "phone",
    "website",
    "social_networks",
)


def main(src: str, dst: str) -> None:
    yaml = YAML()
    yaml.preserve_quotes = True
    yaml.width = 4096  # never wrap long author/title lines

    with open(src) as f:
        data = yaml.load(f)

    cv = data["cv"]
    new_cv = {key: cv[key] for key in HEADER_KEYS if key in cv}

    sections = cv.get("sections", {}) or {}
    new_sections = {}
    for name in PUB_SECTIONS:
        entries = sections.get(name)
        if entries is None:
            continue
        for entry in entries:
            if isinstance(entry, dict):
                entry.pop("url", None)
        new_sections[name] = entries
    new_cv["sections"] = new_sections

    with open(dst, "w") as f:
        yaml.dump({"cv": new_cv}, f)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit("usage: make_publications_yaml.py <cv.yaml> <out.yaml>")
    main(sys.argv[1], sys.argv[2])
