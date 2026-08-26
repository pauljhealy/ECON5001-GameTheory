# Annotated (in-class) slides

Drop the slides you annotate during lecture here.

## Naming convention

For a lecture whose source is `LectureSlides/NN_name.tex` (compiled to
`NN_name.pdf`), name the annotated copy after the class meeting it came from:

| File | Meaning |
|------|---------|
| `NN_name_PJH1.pdf` | First class meeting spent on this deck |
| `NN_name_PJH2.pdf` | Second meeting, and so on, up to `_PJH9` |
| `NN_name_PJH.pdf` | No number: the whole deck was covered in one meeting |

Examples:

| Lecture source | Annotated copies |
|----------------|------------------|
| `LectureSlides/02_mathreview.tex` (two classes) | `Annotated/02_mathreview_PJH1.pdf`, `Annotated/02_mathreview_PJH2.pdf` |
| `LectureSlides/01_intro.tex` (one class) | `Annotated/01_intro_PJH.pdf` |

The build matches each file back to its lecture and adds a link under that
lecture on the public site — **"✎ Prof. Healy's Annotated Version (Part N)"**
for a numbered file, **"✎ Prof. Healy's Annotated Version"** for the unnumbered
one — each followed by `(annotated YYYY-MM-DD)`. Parts are listed in order, and
gaps are harmless: `_PJH1` and `_PJH3` with no `_PJH2` simply lists Part 1 and
Part 3. A file that doesn't match any lecture is ignored, as is one attached to
an unlisted (`xx_`) deck.

## Where that date comes from

`(annotated ...)` is the PDF's internal **`ModDate`** — when the annotation app
last wrote the file, which is the class meeting itself — converted to
America/New_York.

It is deliberately **not** `CreationDate`. Xournal++ (like most annotators)
carries `CreationDate` over from the compiled deck, so it records when latexmk
built the slides: usually the night before class, sometimes days earlier. On
`02_mathreview_PJH1.pdf`, for example, `CreationDate` is 2026-08-25 01:04 (the
build) while `ModDate` is 2026-08-25 11:01 (the class).

If `ModDate` equals `CreationDate` — nothing ever re-stamped the file — the
build falls back to the date the annotated PDF was committed, and failing that
to the PDF's own timestamp.

## Workflow

1. Download the lecture PDF and annotate it during class.
2. Save it here as `NN_name_PJHn.pdf` (overwrite to update an existing one).
3. Double-click `scripts\sync-annotated.cmd`. It pulls, commits, and pushes.
4. GitHub Actions rebuilds the site; the links appear within a couple of
   minutes.

## Removing one

Delete the file and push. The build prunes any annotated PDF in the deployed
site that no longer has a file here, so it drops off the site on the next run.
