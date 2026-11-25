#!/bin/bash
cd "$(dirname "$0")" || exit 1
python3 -m hybridx.quickstart --menu
read -r -p 'Press Enter to exit'
