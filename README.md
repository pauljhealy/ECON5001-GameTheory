# ECON 5001: Game Theory — Lecture Slides

Source for the ECON 5001 lecture slides and the public download site.

**Live site:** https://pauljhealy.github.io/ECON5001-GameTheory/

## How it works

1. Slides are written in LaTeX (`beamer`) in an Overleaf project linked to this repo.
2. Pushing to `main` triggers `.github/workflows/build-pdfs.yml`, which:
   - compiles every standalone `.tex` in `LectureSlides/` plus `Syllabus/syllabus.tex` into PDFs,
   - generates `index.html` from each PDF's title metadata,
   - deploys the PDFs + index to GitHub Pages.
3. On a normal push, only `.tex` files that changed in the last commit are recompiled;
   previously built PDFs persist via the `actions/cache` on the `build/` directory and
   are re-published. A manual **Run workflow** (workflow_dispatch) or the first commit
   recompiles everything — use it after editing the shared preamble, since the per-file
   diff won't detect that it affects every deck.
4. The freshly compiled PDFs are also committed back to the `PDFs/` folder on `main`
   (by the Actions bot, with `[skip ci]`), so a `git pull` on any machine brings the
   latest slides down — no manual download from the site needed. Note: because this
   lands on `main`, a `PDFs/` folder will also appear in the linked Overleaf project
   when you pull there; it's harmless and ignored by compilation.

## Repository layout

| Path | Purpose |
|------|---------|
| `LectureSlides/*.tex` | One standalone beamer deck per lecture. Filename → PDF name. |
| `LectureSlides/xx_*.tex` | Same, but **unlisted** — compiled and deployed, kept off the index. |
| `LectureSlides/includes/metropolis_preamble.tex` | Shared preamble `\include`d by every deck. |
| `LectureSlides/graphics/` | Images used by the slides. |
| `Syllabus/syllabus.tex` | Course syllabus (compiled separately, listed first on the site). |
| `HTML/topstuff.html` | HTML header; the build appends the lecture list and closes the page. |
| `xgames.sty`, `fikz.sty` | Vendored game-theory typesetting package (see below). |
| `Annotated/` | In-class annotated PDFs (`NN_name_PJH.pdf`), published per lecture. |
| `PDFs/` | Compiled slide PDFs, auto-committed by CI (renamed/deleted decks auto-pruned) so they sync via `git pull`. |
| `scripts/sync-annotated.cmd` | Double-click to pull, commit, and push new annotated PDFs. |
| `.github/workflows/build-pdfs.yml` | Build + deploy pipeline. |

## Typesetting games (`xgames`)

Game matrices and trees use the TikZ-based [`xgames`](https://github.com/Slyrk/xgames)
package by Benjamin Bernard (`matrixgame`, `gametree`, `beliefspace`, `automaton`
environments; per-player coloring; overlay-aware; automatic best-response
highlighting). It is **not on CTAN**, so `xgames.sty` and `fikz.sty` are vendored
at the repo root (where `\usepackage{xgames}` resolves both in CI and in Overleaf).
Licenses: `xgames` CC BY-SA 4.0, `fikz` GPL-3.0 — both © Benjamin Bernard, kept
with their original headers.

> Do **not** use the old `sgame` package: its `game` environment is incompatible
> with `array` (loaded by the preamble) and errors with "Missing # inserted in
> alignment preamble".

Minimal 2×2 normal-form game:

```latex
\begin{matrixgame}[top left={C, D}, player names={Player 1, Player 2}, br]
  \payoffmatrix{-1,-1 & -3,0 \\ 0,-3 & -2,-2}
\end{matrixgame}
```

Rows are the left (row) player, columns the top player; each cell is
`payoff1, payoff2`. The `br` key auto-underlines best responses. See the
[xgames documentation](https://carlabernard.ch/beni/downloads/xgames.pdf) for
game trees, belief spaces, and more.

## Spacing shorthand

Use `\bsk` (defined in the preamble) for a `\bigskip` between content blocks.
Note: `\br` is **not** available as a spacing command — xgames reserves it for
best-response underlining inside `matrixgame`.

## Adding a lecture

Create `LectureSlides/NN_name.tex` starting with:

```latex
\include{LectureSlides/includes/metropolis_preamble}

\title[Short]{Full Lecture Title}   % this title appears on the public index
\author[ECON 5001]{ECON 5001\\P.J. Healy} \color{metrop}
\date[]{\vfill {\tiny Updated \today\ at\ \DTMcurrenttime}}

\begin{document}
\frame{\maketitle}
% frames ...
\end{document}
```

Paths to includes/graphics are written relative to the repo root because
`latexmk` runs from there in CI. Push to `main` and the site updates automatically.

## Unlisted decks (`xx_` prefix)

A deck whose filename starts with `xx_` instead of a lecture number — e.g.
`xx_TextErrata.tex`, `xx_SelectionEffects.tex` — is treated as **unlisted**. It
compiles exactly like any other deck, its PDF is deployed to the site and
committed to `PDFs/`, but the index-generation step skips it, so it does not
appear on the public lecture list. Use it for material that isn't a numbered
lecture: the running Bonanno errata, one-off asides, work in progress.

> **Unlisted is not private.** The PDF still sits on the site at its direct URL
> (`.../xx_TextErrata.pdf`) and the `.tex` is in a public repo with full history.
> Exams and solution keys still belong in the separate private repo.

To promote an unlisted deck onto the site, rename it with a lecture number; the
prune step drops the old PDF and the new one is indexed on the next build.

## Publishing in-class annotated slides

You can post the version of a deck you mark up live during lecture:

1. Download the lecture PDF, annotate it during class.
2. Save it into `Annotated/` named `NN_name_PJH.pdf` — matching the lecture's
   source `LectureSlides/NN_name.tex` (e.g. `01_intro.tex` → `01_intro_PJH.pdf`).
3. Double-click `scripts/sync-annotated.cmd`. It pulls, commits the new PDF, and pushes.
4. The build copies it to the site and adds a prominent **"✎ Prof. Healy's
   Annotated Version"** link under that lecture.

See `Annotated/README.md` for the full convention. Overwrite an existing
`_PJH.pdf` to update it; re-run the script to publish the change.

## Year-over-year versioning

`main` always reflects the current offering. When a term ends, snapshot it with
an annotated git tag. The tag is immutable, browsable on GitHub, and lets you
diff or restore individual files across years without any branching.

**Cutting an end-of-term snapshot (e.g., Autumn 2026):**

```sh
git tag -a aut2026 -m "Autumn 2026 final"
git push origin aut2026
```

That's it. To also publish the compiled PDFs as a named GitHub Release so
students can download last year's slides directly:

```sh
gh release create aut2026 --title "Autumn 2026" \
  --notes "Final slides and syllabus, Autumn 2026." \
  build/*.pdf
```

(Run `gh workflow run "build-pdfs.yml"` first if `build/` is stale, or
download the artifacts from the last CI run.)

**Starting the next year:** just edit `main` as usual — it already contains the
previous year's content, so you're naturally building on it. Update
`HTML/topstuff.html` to reflect the new term. Push, and the live site updates.

**Cross-year diffs and restores:**

```sh
# What changed in a specific lecture since last year:
git diff aut2026 -- LectureSlides/05_nash.tex

# Pull back last year's version of a file (then edit as needed):
git checkout aut2026 -- LectureSlides/05_nash.tex
```

**Exams and solutions must not live here** — this repo is public, including
its full history. Keep exams, solution keys, and grading materials in a
separate **private** repository and apply the same annual-tag discipline there.
