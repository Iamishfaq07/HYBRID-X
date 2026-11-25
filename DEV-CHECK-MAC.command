#!/bin/bash
set -eu
cd "$(dirname "$0")"
python3 -m compileall -q hybridx
python3 -m unittest discover -s tests -v
if command -v cmake >/dev/null; then
  cmake -S native -B build -DCMAKE_BUILD_TYPE=Release
  cmake --build build --config Release
  ctest --test-dir build -C Release --output-on-failure
fi
