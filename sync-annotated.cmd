@echo off
REM Double-click launcher for sync-annotated.ps1.
REM Windows opens .ps1 files in an editor on double-click; a .cmd file runs.
REM %~dp0 expands to this file's own folder (the repo root), so it finds the
REM script no matter where the repo is cloned or what the machine is named.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync-annotated.ps1"
