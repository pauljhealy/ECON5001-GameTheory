# ECON 5001: Game Theory — Lecture Slides

Source for the ECON 5001 lecture slides and the public download site.

**Live site:** https://pauljhealy.github.io/ECON5001-GameTheory/

## How it works

1. Slides are written in LaTeX (`beamer`) in an Overleaf project linked to this repo.
2. Pushing to `main` triggers `.github/workflows/build-pdfs.yml`, which:
   - compiles every standalone `.tex` in `LectureSlides/` plus `Syllabus/syllabus.tex` into PDFs,
   - generates `index.html` from each PDF's title metadata,
   - deploys the PDFs + index to GitHub Pages.
3. On a normal push, only `.tex` files that changed in the last commit are recompiled
   (previously built PDFs are pulled from the `gh-pages` branch). A manual
   **Run workflow** (workflow_dispatch) or the first commit recompiles everything.

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
| `.github/workflows/build-pdfs.yml` | Build + deploy pipeline. |

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
