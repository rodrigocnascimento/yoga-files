#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> yoga-files smoke (bash)"

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

need_cmd bash
need_cmd zsh

echo "==> syntax: bash"
bash -n "$ROOT_DIR/core/git/git-wizard.sh"
bash -n "$ROOT_DIR/core/version-managers/asdf/interactive.sh"

echo "==> syntax: zsh"
zsh -n "$ROOT_DIR/init.sh"
bash -n "$ROOT_DIR/install.sh"
zsh -n "$ROOT_DIR/core/utils.sh"
zsh -n "$ROOT_DIR/core/common.sh"
zsh -n "$ROOT_DIR/core/aliases.sh"
zsh -n "$ROOT_DIR/core/functions.sh"
zsh -n "$ROOT_DIR/core/dashboard.sh"
zsh -n "$ROOT_DIR/core/ai/yoga-ai-terminal.sh"

echo "==> source init.sh in bash"
bash -c "export YOGA_HOME='$ROOT_DIR'; export YOGA_SILENT=1; source '$ROOT_DIR/init.sh'; type yoga_dashboard >/dev/null"

echo "==> bin commands"
bash -c "export YOGA_HOME='$ROOT_DIR'; export PATH='$ROOT_DIR/bin:'\"\$PATH\"; command -v yoga-ai >/dev/null; yoga-ai --help >/dev/null"
bash -c "export YOGA_HOME='$ROOT_DIR'; export PATH='$ROOT_DIR/bin:'\"\$PATH\"; command -v yoga-status >/dev/null; yoga-status >/dev/null"
bash -c "export YOGA_HOME='$ROOT_DIR'; export PATH='$ROOT_DIR/bin:'\"\$PATH\"; command -v yoga-doctor >/dev/null; yoga-doctor >/dev/null"

echo "OK"
