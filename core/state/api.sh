#!/usr/bin/env zsh
# 🧠 core/state/api.sh
# @name: state-api
# @desc: SQLite State Manager API for Yoga 2.0 💾
# @usage: source "$YOGA_HOME/core/state/api.sh"
# @author: Yoga 2.0 Efigenia Edition 🧘‍♂️

emulate -L zsh
set -euo pipefail

# 🗄️ Configuração do banco
YOGA_STATE_DB="${YOGA_HOME}/state.db"
YOGA_STATE_SCHEMA="${YOGA_HOME}/core/state/schema.sql"

# 🎯 Inicialização
function _yoga_state_init {
	# Verifica se SQLite está instalado
	if ! command -v sqlite3 &>/dev/null; then
		yoga_fogo "💾 SQLite3 não encontrado! Instale com: apt install sqlite3"
		return 1
	fi

	# Cria banco se não existir
	if [[ ! -f "$YOGA_STATE_DB" ]]; then
		yoga_agua "💾 Criando banco de dados..."
		sqlite3 "$YOGA_STATE_DB" <"$YOGA_STATE_SCHEMA"
		yoga_terra "✅ Banco criado em $YOGA_STATE_DB"
	fi
}

# 📝 Helper: Escapa aspas simples
function _yoga_state_escape {
	local str="$1"
	echo "${str//\'/\'\'}"
}

# 📝 Helper: Executa query
function _yoga_state_query {
	local query="$1"
	sqlite3 "$YOGA_STATE_DB" "$query"
}

# ═══════════════════════════════════════════════════════════
# 🔑 KEY-VALUE STORE
# ═══════════════════════════════════════════════════════════

# 💾 Set value
# @usage: yoga_state_set <key> <value> [scope] [ttl_seconds]
function yoga_state_set {
	local key="$1"
	local value="$2"
	local scope="${3:-global}"
	local ttl="${4:-0}"

	[[ -z "$key" ]] && {
		yoga_fogo "🔑 Key é obrigatória!"
		return 1
	}

	local escaped_key=$(_yoga_state_escape "$key")
	local escaped_value=$(_yoga_state_escape "$value")
	local escaped_scope=$(_yoga_state_escape "$scope")

	local expires="NULL"
	[[ "$ttl" -gt 0 ]] && expires="datetime('now', '+$ttl seconds')"

	_yoga_state_query "
        INSERT INTO state (key, value, scope, expires_at, updated_at)
        VALUES ('$escaped_key', '$escaped_value', '$escaped_scope', $expires, datetime('now'))
        ON CONFLICT(key, scope) DO UPDATE SET
            value=excluded.value,
            updated_at=excluded.updated_at,
            expires_at=excluded.expires_at;
    "

	yoga_debug "💾 state_set: $key = $value (scope: $scope)"
	return 0
}

# 📖 Get value
# @usage: yoga_state_get <key> [scope] [default_value]
function yoga_state_get {
	local key="$1"
	local scope="${2:-global}"
	local default_value="${3:-}"

	[[ -z "$key" ]] && {
		echo "$default_value"
		return 0
	}

	local escaped_key=$(_yoga_state_escape "$key")
	local escaped_scope=$(_yoga_state_escape "$scope")

	local value
	value=$(_yoga_state_query "
        SELECT value FROM state 
        WHERE key='$escaped_key' 
        AND scope='$escaped_scope'
        AND (expires_at IS NULL OR expires_at > datetime('now'))
        LIMIT 1;
    " 2>/dev/null || true)

	[[ -n "$value" ]] && echo "$value" || echo "$default_value"
}

# 🗑️ Delete value
# @usage: yoga_state_del <key> [scope]
function yoga_state_del {
	local key="$1"
	local scope="${2:-global}"

	local escaped_key=$(_yoga_state_escape "$key")
	local escaped_scope=$(_yoga_state_escape "$scope")

	_yoga_state_query "
        DELETE FROM state 
        WHERE key='$escaped_key' 
        AND scope='$escaped_scope';
    "

	yoga_debug "🗑️ state_del: $key (scope: $scope)"
}

# 📋 List keys
# @usage: yoga_state_list [scope]
function yoga_state_list {
	local scope="${1:-global}"
	local escaped_scope=$(_yoga_state_escape "$scope")

	_yoga_state_query "
        SELECT key FROM state 
        WHERE scope='$escaped_scope'
        AND (expires_at IS NULL OR expires_at > datetime('now'))
        ORDER BY key;
    "
}

# 🧹 Clear all in scope
# @usage: yoga_state_clear [scope]
function yoga_state_clear {
	local scope="${1:-global}"
	local escaped_scope=$(_yoga_state_escape "$scope")

	_yoga_state_query "DELETE FROM state WHERE scope='$escaped_scope';"
	yoga_debug "🧹 state_clear: scope=$scope"
}

# ═══════════════════════════════════════════════════════════
# 🌌 WORKSPACES
# ═══════════════════════════════════════════════════════════

# 🏗️ Create workspace
# @usage: yoga_workspace_create <name> <path>
function yoga_workspace_create {
	local name="$1"
	local path="$2"

	[[ -z "$name" || -z "$path" ]] && {
		yoga_fogo "🏗️ Nome e path são obrigatórios!"
		return 1
	}

	local escaped_name=$(_yoga_state_escape "$name")
	local escaped_path=$(_yoga_state_escape "$path")
	local id=$(echo "$path" | sha256sum | cut -c1-16)

	_yoga_state_query "
        INSERT OR REPLACE INTO workspaces (id, name, path, created_at)
        VALUES ('$id', '$escaped_name', '$escaped_path', datetime('now'));
    "

	yoga_terra "🌌 Workspace criado: $name ($id)"
	echo "$id"
}

# 🔄 Activate workspace
# @usage: yoga_workspace_activate <id_or_path>
function yoga_workspace_activate {
	local identifier="$1"
	local escaped_id=$(_yoga_state_escape "$identifier")

	# Desativa todos primeiro
	_yoga_state_query "UPDATE workspaces SET is_active=0;"

	# Ativa o target (por id ou path)
	local id
	id=$(_yoga_state_query "
        SELECT id FROM workspaces 
        WHERE id='$escaped_id' OR path='$escaped_id'
        LIMIT 1;
    " || true)

	[[ -z "$id" ]] && {
		yoga_fogo "🌌 Workspace não encontrado: $identifier"
		return 1
	}

	_yoga_state_query "
        UPDATE workspaces 
        SET is_active=1, last_accessed=datetime('now')
        WHERE id='$id';
    "

	# Registra histórico
	_yoga_state_query "
        INSERT INTO workspace_history (workspace_id, event_type)
        VALUES ('$id', 'activated');
    "

	yoga_terra "🌌 Workspace ativado: $id"
}

# 📖 Get current workspace
# @usage: yoga_workspace_current
function yoga_workspace_current {
	_yoga_state_query "
        SELECT id, name, path FROM workspaces 
        WHERE is_active=1 
        LIMIT 1;
    " | while IFS='|' read -r id name path; do
		echo "id:$id|name:$name|path:$path"
	done
}

# 📋 List workspaces
# @usage: yoga_workspace_list
function yoga_workspace_list {
	_yoga_state_query "
        SELECT id, name, path, is_active, 
               COALESCE(tmux_session, '') as session,
               datetime(last_accessed, 'localtime') as accessed
        FROM workspaces 
        ORDER BY last_accessed DESC;
    " | while IFS='|' read -r id name path active session accessed; do
		local status="⚪"
		[[ "$active" == "1" ]] && status="🟢"
		[[ -n "$session" ]] && status="${status}📦"
		echo "${status}|${name}|${path}|${id}"
	done
}

# 💀 Kill workspace
# @usage: yoga_workspace_kill <id_or_name>
function yoga_workspace_kill {
	local identifier="$1"
	local escaped_id=$(_yoga_state_escape "$identifier")

	local id
	id=$(_yoga_state_query "
        SELECT id FROM workspaces 
        WHERE id='$escaped_id' OR name='$escaped_id'
        LIMIT 1;
    " || true)

	[[ -z "$id" ]] && {
		yoga_fogo "🌌 Workspace não encontrado"
		return 1
	}

	_yoga_state_query "
        INSERT INTO workspace_history (workspace_id, event_type)
        VALUES ('$id', 'killed');
    "

	_yoga_state_query "DELETE FROM workspaces WHERE id='$id';"
	yoga_terra "💀 Workspace removido: $identifier"
}

# ═══════════════════════════════════════════════════════════
# 🤖 AI CONTEXT
# ═══════════════════════════════════════════════════════════

# 📝 Add AI context
# @usage: yoga_ai_context_add <content> [source] [workspace_id]
function yoga_ai_context_add {
	local content="$1"
	local source="${2:-manual}"
	local workspace_id="${3:-}"

	local escaped_content=$(_yoga_state_escape "$content")
	local escaped_source=$(_yoga_state_escape "$source")
	local ws_clause=""
	[[ -n "$workspace_id" ]] && ws_clause=", workspace_id='$workspace_id'"

	_yoga_state_query "
        INSERT INTO ai_context (content, source $([[ -n "$ws_clause" ]] && echo ", workspace_id"))
        VALUES ('$escaped_content', '$escaped_source' $([[ -n "$workspace_id" ]] && echo ", '$workspace_id'"));
    "
}

# 🔍 Search AI context (RAG)
# @usage: yoga_ai_context_search <query> [limit]
function yoga_ai_context_search {
	local query="$1"
	local limit="${2:-5}"
	local escaped_query=$(_yoga_state_escape "$query")

	_yoga_state_query "
        SELECT content, rank FROM (
            SELECT content, rank 
            FROM logs_fts 
            WHERE logs_fts MATCH '$escaped_query'
            ORDER BY rank
            LIMIT $limit
        );
    " 2>/dev/null || true
}

# ═══════════════════════════════════════════════════════════
# 🔌 PLUGINS
# ═══════════════════════════════════════════════════════════

# 📦 Register plugin
# @usage: yoga_plugin_register <name> <version> <install_path>
function yoga_plugin_register {
	local name="$1"
	local version="$2"
	local install_path="$3"

	local escaped_name=$(_yoga_state_escape "$name")
	local escaped_path=$(_yoga_state_escape "$install_path")

	_yoga_state_query "
        INSERT OR REPLACE INTO plugins 
        (id, name, version, install_path, is_enabled, is_loaded)
        VALUES ('$escaped_name', '$escaped_name', '$version', '$escaped_path', 1, 0);
    "
}

# ✅ Enable/disable plugin
# @usage: yoga_plugin_enable <name> | yoga_plugin_disable <name>
function yoga_plugin_enable {
	local name="$1"
	_yoga_state_query "UPDATE plugins SET is_enabled=1 WHERE name='$name';"
}

function yoga_plugin_disable {
	local name="$1"
	_yoga_state_query "UPDATE plugins SET is_enabled=0, is_loaded=0 WHERE name='$name';"
}

# 📋 List plugins
# @usage: yoga_plugin_list
function yoga_plugin_list {
	_yoga_state_query "
        SELECT name, version, 
               CASE is_enabled WHEN 1 THEN '✅' ELSE '❌' END as enabled,
               CASE is_loaded WHEN 1 THEN '🟢' ELSE '⚪' END as loaded
        FROM plugins 
        ORDER BY name;
    "
}

# ═══════════════════════════════════════════════════════════
# 📝 LOGS
# ═══════════════════════════════════════════════════════════

# 📝 Log entry
# @usage: yoga_log_db <level> <module> <command> [input] [output] [status] [duration]
function yoga_log_db {
	local level="$1"
	local module="$2"
	local command="$3"
	local input="${4:-}"
	local output="${5:-}"
	local status="${6:-success}"
	local duration="${7:-0}"

	local escaped_input=$(_yoga_state_escape "$input")
	local escaped_output=$(_yoga_state_escape "$output")

	_yoga_state_query "
        INSERT INTO logs (level, module, command, input, output, status, duration_ms)
        VALUES ('$level', '$module', '$command', '$escaped_input', '$escaped_output', '$status', $duration);
    "
}

# 🧹 Cleanup old logs
# @usage: yoga_log_cleanup
function yoga_log_cleanup {
	_yoga_state_query "
        DELETE FROM logs 
        WHERE timestamp < datetime('now', '-30 days');
    "
	yoga_debug "🧹 Logs antigos removidos"
}

# ═══════════════════════════════════════════════════════════
# 🚀 INITIALIZATION
# ═══════════════════════════════════════════════════════════

# Inicializa automaticamente
_yoga_state_init
