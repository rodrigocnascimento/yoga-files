#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${0}")/.." && pwd)"

echo "==> yoga-files smoke (bash)"

need_cmd() {
	if ! command -v "$1" >/dev/null 2>&1; then
		echo "Missing required command: $1" >&2
		exit 1
	fi
}

need_cmd bash

echo "==> syntax: bash"
bash -n "$ROOT_DIR/core/git/git-wizard.sh"
bash -n "$ROOT_DIR/core/version-managers/asdf/interactive.sh"

echo "==> syntax: zsh"
bash -n "$ROOT_DIR/init.sh"
bash -n "$ROOT_DIR/install.sh"
bash -n "$ROOT_DIR/core/utils.sh"
bash -n "$ROOT_DIR/core/common.sh"
bash -n "$ROOT_DIR/core/aliases.sh"
bash -n "$ROOT_DIR/core/functions.sh"
bash -n "$ROOT_DIR/core/ai/yoga-ai-terminal.sh"

echo "==> source init.sh in bash"
bash -c "export YOGA_HOME='$ROOT_DIR'; export YOGA_SILENT=1; source '$ROOT_DIR/init.sh'"

echo "==> bin/yoga CLI"
bash -c "export YOGA_HOME='$ROOT_DIR'; export YOGA_SILENT=1; source '$ROOT_DIR/init.sh'; command -v yoga >/dev/null"

echo "==> bin commands"
bash -c "export YOGA_HOME='$ROOT_DIR'; export PATH='$ROOT_DIR/bin:'\"\$PATH\"; command -v yoga-ai >/dev/null"
bash -c "export YOGA_HOME='$ROOT_DIR'; export PATH='$ROOT_DIR/bin:'\"\$PATH\"; command -v yoga-status >/dev/null"
bash -c "export YOGA_HOME='$ROOT_DIR'; export PATH='$ROOT_DIR/bin:'\"\$PATH\"; command -v yoga-doctor >/dev/null"
bash -c "export YOGA_HOME='$ROOT_DIR'; export PATH='$ROOT_DIR/bin:'\"\$PATH\"; command -v yoga-plugin >/dev/null"
bash -c "export YOGA_HOME='$ROOT_DIR'; export PATH='$ROOT_DIR/bin:'\"\$PATH\"; command -v yoga-templates >/dev/null"

echo "==> bin/yoga help"
bash -c "export YOGA_HOME='$ROOT_DIR'; export PATH='$ROOT_DIR/bin:'\"\$PATH\"; source '$ROOT_DIR/init.sh' 2>/dev/null; yoga --help >/dev/null"

echo "OK"
