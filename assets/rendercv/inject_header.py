#!/usr/bin/env python
"""Inject a running page header into a rendercv-generated Typst file, then
recompile it to PDF.

Why this exists: the rendercv `classic` theme supports only a centered footer
and a first-page-only "top note" — it has no running per-page header. A
fellowship application requires a two-line page header in BOLD ITALIC ALL CAPS
reading "FIRSTNAME LASTNAME, DOCUMENT TYPE" on *every* page. We add that by
setting `page(header: ...)` in the generated Typst and recompiling with the
same Typst compiler (fonts + package paths) rendercv itself uses.

Usage: python inject_header.py <generated .typ> <output .pdf> [DOCUMENT TYPE]
Called by build_pdf.sh; not meant to be run by hand.
"""

import pathlib
import re
import sys

from rendercv.renderer.pdf_png import get_typst_compiler

typ_path = pathlib.Path(sys.argv[1]).resolve()
pdf_path = pathlib.Path(sys.argv[2]).resolve()
doc_type = sys.argv[3] if len(sys.argv) > 3 else "CV"

src = typ_path.read_text()

# Keep the header name in sync with the `name:` the template was built with.
name_match = re.search(r'name:\s*"([^"]+)"', src)
name = name_match.group(1) if name_match else "Rebecca Woody"
header_text = f"{name}, {doc_type}".upper()

# Bold italic all-caps running header, repeated on every page.
header_block = (
    "\n// Fellowship requirement: BOLD ITALIC ALL-CAPS running page header on\n"
    "// every page. Injected by inject_header.py after `rendercv render`.\n"
    "#set page(header: context {\n"
    "  set align(center)\n"
    '  set text(size: 10pt, weight: "bold", style: "italic", fill: rgb(0, 0, 0))\n'
    f"  [{header_text}]\n"
    "})\n\n"
)

# The set-page rule must live at the document root: Typst forbids `set page`
# inside the body that gets passed into `rendercv.with(...)` ("page
# configuration is not allowed inside of containers"). So inject it just before
# the `#show: rendercv.with(` template call. Its `header` field merges with the
# margins/footer the template sets, since neither sets the other's fields.
show_call = re.search(r"^#show: rendercv\.with\(", src, flags=re.MULTILINE)
if not show_call:
    sys.exit("inject_header.py: could not find the rendercv template call in the Typst file")
idx = show_call.start()
typ_path.write_text(src[:idx] + header_block + src[idx:])

compiler = get_typst_compiler(input_file_path=typ_path, root=typ_path.parent)
compiler.compile(input=str(typ_path), format="pdf", output=str(pdf_path))
print(f"Injected header '{header_text}' and recompiled {pdf_path}")
