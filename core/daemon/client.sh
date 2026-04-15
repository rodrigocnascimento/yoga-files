#!/usr/bin/env zsh
# 🔌 core/daemon/client.sh
# @name: daemon-client
# @desc: Unix Socket Client for Yoga 3.0 CLI 🔌
# @usage: source "$YOGA_HOME/core/daemon/client.sh"
# @author: Yoga 3.0 Lôro Barizon Edition 🦜

emulate -L zsh
set -euo pipefail

# 🏠 Config
YOGA_SOCKET="${YOGA_HOME}/daemon.sock"
[[ -z "${DELIMITER:-}" ]] && readonly DELIMITER=$'\x1E'
[[ -z "${TIMEOUT:-}" ]] && readonly TIMEOUT=5

# 📦 Source
source "${YOGA_HOME}/core/utils/ui.sh"

# ═══════════════════════════════════════════════════════════
# 🔌 CLIENT API
# ═══════════════════════════════════════════════════════════

# 📡 Send request to daemon
# @usage: _yoga_client_send <module> <command> [args_json]
function _yoga_client_send {
    local module="$1"
    local command="$2"
    local args="${3:-{}}"
    local req_id="$(date +%s%N)"
    
    # 📤 Build request
    local request="${module}|${command}|${args}|${req_id}"
    
    # 📡 Send via socat
    local response
    if command -v socat &>/dev/null; then
        response=$(echo "$request" | socat - UNIX-CONNECT:"$YOGA_SOCKET" 2>/dev/null) || {
            yoga_fogo "🔌 Não foi possível conectar ao daemon!"
            return 1
        }
    else
        # Fallback usando nc se socat não estiver disponível
        response=$(echo "$request" | nc -U "$YOGA_SOCKET" -w "$TIMEOUT" 2>/dev/null) || {
            yoga_fogo "🔌 Não foi possível conectar ao daemon! (instale: socat ou nc)"
            return 1
        }
    fi
    
    # 📥 Parse response
    local parts=(${(s:|:)response})
    local status="${parts[1]:-ERROR}"
    local data="${parts[2]:-{}}"
    local resp_id="${parts[3]:-unknown}"
    
    # 🎯 Return data
    if [[ "$status" == "OK" ]]; then
        echo "$data"
        return 0
    else
        yoga_fogo "❌ Erro do daemon: $data"
        return 1
    fi
}

# ═══════════════════════════════════════════════════════════
# 🎯 HIGH-LEVEL API
# ═══════════════════════════════════════════════════════════

# 📊 State
function yoga_client_state_get {
    local key="$1"
    local scope="${2:-global}"
    local args=$(jq -n --arg key "$key" --arg scope "$scope" '{key: $key, scope: $scope}')
    _yoga_client_send "state" "get" "$args"
}

function yoga_client_state_set {
    local key="$1"
    local value="$2"
    local scope="${3:-global}"
    local args=$(jq -n --arg key "$key" --arg value "$value" --arg scope "$scope" '{key: $key, value: $value, scope: $scope}')
    _yoga_client_send "state" "set" "$args"
}

# 🌌 Workspace
function yoga_client_workspace_list {
    _yoga_client_send "workspace" "list" "{}"
}

function yoga_client_workspace_create {
    local name="$1"
    local path="$2"
    local args=$(jq -n --arg name "$name" --arg path "$path" '{name: $name, path: $path}')
    _yoga_client_send "workspace" "create" "$args"
}

function yoga_client_workspace_activate {
    local id="$1"
    local args=$(jq -n --arg id "$id" '{id: $id}')
    _yoga_client_send "workspace" "activate" "$args"
}

# 🎯 CC
function yoga_client_cc_data {
    _yoga_client_send "cc" "data" "{}"
}

# 🤖 AI
function yoga_client_ai_ask {
    local question="$1"
    local args=$(jq -n --arg q "$question" '{question: $q}')
    _yoga_client_send "ai" "ask" "$args"
}

# 📝 Log
function yoga_client_log_write {
    local level="$1"
    local module="$2"
    local message="$3"
    local args=$(jq -n --arg level "$level" --arg module "$module" --arg msg "$message" '{level: $level, module: $module, message: $msg}')
    _yoga_client_send "log" "write" "$args"
}

# 🔌 Plugin
function yoga_client_plugin_list {
    _yoga_client_send "plugin" "list" "{}"
}

# 👹 Daemon
function yoga_client_daemon_ping {
    _yoga_client_send "daemon" "ping" "{}"
}

function yoga_client_daemon_stop {
    _yoga_client_send "daemon" "stop" "{}"
}
