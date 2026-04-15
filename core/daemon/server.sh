#!/usr/bin/env zsh
# 👹 core/daemon/server.sh
# @name: daemon-server
# @desc: Unix Socket Server for Yoga 3.0 Daemon 👹
# @usage: (internal, started by yoga-daemon)
# @author: Yoga 3.0 Lôro Barizon Edition 🦜

emulate -L zsh
set -euo pipefail

# 🏠 Paths
YOGA_SOCKET="${YOGA_HOME}/daemon.sock"
YOGA_PIDFILE="${YOGA_HOME}/daemon.pid"
YOGA_LOG="${YOGA_HOME}/logs/daemon.log"

# 📦 Source dependencies
source "${YOGA_HOME}/core/utils/ui.sh"
source "${YOGA_HOME}/core/state/api.sh"

# 🎯 Protocol constants
readonly PROTOCOL_VERSION="1.0"
[[ -z "${DELIMITER:-}" ]] && readonly DELIMITER=$'\x1E'

# ═══════════════════════════════════════════════════════════
# 🚀 SERVER CORE
# ═══════════════════════════════════════════════════════════

# 👹 Start daemon server
function yoga_daemon_server_start {
    # 🔍 Verifica se já está rodando
    if yoga_daemon_is_running; then
        yoga_sol "👹 Daemon já está rodando (PID: $(cat "$YOGA_PIDFILE"))"
        return 0
    fi
    
    # 🧹 Cleanup socket antigo
    [[ -S "$YOGA_SOCKET" ]] && rm -f "$YOGA_SOCKET"
    
    # 🚀 Inicia servidor em background
    (
        yoga_daemon_server_loop
    ) &
    
    local pid=$!
    echo $pid > "$YOGA_PIDFILE"
    
    # ⏳ Aguarda socket estar pronto
    local attempts=0
    while [[ ! -S "$YOGA_SOCKET" && $attempts -lt 10 ]]; do
        sleep 0.1
        ((attempts++))
    done
    
    if [[ -S "$YOGA_SOCKET" ]]; then
        yoga_terra "👹 Daemon iniciado! PID: $pid | Socket: $YOGA_SOCKET"
        return 0
    else
        yoga_fogo "👹 Falha ao iniciar daemon!"
        rm -f "$YOGA_PIDFILE"
        return 1
    fi
}

# 🛑 Stop daemon server
function yoga_daemon_server_stop {
    if ! yoga_daemon_is_running; then
        yoga_sol "👹 Daemon não está rodando"
        return 0
    fi
    
    local pid=$(cat "$YOGA_PIDFILE" 2>/dev/null || echo "")
    
    if [[ -n "$pid" ]]; then
        # 🛑 Sinal graceful
        kill "$pid" 2>/dev/null || true
        
        # ⏳ Aguarda finalização
        local attempts=0
        while kill -0 "$pid" 2>/dev/null && [[ $attempts -lt 20 ]]; do
            sleep 0.1
            ((attempts++))
        done
        
        # 💀 Kill forçado se necessário
        if kill -0 "$pid" 2>/dev/null; then
            kill -9 "$pid" 2>/dev/null || true
        fi
    fi
    
    # 🧹 Cleanup
    rm -f "$YOGA_SOCKET" "$YOGA_PIDFILE"
    yoga_terra "👹 Daemon parado"
}

# 🔍 Check if daemon is running
function yoga_daemon_is_running {
    [[ -f "$YOGA_PIDFILE" ]] || return 1
    local pid=$(cat "$YOGA_PIDFILE" 2>/dev/null || echo "")
    [[ -z "$pid" ]] && return 1
    kill -0 "$pid" 2>/dev/null && [[ -S "$YOGA_SOCKET" ]]
}

# ═══════════════════════════════════════════════════════════
# 🔄 SERVER LOOP
# ═══════════════════════════════════════════════════════════

function yoga_daemon_server_loop {
    # 📝 Log inicial
    echo "[$(date -Iseconds)] 👹 Daemon iniciado v${PROTOCOL_VERSION}" >> "$YOGA_LOG"
    
    # 🔄 Loop principal
    while true; do
        # 📡 Aceita conexões via socat
        # Formato: MODULO|COMANDO|ARGS_JSON|REQUEST_ID
        socat -u UNIX-LISTEN:"$YOGA_SOCKET",fork,reuseaddr,crlf STDOUT 2>/dev/null | \
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            _yoga_daemon_handle_request "$line"
        done
    done
}

# 🎯 Handle single request
function _yoga_daemon_handle_request {
    local request="$1"
    local timestamp=$(date -Iseconds)
    
    yoga_debug "👹 Request: $request"
    
    # 🔍 Parse request: MODULE|COMMAND|ARGS|REQ_ID
    local parts=(${(s:|:)request})
    local module="${parts[1]:-unknown}"
    local command="${parts[2]:-unknown}"
    local args="${parts[3]:-{}}"
    local req_id="${parts[4]:-$(date +%s%N)}"
    
    # 🎯 Route to module
    local response=""
    local status="OK"
    
    case "$module" in
        ping)
            response='{"pong":true}'
            ;;
        state)
            response=$(_yoga_daemon_handle_state "$command" "$args")
            ;;
        workspace)
            response=$(_yoga_daemon_handle_workspace "$command" "$args")
            ;;
        cc)
            response=$(_yoga_daemon_handle_cc "$command" "$args")
            ;;
        ai)
            response=$(_yoga_daemon_handle_ai "$command" "$args")
            ;;
        log)
            response=$(_yoga_daemon_handle_log "$command" "$args")
            ;;
        plugin)
            response=$(_yoga_daemon_handle_plugin "$command" "$args")
            ;;
        daemon)
            response=$(_yoga_daemon_handle_daemon "$command" "$args")
            ;;
        *)
            status="ERROR"
            response="{\"error\":\"Unknown module: $module\"}"
            ;;
    esac
    
    # 📤 Send response
    echo "${status}${DELIMITER}${response}${DELIMITER}${req_id}"
    
    # 📝 Log
    echo "[$timestamp] $module:$command | $status | $req_id" >> "$YOGA_LOG"
}

# ═══════════════════════════════════════════════════════════
# 🎯 MODULE HANDLERS
# ═══════════════════════════════════════════════════════════

function _yoga_daemon_handle_state {
    local cmd="$1"
    local args="$2"
    
    case "$cmd" in
        get)
            local key=$(echo "$args" | jq -r '.key // ""')
            local scope=$(echo "$args" | jq -r '.scope // "global"')
            local value=$(yoga_state_get "$key" "$scope")
            echo "{\"key\":\"$key\",\"value\":\"$value\",\"scope\":\"$scope\"}"
            ;;
        set)
            local key=$(echo "$args" | jq -r '.key // ""')
            local value=$(echo "$args" | jq -r '.value // ""')
            local scope=$(echo "$args" | jq -r '.scope // "global"')
            yoga_state_set "$key" "$value" "$scope"
            echo "{\"ok\":true,\"action\":\"set\"}"
            ;;
        del)
            local key=$(echo "$args" | jq -r '.key // ""')
            yoga_state_del "$key"
            echo "{\"ok\":true,\"action\":\"del\"}"
            ;;
        list)
            local scope=$(echo "$args" | jq -r '.scope // "global"')
            local keys=$(yoga_state_list "$scope" | jq -R -s -c 'split("\n") | map(select(length > 0))')
            echo "{\"keys\":$keys}"
            ;;
        *)
            echo "{\"error\":\"Unknown state command: $cmd\"}"
            ;;
    esac
}

function _yoga_daemon_handle_workspace {
    local cmd="$1"
    local args="$2"
    
    case "$cmd" in
        list)
            local workspaces=$(yoga_workspace_list | jq -R -s -c 'split("\n") | map(select(length > 0))')
            echo "{\"workspaces\":$workspaces}"
            ;;
        create)
            local name=$(echo "$args" | jq -r '.name // ""')
            local path=$(echo "$args" | jq -r '.path // ""')
            local id=$(yoga_workspace_create "$name" "$path")
            echo "{\"id\":\"$id\",\"name\":\"$name\"}"
            ;;
        activate)
            local id=$(echo "$args" | jq -r '.id // ""')
            yoga_workspace_activate "$id"
            echo "{\"ok\":true,\"activated\":\"$id\"}"
            ;;
        current)
            local current=$(yoga_workspace_current)
            echo "{\"current\":\"$current\"}"
            ;;
        kill)
            local id=$(echo "$args" | jq -r '.id // ""')
            yoga_workspace_kill "$id"
            echo "{\"ok\":true,\"killed\":\"$id\"}"
            ;;
        *)
            echo "{\"error\":\"Unknown workspace command: $cmd\"}"
            ;;
    esac
}

function _yoga_daemon_handle_cc {
    local cmd="$1"
    local args="$2"
    
    # CC é interativo, daemon apenas retorna dados
    case "$cmd" in
        data)
            # Retorna dados coletados para fzf no cliente
            source "${YOGA_HOME}/core/modules/cc/data.sh"
            local data=$(cc_data_collect | jq -R -s -c 'split("\n") | map(select(length > 0))')
            echo "{\"data\":$data}"
            ;;
        execute)
            local command=$(echo "$args" | jq -r '.command // ""')
            # Executa e retorna resultado
            local output
            output=$(eval "$command" 2>&1) && local status="success" || local status="error"
            echo "{\"status\":\"$status\",\"output\":\"$output\"}"
            ;;
        *)
            echo "{\"error\":\"Unknown cc command: $cmd\"}"
            ;;
    esac
}

function _yoga_daemon_handle_ai {
    local cmd="$1"
    local args="$2"
    
    case "$cmd" in
        ask)
            local question=$(echo "$args" | jq -r '.question // ""')
            source "${YOGA_HOME}/core/modules/ai/engine.sh"
            local response=$(ai_engine_ask "$question")
            echo "{\"question\":\"$question\",\"response\":\"$response\"}"
            ;;
        context_add)
            local content=$(echo "$args" | jq -r '.content // ""')
            yoga_ai_context_add "$content"
            echo "{\"ok\":true}"
            ;;
        context_search)
            local query=$(echo "$args" | jq -r '.query // ""')
            local results=$(yoga_ai_context_search "$query" | jq -R -s -c 'split("\n") | map(select(length > 0))')
            echo "{\"results\":$results}"
            ;;
        *)
            echo "{\"error\":\"Unknown ai command: $cmd\"}"
            ;;
    esac
}

function _yoga_daemon_handle_log {
    local cmd="$1"
    local args="$2"
    
    case "$cmd" in
        write)
            local level=$(echo "$args" | jq -r '.level // "INFO"')
            local module=$(echo "$args" | jq -r '.module // "unknown"')
            local message=$(echo "$args" | jq -r '.message // ""')
            yoga_log_db "$level" "$module" "$message"
            echo "{\"ok\":true}"
            ;;
        query)
            local limit=$(echo "$args" | jq -r '.limit // 50')
            local level=$(echo "$args" | jq -r '.level // ""')
            # Query SQLite logs
            local logs=$(sqlite3 "$YOGA_STATE_DB" "SELECT * FROM logs ORDER BY timestamp DESC LIMIT $limit" | \
                jq -R -s -c 'split("\n") | map(select(length > 0))')
            echo "{\"logs\":$logs}"
            ;;
        *)
            echo "{\"error\":\"Unknown log command: $cmd\"}"
            ;;
    esac
}

function _yoga_daemon_handle_plugin {
    local cmd="$1"
    local args="$2"
    
    case "$cmd" in
        list)
            local plugins=$(yoga_plugin_list | jq -R -s -c 'split("\n") | map(select(length > 0))')
            echo "{\"plugins\":$plugins}"
            ;;
        enable)
            local name=$(echo "$args" | jq -r '.name // ""')
            yoga_plugin_enable "$name"
            echo "{\"ok\":true,\"enabled\":\"$name\"}"
            ;;
        disable)
            local name=$(echo "$args" | jq -r '.name // ""')
            yoga_plugin_disable "$name"
            echo "{\"ok\":true,\"disabled\":\"$name\"}"
            ;;
        *)
            echo "{\"error\":\"Unknown plugin command: $cmd\"}"
            ;;
    esac
}

function _yoga_daemon_handle_daemon {
    local cmd="$1"
    local args="$2"
    
    case "$cmd" in
        ping)
            echo "{\"pong\":true,\"version\":\"$PROTOCOL_VERSION\",\"pid\":$$}"
            ;;
        stop)
            echo "{\"ok\":true,\"action\":\"stopping\"}"
            # Schedule shutdown
            (sleep 0.5 && yoga_daemon_server_stop) &
            ;;
        status)
            echo "{\"running\":true,\"pid\":$$,\"socket\":\"$YOGA_SOCKET\"}"
            ;;
        *)
            echo "{\"error\":\"Unknown daemon command: $cmd\"}"
            ;;
    esac
}
