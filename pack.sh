#!/bin/bash
set -euo pipefail

# pack
mkdir -p build
rm build/environment.tar.gz
conda-pack -j -1 -o build/environment.tar.gz