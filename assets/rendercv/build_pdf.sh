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
