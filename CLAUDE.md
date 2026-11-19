# CLAUDE.md — rebeccawoody.github.io

Personal academic website for **Rebecca Woody** (astrophysicist, PhD candidate, CfA | Harvard & Smithsonian).
Built on the **al-folio** Jekyll theme. Live at **https://rebeccawoody.github.io/**.

## Standing rule: keep these docs current
After any **major milestone or big task** (a new section/page, a feature, a significant refactor, a new workflow or convention), update **both**:
- **`CLAUDE.md`** — fold durable facts into the right section (Structure, Gotchas, config, a new standing rule). Keep deep reproducible detail in the project memories and reference them, rather than duplicating here.
- **`PROJECT_LOG.md`** — add a new dated entry at the top, and retire any TODO the work closes.

Do this when Rebecca explicitly asks, **and** proactively on your own judgment whenever you've completed something significant — don't wait to be told.

## Deploy & hosting
- **Repo:** `git@github.com:rebeccawoody/rebeccawoody.github.io.git`, branch **`master`**. Public (required for free GitHub Pages).
- **Pipeline:** push to `master` → `.github/workflows/deploy.yml` builds Jekyll → pushes `_site` to the **`gh-pages`** branch → Pages serves `gh-pages`.
- **`gh` CLI** is installed and authenticated. **Always pass `-R rebeccawoody/rebeccawoody.github.io`** — bare `gh` commands resolve to the `upstream` (al-folio) remote and show the wrong repo's runs.
- **No working local build** (system Ruby 2.6, no Node/ImageMagick). Verify changes via the deploy + `curl`, not a local `jekyll build`.

## Verify workflow (after every push)
1. Wait for the newest `deploy.yml` run to finish:
   `gh run list -R rebeccawoody/rebeccawoody.github.io --workflow deploy.yml --limit 1`
   On failure: `gh run view -R rebeccawoody/rebeccawoody.github.io <id> --log-failed`
2. Pages publish lags the deploy by ~30–60s; poll the live URL with a cache-busting query (`?_=$RANDOM`) until the change appears.
3. `.webp` image URLs are **not** version-hashed — tell Rebecca to hard-refresh (`Cmd+Shift+R`) after image changes. `main.css` may also need a hard-refresh.

## Structure (what the site actually uses)
- `_pages/`: `about.md` (Home, `permalink: /`), `projects.md` (**Research**, `/research/`), `cv.md`, `almanac.md`, `404.md`.
  - Nav = `nav:`/`nav_order:` frontmatter. The theme **auto-adds** `about.md` as the Home tab — do **not** set `nav: true` on it (duplicate tab).
- `_projects/`: one file per Research card. Frontmatter: `title`, `description`, `img`, `importance`, `category: research`, optional `redirect:` (ADS URL) or `no_link: true` (unpublished → non-clickable), optional `published:` (renders an italic citation footer). Cards sort **newest-first** (reverse `importance`; give newer projects higher numbers).
- `_data/`: `socials.yml` (home contact).
- **CV = a rendercv PDF**, not the al-folio HTML CV. `cv.md` (`/cv/`) sets `cv_pdf:` and the local `_layouts/cv.liquid` override embeds that PDF in an in-browser viewer (no `_data/cv.yml`, no HTML CV). Source of truth: `assets/rendercv/Rebecca_Woody_CV.yaml` (+ `design.yaml` black-serif "classic", `locale.yaml`). Regenerate `assets/pdf/woody_cv.pdf` with `bash assets/rendercv/build_pdf.sh` (needs `rendercv` in conda `base`; see the `website-local-tooling` memory), then commit the PDF.
- `assets/img/research/`: figure PNGs (+ source PDFs). `assets/css/main.scss`: local style overrides.
- `_includes/projects_horizontal.liquid`: **local override** of the gem include (full-width cards, corrected image `sizes`, `no_link`/`published` support).

## Almanac (star highlights)
- `_almanac/`: a Jekyll **collection** (`output: true`, permalink `/almanac/:name/`), one file per star. Frontmatter: `title`, `subtitle` (italic), `description` (card teaser + detail-page lead), `group: research|personal`, `order:` (sort within group), **`live: true`** (rollout flag — unflagged stubs stay hidden), `card_img:` (cartoon/vector thumbnail for the list card), optional `sky_img:` + `sky_credit:` (real sky image + caption on the detail page). Entries use **`layout: almanac`**.
- `_pages/almanac.md` (**Almanac**, `/almanac/`): renders **only `live: true`** entries, split into research then personal, with the divider auto-hidden when a group is empty. Publishing a star = add `card_img` + flip `live: true`.
- `_includes/almanac_horizontal.liquid`: local card include — **compact** card on a **self-contained flexbox** (NOT the gem grid; see gotcha): 150px thumbnail + vertically-centred text, capped ~460px, stacks below 576px.
- `_layouts/almanac.liquid`: local detail-page layout — title+subtitle+description header, then a two-column flex (`.almanac-layout`): the `sky_img` figure + `figcaption` caption on the **left** (sticky — pins 66px below the navbar while the prose scrolls, releases at the entry bottom), prose `{{ content }}` on the **right**; stacks below 700px.
- **Sky images:** pulled from **NASA SkyView** (`skyview.gsfc.nasa.gov`) — CDS/Aladin is firewalled from the dev box. Bright naked-eye stars saturate every survey; Albireo uses an offline-built **2MASS J/H/Ks composite** (numpy+Pillow venv, fills only the zeroed saturated-core pixels). Reproducible recipe + full workflow in the `almanac-section` memory.

## Theme is gem-based
Layouts/includes/sass live in the **`al_folio_core` gem** (pinned `= 1.0.15`), **not** the repo. To read them:
`gem fetch al_folio_core -v 1.0.15 && tar -xf al_folio_core-1.0.15.gem && tar -xzf data.tar.gz`
Override a theme file by placing a same-path file in the repo (e.g. `assets/css/main.scss`, `_includes/...`).

## Config choices (in `_config.yml`)
- `search_enabled: false`, `enable_darkmode: false` (light mode only, no toggle).
- CI trimmed to **only `deploy.yml`** (21 other al-folio workflows removed).

## Gotchas (learned the hard way)
- **`_data/socials.yml`:** a recognized key present-but-empty (nil) crashes the `jekyll-socials` build. Comment keys out; never leave blank.
- **Markdown `|`** in body text becomes a table — reword or escape `\|`. Use `&amp;` for `&`.
- **MathJax** is on with single-`$` inline delimiters enabled (`$...$` renders on cards).
- The home dir `/Users/twoody` is itself a git repo — always operate inside `/Users/twoody/website`.
- **Purged tailwind grid:** the theme's `tailwind.css` is purged and ships **only `.col-md-6`** (+ `.row`/`.no-gutters`/`.card`). Other `col-md-N` (5/7/12…) have **no width rules** and silently collapse/stack. Build custom card/column layouts with your own scoped flexbox, not `col-md-*`.
- **kramdown `parse_block_html: false`** (GFM input): markdown **inside a block `<div>` is not parsed**. For two-column/wrapper layouts, put the structure in a **layout** (where `{{ content }}` is already-rendered HTML) rather than wrapping the markdown body — or set `markdown="1"` on the div.
- **Previewing CSS without a deploy:** no local Jekyll build, but you can fetch the live `main.css`+`tailwind.css`, build a local mock HTML with the real DOM, and render/measure with headless Chrome (`--headless=new --screenshot`, inject a `getBoundingClientRect` readout for geometry). Much faster than the ~1–3 min deploy loop.

See `PROJECT_LOG.md` for the change history.
