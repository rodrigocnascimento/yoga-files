#!/usr/bin/env zsh

emulate -L zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${0:A}")/.." && pwd)"

print "==> yoga-files smoke (zsh)"

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    print -u2 "Missing required command: $1"
    exit 1
  fi
}

need_cmd zsh
need_cmd bash

print "==> syntax: bash"
bash -n "$ROOT_DIR/core/git/git-wizard.sh"
bash -n "$ROOT_DIR/core/version-managers/asdf/interactive.sh"

print "==> syntax: zsh"
zsh -n "$ROOT_DIR/init.sh"
print "==> syntax: zsh"
zsh -n "$ROOT_DIR/install.sh"
zsh -n "$ROOT_DIR/core/utils.sh"
zsh -n "$ROOT_DIR/core/common.sh"
zsh -n "$ROOT_DIR/core/aliases.sh"
zsh -n "$ROOT_DIR/core/functions.sh"
zsh -n "$ROOT_DIR/core/ai/yoga-ai-terminal.sh"

print "==> source init.sh"
zsh -c "export YOGA_HOME='$ROOT_DIR'; export YOGA_SILENT=1; source '$ROOT_DIR/init.sh'; whence -w yoga_status >/dev/null"

print "==> bin/yoga CLI"
zsh -c "export YOGA_HOME='$ROOT_DIR'; export YOGA_SILENT=1; source '$ROOT_DIR/init.sh'; command -v yoga >/dev/null" 2>&1

print "==> bin commands"
zsh -c "export YOGA_HOME='$ROOT_DIR'; export PATH='$ROOT_DIR/bin:'\"\$PATH\"; command -v yoga-ai >/dev/null; yoga-ai --help >/dev/null"
zsh -c "export YOGA_HOME='$ROOT_DIR'; export PATH='$ROOT_DIR/bin:'\"\$PATH\"; command -v yoga-status >/dev/null; yoga-status >/dev/null"
zsh -c "export YOGA_HOME='$ROOT_DIR'; export PATH='$ROOT_DIR/bin:'\"\$PATH\"; command -v yoga-doctor >/dev/null; yoga-doctor >/dev/null"
zsh -c "export YOGA_HOME='$ROOT_DIR'; export PATH='$ROOT_DIR/bin:'\"\$PATH\"; command -v yoga-plugin >/dev/null; yoga-plugin --help >/dev/null"
zsh -c "export YOGA_HOME='$ROOT_DIR'; export PATH='$ROOT_DIR/bin:'\"\$PATH\"; command -v yoga-templates >/dev/null; yoga-templates --help >/dev/null"

print "==> bin/yoga sync"
ROOT_DIR="$ROOT_DIR" zsh -c 'export YOGA_HOME="'$ROOT_DIR'"; export PATH="'$ROOT_DIR/bin':$PATH"; source "'$ROOT_DIR'/init.sh" 2>/dev/null && yoga sync --help >/dev/null'
ROOT_DIR="$ROOT_DIR" zsh -c 'export YOGA_HOME="'$ROOT_DIR'"; export PATH="'$ROOT_DIR/bin':$PATH"; source "'$ROOT_DIR'/init.sh" 2>/dev/null && yoga sync status >/dev/null'

print "==> git wizard (non-interactive)"
bash -c "export YOGA_HOME='$ROOT_DIR'; bash '$ROOT_DIR/core/git/git-wizard.sh' current >/dev/null"

print "OK"
