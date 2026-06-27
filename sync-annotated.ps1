<#
.SYNOPSIS
  One-click sync for in-class annotated slides.

.DESCRIPTION
  Run this after class once you've dropped your annotated PDF(s) into the
  Annotated\ folder (named NN_name_PJH.pdf). It pulls the latest from GitHub,
  stages anything new/changed under Annotated\, commits, and pushes. The push
  triggers the GitHub Actions build, which republishes the site with a
  "Prof. Healy's Annotated Version" link under the matching lecture.

  Double-click this file, or make a desktop shortcut to:
    powershell -ExecutionPolicy Bypass -File "<repo>\sync-annotated.ps1"

.NOTES
  Safe to run anytime. If there's nothing new in Annotated\, it does nothing.
#>

$ErrorActionPreference = 'Stop'

# Repo root = the folder this script lives in.
$RepoRoot = $PSScriptRoot
Set-Location $RepoRoot

Write-Host "== Sync annotated slides ==" -ForegroundColor Cyan
Write-Host "Repo: $RepoRoot`n"

# 1. Make sure we're in a git repo.
try { git rev-parse --is-inside-work-tree | Out-Null }
catch { Write-Host "ERROR: this folder is not a git repository." -ForegroundColor Red; Read-Host "Press Enter to close"; exit 1 }

# 2. Pull latest (rebase so our local annotated commits stack cleanly on top
#    of any Overleaf pushes). Autostash guards against stray local edits.
Write-Host "Pulling latest from GitHub..." -ForegroundColor Yellow
git pull --rebase --autostash
if ($LASTEXITCODE -ne 0) {
    Write-Host "`nPull failed (likely a merge conflict). Resolve it, then re-run." -ForegroundColor Red
    Read-Host "Press Enter to close"; exit 1
}

# 3. Stage only the Annotated folder.
git add Annotated

# 4. Anything to commit?
git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "`nNothing new in Annotated\ — already up to date." -ForegroundColor Green
    Read-Host "Press Enter to close"; exit 0
}

# 5. Show what we're about to push.
Write-Host "`nStaging these annotated files:" -ForegroundColor Yellow
git diff --cached --name-only

# 6. Commit + push.
$stamp = Get-Date -Format "yyyy-MM-dd HH:mm"
git commit -m "Add annotated slides ($stamp)" | Out-Null
Write-Host "`nPushing to GitHub..." -ForegroundColor Yellow
git push
if ($LASTEXITCODE -ne 0) {
    Write-Host "`nPush failed. Check your connection / credentials and re-run." -ForegroundColor Red
    Read-Host "Press Enter to close"; exit 1
}

Write-Host "`nDone. The site will update in a minute or two." -ForegroundColor Green
Read-Host "Press Enter to close"
