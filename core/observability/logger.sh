#!/bin/zsh

# Opt-in observability logger.
# Writes minimal JSONL logs to $YOGA_HOME/logs/yoga.jsonl when enabled.

YOGA_HOME="${YOGA_HOME:-$HOME/.yoga}"

_yoga_obs_config_file() {
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

_yoga_obs_enabled() {
  local cfg
  cfg="$(_yoga_obs_config_file)"
  [ -n "$cfg" ] || return 1

  local v
  v="$(awk '
    /^[[:space:]]*observability:[[:space:]]*$/ {o=1; next}
    o && /^[[:space:]]*enabled:[[:space:]]*/ {v=$0; sub(/^[^:]*:[[:space:]]*/, "", v); gsub(/"/, "", v); gsub(/[[:space:]]+$/, "", v); print v; exit}
    o && !/^[[:space:]]/ {o=0}
  ' "$cfg" 2>/dev/null)"

  [ "$v" = "true" ]
}

_yoga_obs_log_file() {
  echo "$YOGA_HOME/logs/yoga.jsonl"
}

yoga_obs_log() {
  local event="$1"
  shift || true

  _yoga_obs_enabled || return 0

  mkdir -p "$YOGA_HOME/logs"

  local ts
  ts="$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date)"

  if command -v jq >/dev/null 2>&1; then
    jq -nc \
      --arg ts "$ts" \
      --arg event "$event" \
      --arg msg "${*:-}" \
      '{ts:$ts,event:$event,msg:$msg}' >> "$(_yoga_obs_log_file)" 2>/dev/null || true
  else
    echo "$ts $event ${*:-}" >> "$(_yoga_obs_log_file)" 2>/dev/null || true
  fi
}
