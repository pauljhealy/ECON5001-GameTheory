<#
.SYNOPSIS
  One-click sync for in-class annotated slides.

.DESCRIPTION
  Run this after class once you've dropped your annotated PDF(s) into the
  Annotated\ folder (named NN_name_PJH.pdf). It pulls the latest from GitHub,
  stages anything new/changed under Annotated\, commits, and pushes. The push
  triggers the GitHub Actions build, which republishes the site with a
  "Prof. Healy's Annotated Version" link under the matching lecture.

  Normally launched by double-clicking sync-annotated.cmd next to it.

.NOTES
  Safe to run anytime. If there's nothing new in Annotated\, it does nothing.
#>

# NOTE: do NOT set $ErrorActionPreference = 'Stop'. In Windows PowerShell 5.1
# that turns git's normal stderr output (e.g. "From github.com ...") into a
# fatal error and kills the script. We check $LASTEXITCODE after each git call
# instead. The trap below guarantees the window stays open on any surprise.
trap {
    Write-Host "`nUnexpected error:" -ForegroundColor Red
    Write-Host $_ -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

# Repo root = the folder this script lives in (fall back to current dir).
$RepoRoot = $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($RepoRoot)) { $RepoRoot = (Get-Location).Path }
Set-Location -LiteralPath $RepoRoot

Write-Host "== Sync annotated slides ==" -ForegroundColor Cyan
Write-Host "Repo: $RepoRoot`n"

# 0. Is git available on PATH? (GitHub Desktop bundles git but often doesn't
#    add it to PATH, so a standalone PowerShell can't see it.)
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: 'git' is not on your PATH." -ForegroundColor Red
    Write-Host "Install Git for Windows (winget install Git.Git) and reopen, or add"
    Write-Host "GitHub Desktop's bundled git to PATH. Then run this again."
    Read-Host "Press Enter to close"
    exit 1
}

# 1. Confirm this folder is a git repo.
git rev-parse --is-inside-work-tree | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: $RepoRoot is not a git repository." -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

# 2. Pull latest (rebase so local annotated commits stack on top of any Overleaf
#    pushes). Autostash guards against stray local edits.
Write-Host "Pulling latest from GitHub..." -ForegroundColor Yellow
git pull --rebase --autostash
if ($LASTEXITCODE -ne 0) {
    Write-Host "`nPull failed (likely a merge conflict). Resolve it, then re-run." -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

# 3. Stage only the Annotated folder.
git add Annotated

# 4. Anything new to commit?
git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "`nNothing new in Annotated\ -- already up to date." -ForegroundColor Green
    Read-Host "Press Enter to close"
    exit 0
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
    Read-Host "Press Enter to close"
    exit 1
}

Write-Host "`nDone. The site will update in a minute or two." -ForegroundColor Green
Read-Host "Press Enter to close"
