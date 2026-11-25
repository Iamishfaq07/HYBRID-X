@echo off
setlocal
cd /d "%~dp0"
py -3 -m compileall -q hybridx || exit /b 1
py -3 -m unittest discover -s tests -v || exit /b 1
where cmake >nul 2>&1
if errorlevel 1 goto done
cmake -S native -B build -DCMAKE_BUILD_TYPE=Release || exit /b 1
cmake --build build --config Release || exit /b 1
ctest --test-dir build -C Release --output-on-failure || exit /b 1
:done
echo Source tests complete. Native checks require CMake and a C++ compiler.
pause
