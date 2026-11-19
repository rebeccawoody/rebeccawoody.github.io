# Git & GitHub Pages Cheatsheet — rebeccawoody.github.io

A practical, copy-paste reference for editing and publishing the website.
Everything here assumes you're working inside `/Users/twoody/website`.

> **The one-line mental model:** You edit files → **commit** (save a snapshot) →
> **push** (send it to GitHub) → GitHub **builds** the site → GitHub **publishes**
> it to the live URL. Publishing is TWO separate GitHub stages, and the second
> one is the one people forget to check.

---

## 0. Golden rules (read once)

- **You work on the `master` branch.** Not `main`. The live site is built from
  `master`. If you ever see `main`, see [Fixing a stray `main` branch](#fixing-a-stray-main-branch).
- **Always add `-R rebeccawoody/rebeccawoody.github.io` to every `gh` command.**
  Without it, `gh` talks to the wrong repo (the al-folio `upstream`) and shows
  you the wrong workflow runs.
- **You can't build the site locally** (no working Jekyll here). You verify by
  pushing and checking the live URL — never by running `jekyll build`.
- **A green `deploy.yml` run does NOT mean it's live.** There's a second publish
  stage that can fail on its own. See [Step 4](#step-4--verify-it-actually-went-live).

---

## 1. The everyday workflow (the 90% case)

You've edited one or more files (e.g. `_almanac/albireo.md`). To get them live:

```bash
cd /Users/twoody/website

# 1. See what you changed
git status                 # lists modified/new files
git diff                   # shows the actual line-by-line changes

# 2. Stage the changes you want to publish
git add _almanac/albireo.md        # a specific file
# or:
git add -A                         # everything that changed

# 3. Commit (save a snapshot with a message)
git commit -m "Almanac/Albireo: tighten the intro and add Deneb pointer"

# 4. Push to GitHub (this kicks off the build)
git push
```

That's it for the git side. Now GitHub takes over — go to [Step 4](#step-4--verify-it-actually-went-live) to confirm it published.

---

## 2. What each git step actually does

| Command | What it does | Where it lives |
|---|---|---|
| `git add <file>` | Marks a change to be included in the next commit ("staging") | Local only |
| `git commit -m "..."` | Saves a permanent snapshot of staged changes | Local only |
| `git push` | Uploads your commits to GitHub (`origin/master`) | → GitHub |

**Key point:** `commit` is local. Nothing reaches GitHub (and nothing can go
live) until you `push`. You can make several commits and then push them all at
once.

---

## 3. What happens on GitHub after you push (the pipeline)

Pushing to `master` triggers **two separate stages**. This is the part that
tripped us up before, so it's worth knowing:

```
  git push
     │
     ▼
┌─────────────────────────────┐
│ STAGE 1: "Deploy site"      │   ← your custom Action (deploy.yml)
│ Builds Jekyll, writes the   │     Builds the HTML and pushes it
│ finished HTML to the        │     to the `gh-pages` branch.
│ gh-pages branch             │
└─────────────────────────────┘
     │
     ▼
┌─────────────────────────────┐
│ STAGE 2: "pages build and   │   ← GitHub's OWN publish step
│ deployment"                 │     Takes gh-pages and pushes it to
│ Publishes gh-pages to the   │     the live CDN (the actual URL).
│ live site                   │
└─────────────────────────────┘
     │
     ▼
  https://rebeccawoody.github.io/  (live, ~30–60s later)
```

**Both must succeed for your change to appear.** `deploy.yml` can go green while
Stage 2 fails (e.g. a GitHub 502 server hiccup), leaving the live site stuck on
the old version. That's exactly what happened on 2026-11-18.

---

## 4. Verify it actually went live

After every push, run through this. Takes about two minutes.

```bash
cd /Users/twoody/website

# A) Check BOTH stages at once (no --workflow filter = you see everything)
gh run list -R rebeccawoody/rebeccawoody.github.io --limit 5
```

You want to see BOTH of these as `completed success` for your commit:
- `Deploy site` (push, on `master`)
- `pages build and deployment` (on `gh-pages`)

```bash
# B) Confirm the live page actually changed.
#    Check the last-modified date — it should be TODAY, not an old date.
curl -sI "https://rebeccawoody.github.io/almanac/albireo/" | grep -i last-modified

# C) Grep the live HTML for a phrase you just added
curl -s "https://rebeccawoody.github.io/almanac/albireo/" | grep "first got me hooked"
```

Publishing lags the build by ~30–60s, so if it's not there immediately, wait a
minute and re-run B/C.

**Finally, in your browser:** hard-refresh with `Cmd+Shift+R`. Your browser
aggressively caches `.webp` images and `main.css` — a normal refresh may show
stale versions even when the server is correct.

---

## 5. Troubleshooting

### The build "succeeded" but my changes aren't live

This is the 502 situation. The `Deploy site` run is green but Stage 2 failed.

```bash
# 1. Look for a FAILED "pages build and deployment" run
gh run list -R rebeccawoody/rebeccawoody.github.io --limit 5

# 2. Confirm your content really is in gh-pages (build was fine, publish wasn't)
git fetch origin
git show origin/gh-pages:almanac/albireo/index.html | grep "first got me hooked"
#   ↑ if this prints your new text, the build worked — it's a publish failure

# 3. Re-run the failed publish job (use its run ID from step 1)
gh run rerun -R rebeccawoody/rebeccawoody.github.io <RUN_ID>

# 4. Wait ~1 min, then re-verify with Step 4 above
```

### A build genuinely failed (red X on "Deploy site")

```bash
# Find the failing run's ID
gh run list -R rebeccawoody/rebeccawoody.github.io --workflow deploy.yml --limit 1

# Read only the error lines
gh run view -R rebeccawoody/rebeccawoody.github.io <RUN_ID> --log-failed
```

Common Jekyll build killers (from CLAUDE.md):
- An empty-but-present key in `_data/socials.yml` → comment the key out, never leave it blank.
- A literal `|` in body text → Markdown reads it as a table. Reword or escape as `\|`.
- Use `&amp;` instead of a bare `&` in text.

### I pushed but nothing happened at all

Check you're on `master` and that the push actually left your machine:

```bash
git status                 # should say "On branch master"
git log origin/master -1   # should show your latest commit
```

If `git log origin/master` doesn't show your commit, the push didn't land — scroll
up for an error, then `git push` again.

---

## 6. Fixing a stray `main` branch

If `git status` says `On branch main` (Git sometimes creates this as a default),
your commits are on the wrong branch and won't deploy. Fix:

```bash
git branch -m main master                           # rename main → master
git branch --set-upstream-to=origin/master master   # point it at the live branch
git push origin master                              # publish
```

Do **not** run `git push --set-upstream origin main` — that creates a second,
non-deploying branch on GitHub.

---

## 7. Handy extras

```bash
# Discard uncommitted changes to a file (careful — unrecoverable)
git checkout -- _almanac/albireo.md

# Unstage a file you git-added but don't want in this commit
git restore --staged _almanac/albireo.md

# See recent history
git log --oneline -10

# Pull the latest from GitHub (if you edited via the web UI or another machine)
git pull

# Watch a run live until it finishes
gh run watch -R rebeccawoody/rebeccawoody.github.io <RUN_ID>
```

---

## 8. Quick reference card

```
EDIT → git add -A → git commit -m "msg" → git push
                                            │
                                            ▼
          gh run list -R rebeccawoody/rebeccawoody.github.io --limit 5
          (want BOTH "Deploy site" AND "pages build and deployment" green)
                                            │
                                            ▼
          curl -sI <url> | grep last-modified   (date should be today)
                                            │
                                            ▼
                     Cmd+Shift+R in the browser
```

If live is stale but gh-pages has your content → re-run the failed
`pages build and deployment` job. See [Step 5](#5-troubleshooting).
