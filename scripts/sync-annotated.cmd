@echo off
REM ===================================================================
REM  One-click sync for in-class annotated slides.
REM
REM  Drop your annotated PDF(s) into the Annotated\ folder (named
REM  NN_name_PJH.pdf), then double-click this file. It pulls the latest
REM  from GitHub, stages/commits anything new under Annotated\, and
REM  pushes. The push triggers the site rebuild.
REM
REM  Written as a plain batch script on purpose: it needs no PowerShell,
REM  so a locked-down execution policy can't block it.
REM ===================================================================
setlocal
REM This script lives in scripts\; cd to its parent (the repo root) so the
REM git commands below run against the repository.
cd /d "%~dp0.."

echo == Sync annotated slides ==
echo Repo: %cd%
echo.

where git >nul 2>nul
if errorlevel 1 (
  echo ERROR: "git" is not on your PATH.
  echo Install Git for Windows with:  winget install Git.Git
  echo then close and reopen this window, and run again.
  echo.
  pause
  exit /b 1
)

echo Pulling latest from GitHub...
git pull --rebase --autostash
if errorlevel 1 (
  echo.
  echo Pull failed -- likely a merge conflict. Resolve it, then re-run.
  echo.
  pause
  exit /b 1
)

git add Annotated

git diff --cached --quiet
if not errorlevel 1 (
  echo.
  echo Nothing new in Annotated\ -- already up to date.
  echo.
  pause
  exit /b 0
)

echo.
echo Staging these annotated files:
git diff --cached --name-only

git commit -m "Add annotated slides (%DATE% %TIME%)"

echo.
echo Pushing to GitHub...
git push
if errorlevel 1 (
  echo.
  echo Push failed. Check your connection / credentials and re-run.
  echo.
  pause
  exit /b 1
)

echo.
echo Done. The site will update in a minute or two.
echo.
pause
