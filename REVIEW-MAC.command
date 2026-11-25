#!/bin/bash
cd "$(dirname "$0")" || exit 1
if ! python3 -c 'import sys; assert sys.version_info >= (3,10)' 2>/dev/null; then
  echo 'Install Python 3.10+ from https://www.python.org/downloads/macos/'; read -r -p 'Press Enter to exit'; exit 1
fi
python3 -m hybridx.quickstart --review-only
read -r -p 'Press Enter to exit'
