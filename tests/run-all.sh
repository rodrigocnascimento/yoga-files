#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

chmod +x "$ROOT_DIR/tests/smoke.zsh" "$ROOT_DIR/tests/smoke.bash" 2>/dev/null || true

zsh "$ROOT_DIR/tests/smoke.zsh"
bash "$ROOT_DIR/tests/smoke.bash"

echo "All tests passed."
