#!/usr/bin/env bash
# use with:
# source shell-env.sh

set -euo pipefail

echo "Setting up environment for Linux..."

export PATH="$(dirname "$0")/tools:${PATH}"

if ! command -v gcc >/dev/null 2>&1; then
  echo "gcc missing — install build tools:"
  echo "  sudo apt update && sudo apt install -y build-essential"
fi

echo "Done."
