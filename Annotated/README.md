# Annotated (in-class) slides

Drop the slides you annotate during lecture here.

## Naming convention

For a lecture whose source is `LectureSlides/NN_name.tex` (compiled to
`NN_name.pdf`), name the annotated copy:

```
NN_name_PJH.pdf
```

Examples:

| Lecture source | Compiled PDF | Annotated copy goes here |
|----------------|--------------|--------------------------|
| `LectureSlides/01_intro.tex` | `01_intro.pdf` | `Annotated/01_intro_PJH.pdf` |
| `LectureSlides/02_dominance.tex` | `02_dominance.pdf` | `Annotated/02_dominance_PJH.pdf` |

The build matches the `_PJH.pdf` suffix back to its lecture and adds a
prominent **"✎ Prof. Healy's Annotated Version"** download link under that
lecture on the public site. A file that doesn't match any lecture is simply
ignored.

## Workflow

1. Download the lecture PDF and annotate it during class.
2. Save it here as `NN_name_PJH.pdf` (overwrite to update an existing one).
3. Double-click `scripts\sync-annotated.cmd`. It pulls, commits, and pushes.
4. GitHub Actions rebuilds the site; the annotated link appears within a
   couple of minutes.
