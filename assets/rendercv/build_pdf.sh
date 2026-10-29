#!/usr/bin/env bash
# Regenerate assets/pdf/woody_cv.pdf from the rendercv source with rendercv.
#
# Source data:  assets/rendercv/Rebecca_Woody_CV.yaml   (edit this for the PDF)
# Design:       assets/rendercv/design.yaml             (black serif "classic" look)
# Locale:       assets/rendercv/locale.yaml
#
# rendercv lives in the conda "base" env (Python 3.12). It bundles Typst, so no
# LaTeX is needed. Install once with:  conda run -n base pip install "rendercv[full]"
#
# Workflow: edit the YAML, run this script, commit assets/pdf/woody_cv.pdf.
# (The /cv/print/ HTML page is driven separately by _data/cv.yml.)
#
# This also builds a companion publications-only PDF for personal/application
# use: assets/rendercv/woody_publications.pdf. It is NOT linked anywhere and the
# assets/rendercv folder is excluded from the Jekyll build (see _config.yml), so
# it is not served on the site. It is derived from the same CV YAML (see
# make_publications_yaml.py) so it can never drift from the CV.
set -euo pipefail

cd "$(dirname "$0")/../.."   # repo root
ENV="${RENDERCV_CONDA_ENV:-base}"

conda run -n "$ENV" rendercv render assets/rendercv/Rebecca_Woody_CV.yaml \
  --design assets/rendercv/design.yaml \
  --locale-catalog assets/rendercv/locale.yaml \
  --output-folder rendercv_output \
  --pdf-path ../pdf/woody_cv.pdf \
  --dont-generate-markdown \
  --dont-generate-png

echo "Wrote assets/pdf/woody_cv.pdf"

# --- Companion: publications-only PDF (internal; cites the journal/arXiv ref
#     instead of the ADS link). Generated from the CV YAML above. ---
PUB_YAML=assets/rendercv/Rebecca_Woody_Publications.yaml   # generated; git-ignored
conda run -n "$ENV" python assets/rendercv/make_publications_yaml.py \
  assets/rendercv/Rebecca_Woody_CV.yaml "$PUB_YAML"

conda run -n "$ENV" rendercv render "$PUB_YAML" \
  --design assets/rendercv/design.yaml \
  --locale-catalog assets/rendercv/locale.yaml \
  --output-folder rendercv_output \
  --pdf-path ../rendercv/woody_publications.pdf \
  --dont-generate-markdown \
  --dont-generate-png

echo "Wrote assets/rendercv/woody_publications.pdf"
