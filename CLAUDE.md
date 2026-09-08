# CLAUDE.md — rebeccawoody.github.io

Personal academic website for **Rebecca Woody** (astrophysicist, PhD candidate, CfA | Harvard & Smithsonian).
Built on the **al-folio** Jekyll theme. Live at **https://rebeccawoody.github.io/**.

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

See `PROJECT_LOG.md` for the change history.
