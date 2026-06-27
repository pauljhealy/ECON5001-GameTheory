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

## Repository layout

| Path | Purpose |
|------|---------|
| `LectureSlides/*.tex` | One standalone beamer deck per lecture. Filename → PDF name. |
| `LectureSlides/includes/metropolis_preamble.tex` | Shared preamble `\include`d by every deck. |
| `LectureSlides/graphics/` | Images used by the slides. |
| `Syllabus/syllabus.tex` | Course syllabus (compiled separately, listed first on the site). |
| `topstuff.html` | HTML header; the build appends the lecture list and closes the page. |
| `kcb.css`, `syllabus.css` | Site styling (copied into the published site). |
| `latexmkrc` | Sets the timezone for `\today` timestamps. |
| `xgames.sty`, `fikz.sty` | Vendored game-theory typesetting package (see below). |
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
`payoff1, payoff2`. The `br` key auto-underlines best responses. See
`LectureSlides/01_intro.tex` for a worked example and the
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
