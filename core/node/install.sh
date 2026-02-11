#!/usr/bin/env zsh

emulate -L zsh
set -euo pipefail

YOGA_HOME="${YOGA_HOME:-$HOME/.yoga}"

DIR="${0:A:h}"
source "$DIR/../utils.sh"

load_asdf() {
  if [ -f "$HOME/.asdf/asdf.sh" ]; then
    source "$HOME/.asdf/asdf.sh"
    return 0
  fi

  yoga_fogo "❌ ASDF not found. Install ASDF first."
  return 1
}

read_node_version_from_config() {
  local cfg=""
  if [ -f "$YOGA_HOME/config/config.yaml" ]; then
    cfg="$YOGA_HOME/config/config.yaml"
  elif [ -f "$YOGA_HOME/config.yaml" ]; then
    cfg="$YOGA_HOME/config.yaml"
  else
    print ""
    return 0
  fi

  awk '
    /^[[:space:]]*tools:[[:space:]]*$/ {in_tools=1; next}
    in_tools && /^[[:space:]]*node:[[:space:]]*$/ {in_node=1; next}
    in_node && /^[[:space:]]*version:[[:space:]]*/ {
      v=$0
      sub(/^[^:]*:[[:space:]]*/, "", v)
      gsub(/"/, "", v)
      gsub(/[[:space:]]+$/, "", v)
      print v
      exit
    }
    in_tools && !/^[[:space:]]/ { in_tools=0; in_node=0 }
  ' "$cfg" 2>/dev/null | head -n1
}

ensure_nodejs_plugin() {
  if asdf plugin list 2>/dev/null | grep -q '^nodejs$'; then
    return 0
  fi

  yoga_action "asdf" "Adding nodejs plugin"
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

  if [ -x "$HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring" ]; then
    bash "$HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring" || true
  fi
}

install_node() {
  local version
  version="$(read_node_version_from_config)"
  if [ -z "$version" ]; then
    version="latest:20"
  fi

  yoga_action "asdf" "Installing nodejs $version"
  asdf install nodejs "$version" || true

  yoga_action "asdf" "Setting global nodejs $version"
  asdf global nodejs "$version"

  if command -v node >/dev/null 2>&1; then
    yoga_success "Node.js $(node -v)"
  fi
  if command -v npm >/dev/null 2>&1; then
    yoga_success "npm v$(npm -v)"
  fi
}

install_global_js_tools() {
  if ! command -v npm >/dev/null 2>&1; then
    yoga_warn "npm not available yet; skipping global JS tools"
    return 0
  fi

  yoga_action "npm" "Installing global JS tools (biome, typescript, tsx)"
  npm install -g @biomejs/biome typescript tsx || true
}

main() {
  load_asdf
  ensure_nodejs_plugin
  install_node
  install_global_js_tools
}

main "$@"
