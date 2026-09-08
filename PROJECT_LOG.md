# Project Log — rebeccawoody.github.io

A running log of notable changes. Newest entries at the top.

## 2026-09-07 — Initial build-out

**Setup & hosting**
- Connected to GitHub over SSH (user `rebeccawoody`); installed & authenticated the `gh` CLI.
- Chose the **al-folio** theme (over academicpages) for the "bio + projects + figures" academic layout.
- Scaffolded al-folio into `/Users/twoody/website` as a clean single-commit repo; `origin` = the GitHub Pages repo, `upstream` = al-folio.
- The existing repo held unmodified **academicpages** boilerplate — superseded it.
- Made the repo **public** (free GitHub Pages requires it) and enabled Pages on the **`gh-pages`** branch. Site went live at https://rebeccawoody.github.io/.
- Removed `plan_for_research_projects.txt` from the repo + history (kept locally, gitignored).

**Home page (`_pages/about.md`)**
- Personalized identity (`_config.yml`, `_data/socials.yml`): name, URL, description, email, GitHub.
- Nav reduced to **Home · Research · CV · Almanac**; hid blog/publications/repositories/teaching/people/submenus.
- Home is bio-only (disabled news, latest-posts, selected-papers).
- Added headshot; profile photo + contact block moved to the left.
- Subtitle: "Astrophysicist · PhD Candidate · Center for Astrophysics | Harvard & Smithsonian, Cambridge, MA".
- Contact block: email, **ADS** link, **ORCID iD** (green academicon + label).

**Look & feel**
- Removed search; locked the site to **light mode** (no theme toggle).
- Page background: light beige (`#faf6ea`) with a subtle gray dot texture (`assets/css/main.scss`).
- Trimmed CI from ~22 al-folio workflows down to just `deploy.yml`.

**Research page (`_pages/projects.md` + `_projects/`)**
- Repurposed the projects page as **Research** (`/research/`); plain single grid, **newest-first** (reverse `importance`).
- **Full-width horizontal cards** (image left, text right) via a local `_includes/projects_horizontal.liquid` override; fixed the image `sizes` hint (was `156px`, causing blur) and re-rasterized figure PDFs at 3000px.
- Smaller card titles (`1.2rem`) to reduce wrapping.
- Cards link to their **ADS** page (`redirect:`); unpublished cards use `no_link: true` (non-clickable). Published cards show an italic **"Published … in … , <bibcode>"** footer via a `published:` field.
- Added the four primary projects (three so far): Metal-poor Milky Way (ApJ 2025), Non-solar Mixing Length (unpublished), Globular Cluster age–metallicity–energy (AJ 2021). Cropped the 3-panel `3dplots.pdf` to its top panel for the last card.

**Cleanup**
- Removed ~173 files of al-folio demo content and dev tooling (demo pages/collections, example assets, `docs/`, `test/`, `bin/`, Docker, agent configs, prettier/pre-commit, issue templates). Kept only what the live site + build need. Emptied `_bibliography/papers.bib` to a placeholder (the `jekyll/scholar` plugin references it).
- Added `CLAUDE.md` (project instructions) and this log.

**Still TODO**
- Fill in the CV (`_data/cv.yml` / `assets/rendercv/`) — currently al-folio placeholder data.
- Build out the **Almanac** (star highlights) — decide if it needs its own collection.
- Add real summary text to the Non-solar Mixing Length card; add its ADS link once published.
- Replace `assets/pdf/example_pdf.pdf` with a real CV PDF.
