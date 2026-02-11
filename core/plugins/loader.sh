#!/bin/zsh

# Loads enabled plugins from $YOGA_HOME/plugins.

YOGA_HOME="${YOGA_HOME:-$HOME/.yoga}"

_yoga_plugins_config_file() {
  if [ -f "$YOGA_HOME/config/config.yaml" ]; then
    echo "$YOGA_HOME/config/config.yaml"
    return 0
  fi
  if [ -f "$YOGA_HOME/config.yaml" ]; then
    echo "$YOGA_HOME/config.yaml"
    return 0
  fi
  echo ""
}

_yoga_plugins_enabled() {
  local cfg
  cfg="$(_yoga_plugins_config_file)"
  [ -n "$cfg" ] || return 0

  # Parse:
  # plugins:
  #   enabled:
  #     - name
  awk '
    /^[[:space:]]*plugins:[[:space:]]*$/ {in_plugins=1; next}
    in_plugins && /^[[:space:]]*enabled:[[:space:]]*$/ {in_enabled=1; next}
    in_enabled && /^[[:space:]]*-[[:space:]]*/ {
      v=$0
      sub(/^[[:space:]]*-[[:space:]]*/, "", v)
      gsub(/"/, "", v)
      gsub(/[[:space:]]+$/, "", v)
      print v
      next
    }
    in_plugins && !/^[[:space:]]/ {in_plugins=0; in_enabled=0}
  ' "$cfg" 2>/dev/null
}

yoga_plugins_load() {
  local plugin
  local plugin_file

  [ -d "$YOGA_HOME/plugins" ] || return 0

  for plugin in $(_yoga_plugins_enabled); do
    [ -n "$plugin" ] || continue
    plugin_file="$YOGA_HOME/plugins/$plugin/plugin.zsh"
    if [ -f "$plugin_file" ]; then
      # shellcheck disable=SC1090
      source "$plugin_file"
      if typeset -f "yoga_plugin_init" >/dev/null 2>&1; then
        yoga_plugin_init "$plugin" || true
        unfunction yoga_plugin_init 2>/dev/null || true
      fi
    fi
  done
}
