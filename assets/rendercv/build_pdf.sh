#!/usr/bin/env bash
# Regenerate assets/pdf/woody_cv.pdf from the live HTML CV.
#
# The CV data lives in _data/cv.yml and is rendered by _layouts/cv.liquid.
# rendercv proper needs Python 3.10+ or a LaTeX install (neither is set up on
# this machine), so instead we print the deployed /cv/print/ page — which is the
# same CV, styled by the @media print rules in assets/css/main.scss — to PDF
# with headless Chrome.
#
# Workflow after editing _data/cv.yml:
#   1. commit & push so the /cv/print/ page rebuilds, wait for the deploy
#   2. run this script
#   3. commit the updated assets/pdf/woody_cv.pdf
#
# Requires Google Chrome. Override the URL as arg 1 for a different site.
set -euo pipefail

URL="${1:-https://rebeccawoody.github.io/cv/print/}"
OUT="$(cd "$(dirname "$0")/../.." && pwd)/assets/pdf/woody_cv.pdf"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

mkdir -p "$(dirname "$OUT")"
"$CHROME" \
  --headless --disable-gpu \
  --no-pdf-header-footer \
  --virtual-time-budget=10000 \
  --print-to-pdf="$OUT" \
  "${URL}?_=$RANDOM"

echo "Wrote $OUT"
