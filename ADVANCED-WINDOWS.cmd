@echo off
cd /d "%~dp0"
py -3 -m hybridx.quickstart --menu
if errorlevel 1 echo If Python launcher is unavailable, run python -m hybridx.quickstart --menu
pause
