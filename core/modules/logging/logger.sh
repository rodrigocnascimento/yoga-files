#!/usr/bin/env zsh
# 📝 core/modules/logging/logger.sh
# @name: logging-engine
# @desc: Structured JSONL Logging for Yoga 3.0 📝
# @usage: source "$YOGA_HOME/core/modules/logging/logger.sh"
# @author: Yoga 3.0 Lôro Barizon Edition 🦜

emulate -L zsh
set -euo pipefail

# 📦 Source
source "${YOGA_HOME}/core/utils/ui.sh"
source "${YOGA_HOME}/core/state/api.sh"

# 🏠 Config
YOGA_LOG_FILE="${YOGA_HOME}/logs/yoga.jsonl"
YOGA_LOG_LEVEL="${YOGA_LOG_LEVEL:-INFO}" # DEBUG < INFO < WARN < ERROR

# 🎯 Log levels numeric values
readonly LOG_LEVEL_DEBUG=0
readonly LOG_LEVEL_INFO=1
readonly LOG_LEVEL_WARN=2
readonly LOG_LEVEL_ERROR=3

# ═══════════════════════════════════════════════════════════
# 📝 CORE LOGGING
# ═══════════════════════════════════════════════════════════

# 🎯 Get numeric level
function _yoga_log_level_value {
	case "${1^^}" in
	DEBUG) echo 0 ;;
	INFO) echo 1 ;;
	WARN) echo 2 ;;
	ERROR) echo 3 ;;
	*) echo 1 ;; # Default INFO
	esac
}

# 📝 Write log entry
function yoga_log {
	local level="${1:-INFO}"
	local module="${2:-unknown}"
	local message="${3:-}"
	local payload="${4:-{}}"

	# 🔍 Check level
	local level_val=$(_yoga_log_level_value "$level")
	local config_val=$(_yoga_log_level_value "$YOGA_LOG_LEVEL")

	[[ $level_val -lt $config_val ]] && return 0

	# 📝 Build JSON entry
	local entry
	entry=$(jq -n \
		--arg ts "$(date -Iseconds)" \
		--arg lvl "$level" \
		--arg mod "$module" \
		--arg msg "$message" \
		--argjson pld "$payload" \
		'{
            timestamp: $ts,
            level: $lvl,
            module: $mod,
            message: $msg,
            payload: $pld,
            pid: $$,
            hostname: env.HOSTNAME
        }' 2>/dev/null || echo "{\"error\":\"json encoding failed\"}")

	# 💾 Write to file
	echo "$entry" >>"$YOGA_LOG_FILE"

	# 💾 Also write to SQLite for RAG
	yoga_log_db "$level" "$module" "" "" "$message" "success" 0 2>/dev/null || true

	# 📺 Console output for DEBUG
	[[ "$level" == "DEBUG" && "${YOGA_DEBUG:-0}" == "1" ]] &&
		yoga_debug "🐛 [$module] $message"
}

# ═══════════════════════════════════════════════════════════
# 🎯 CONVENIENCE FUNCTIONS
# ═══════════════════════════════════════════════════════════

function yoga_log_debug {
	yoga_log "DEBUG" "$1" "$2" "${3:-{}}"
}

function yoga_log_info {
	yoga_log "INFO" "$1" "$2" "${3:-{}}"
}

function yoga_log_warn {
	yoga_log "WARN" "$1" "$2" "${3:-{}}"
}

function yoga_log_error {
	yoga_log "ERROR" "$1" "$2" "${3:-{}}"
}

# ═══════════════════════════════════════════════════════════
# 🔍 LOG QUERY
# ═══════════════════════════════════════════════════════════

# 📋 Query logs
function yoga_log_query {
	local filter="${1:-}"
	local limit="${2:-50}"
	local level="${3:-}"
	local module="${4:-}"

	[[ ! -f "$YOGA_LOG_FILE" ]] && {
		yoga_error "❌ Arquivo de log não encontrado"
		return 1
	}

	local query='. as $line | select($line | type == "object")'

	# 🔍 Add filters
	[[ -n "$level" ]] && query="$query | select(.level == \"$level\")"
	[[ -n "$module" ]] && query="$query | select(.module == \"$module\")"
	[[ -n "$filter" ]] && query="$query | select(.message | contains(\"$filter\"))"

	# 📊 Execute query
	jq -s "[$query] | sort_by(.timestamp) | reverse | .[0:$limit]" "$YOGA_LOG_FILE" 2>/dev/null ||
		yoga_error "❌ Falha ao consultar logs"
}

# 📜 Tail logs (follow)
function yoga_log_tail {
	local lines="${1:-50}"
	[[ ! -f "$YOGA_LOG_FILE" ]] && {
		yoga_error "❌ Arquivo de log não encontrado"
		return 1
	}
	tail -n "$lines" -f "$YOGA_LOG_FILE"
}

# 🧹 Log rotation
function yoga_log_rotate {
	local max_size="${1:-10485760}" # 10MB default
	local max_files="${2:-5}"

	if [[ -f "$YOGA_LOG_FILE" ]]; then
		local size=$(stat -f%z "$YOGA_LOG_FILE" 2>/dev/null || stat -c%s "$YOGA_LOG_FILE" 2>/dev/null || echo 0)

		if [[ $size -gt $max_size ]]; then
			yoga_agua "🗜️ Rotacionando logs..."

			# 🔄 Rotate files
			for i in $(seq $((max_files - 1)) -1 1); do
				[[ -f "${YOGA_LOG_FILE}.$i" ]] && mv "${YOGA_LOG_FILE}.$i" "${YOGA_LOG_FILE}.$((i + 1))"
			done

			mv "$YOGA_LOG_FILE" "${YOGA_LOG_FILE}.1"
			touch "$YOGA_LOG_FILE"

			yoga_terra "✅ Logs rotacionados"
		fi
	fi
}

# 🧹 Cleanup old logs
function yoga_log_cleanup {
	local days="${1:-30}"

	yoga_agua "🧹 Limpando logs mais antigos que $days dias..."

	# Remove arquivos antigos
	find "${YOGA_HOME}/logs" -name "yoga.jsonl.*" -mtime +$days -delete 2>/dev/null || true

	# Limpa SQLite
	yoga_log_cleanup_db

	yoga_terra "✅ Cleanup concluído!"
}

# ═══════════════════════════════════════════════════════════
# 🚀 INITIALIZATION
# ═══════════════════════════════════════════════════════════

# 🏗️ Ensure log directory
mkdir -p "${YOGA_HOME}/logs"

# 🗜️ Rotate if needed
yoga_log_rotate
