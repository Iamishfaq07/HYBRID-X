@echo off
setlocal
cd /d "%~dp0"
py -3 -c "import sys; assert sys.version_info >= (3,10)" >nul 2>&1
if not errorlevel 1 goto run
python -c "import sys; assert sys.version_info >= (3,10)" >nul 2>&1
if not errorlevel 1 goto runpython
echo Python 3.10+ required.
where winget >nul 2>&1
if errorlevel 1 goto manual
choice /c YN /n /m "Install official Python 3.12 using Windows Package Manager? [Y/N] "
if errorlevel 2 goto manual
winget install --id Python.Python.3.12 --exact --source winget --scope user
if errorlevel 1 goto manual
echo Installation finished. Close this window and double-click START-WINDOWS.cmd again.
pause
exit /b 0
:manual
echo Install Python from https://www.python.org/downloads/windows/ then rerun this launcher.
pause
exit /b 1
:run
py -3 -m hybridx.quickstart
goto done
:runpython
python -m hybridx.quickstart
:done
pause
