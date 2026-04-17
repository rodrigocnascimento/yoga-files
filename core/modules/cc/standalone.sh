#!/usr/bin/env zsh
# 🦜 core/modules/cc/standalone.sh
# @name: cc-standalone
# @desc: Command Center - Reimplementação NATIVA (não usa ~/.zsh/)
# @version: 3.0.0
# @usage: yoga cc
# @author: Yoga Lôro Barizon Edition
# @requires: fzf, jq, sqlite3
#
# @workflow:
#   1. Coleta aliases, funções SHELL, git, docker, histórico
#   2. Exibe interface fzf com preview
#   3. Executa comando selecionado
#   4. Loga em SQLite silenciosamente
#
# @keybindings:
#   Enter: Executa comando
#   Ctrl-Y: Copia para clipboard
#   Ctrl-E: Abre no nvim
#   Ctrl-X: Ação contextual
#
# @examples:
#   yoga cc                    # Abre interface completa
#   yoga cc --query="git"      # Busca pré-filtrada
#   yoga cc --type=function    # Só mostra funções
#
# @state:
#   Salva: last_cc_command, cc_usage_count, cc_favorites
#   Tabela: commands (SQLite)
#
# @logs:
#   ~/.yoga/logs/yoga.jsonl
#   ~/.yoga/state.db (tabela commands)

# Required: uses zsh-specific features (functions builtin, local -a)
emulate -L zsh
set -euo pipefail

YOGA_HOME="${YOGA_HOME:-$HOME/.yoga}"
source "$YOGA_HOME/core/utils/ui.sh"
source "$YOGA_HOME/core/state/api.sh"

# ═══════════════════════════════════════════════════════════════
# FUNÇÕES PÚBLICAS
# ═══════════════════════════════════════════════════════════════

# 🎯 Inicia Command Center
# @usage: cc_standalone_run [options]
# @param: --query=<str> - Busca pré-filtrada
# @param: --type=<type> - Tipo: alias, function, git, docker, history
# @return: Executa comando selecionado
# @side-effects: Log no SQLite, atualiza state
function cc_standalone_run {
	local query="${1:-}"
	local filter_type="${2:-}"

	yoga_debug "🎯 cc_standalone_run iniciando..."

	# Coleta dados
	local data=$(cc_standalone_collect "$filter_type")

	# Aplica query pré-filtrada se fornecida
	if [[ -n "$query" ]]; then
		data=$(echo "$data" | grep -i "$query" || true)
	fi

	# Interface fzf
	local selected=$(echo "$data" | fzf \
		--prompt="🚀 Command Center > " \
		--height=90% \
		--layout=reverse \
		--border \
		--delimiter='\|' \
		--with-nth=2 \
		--preview 'cc_standalone_preview {}' \
		--preview-window=down:3:wrap \
		--expect=enter,ctrl-y,ctrl-e,ctrl-x)

	[[ -z "$selected" ]] && return

	# Parse seleção
	local key=$(head -1 <<<"$selected")
	local line=$(sed -n '2p' <<<"$selected")
	[[ -z "$line" ]] && return

	# Processa ação
	cc_standalone_action "$key" "$line"
}

# 📊 Coleta dados do ambiente
# @usage: cc_standalone_collect [filter_type]
# @param: filter_type - Tipo para filtrar (opcional)
# @return: Lista formatada: "type|label|command"
# @side-effects: Nenhum (apenas coleta)
function cc_standalone_collect {
	local filter_type="${1:-}"
	local -a items=()

	# 1. Aliases do shell
	if [[ -z "$filter_type" || "$filter_type" == "alias" ]]; then
		while IFS='=' read -r name value; do
			[[ -n "$name" ]] && items+=("alias|${name}|${value}")
		done < <(alias 2>/dev/null | sed "s/=/'/; s/'//")
	fi

	# 2. Funções do shell (apenas as definidas pelo usuário)
	if [[ -z "$filter_type" || "$filter_type" == "function" ]]; then
		for func in $(functions 2>/dev/null | grep -v '^_' | head -50); do
			[[ -n "$func" ]] && items+=("function|${func}|${func}")
		done
	fi

	# 3. Git branches (se em repo git)
	if [[ -z "$filter_type" || "$filter_type" == "git" ]]; then
		if git rev-parse --git-dir &>/dev/null; then
			while read -r branch; do
				[[ -n "$branch" ]] && items+=("git|${branch}|git checkout ${branch}")
			done < <(git branch -a 2>/dev/null | sed 's/^[* ]*//' | head -20)
		fi
	fi

	# 4. Docker containers
	if [[ -z "$filter_type" || "$filter_type" == "docker" ]]; then
		if command -v docker &>/dev/null; then
			while IFS= read -r container; do
				[[ -n "$container" ]] && items+=("docker|${container}|docker exec -it ${container} bash")
			done < <(docker ps --format "{{.Names}}" 2>/dev/null | head -10)
		fi
	fi

	# 5. Histórico de comandos
	if [[ -z "$filter_type" || "$filter_type" == "history" ]]; then
		while read -r cmd; do
			[[ -n "$cmd" && ${#cmd} -gt 3 ]] && items+=("history|${cmd:0:50}|${cmd}")
		done < <(history 2>/dev/null | tail -50 | sed 's/^ *[0-9]* *//' | sort -u | head -30)
	fi

	# 6. Comandos favoritos do usuário (do SQLite)
	if [[ -f "$YOGA_STATE_DB" ]]; then
		while IFS='|' read -r cmd desc; do
			[[ -n "$cmd" ]] && items+=("favorite|⭐ ${desc}|${cmd}")
		done < <(sqlite3 "$YOGA_STATE_DB" "SELECT command, description FROM commands WHERE is_favorite=1 ORDER BY usage_count DESC LIMIT 10" 2>/dev/null || true)
	fi

	# Output
	printf '%s\n' "${items[@]}"
}

# 👁️ Gera preview para fzf
# @usage: cc_standalone_preview <line>
# @param: line - Linha no formato "type|label|command"
# @return: Texto formatado para preview
function cc_standalone_preview {
	local line="$1"
	local type="${line%%|*}"
	local rest="${line#*|}"
	local label="${rest%%|*}"
	local cmd="${rest#*|}"

	case "$type" in
	alias)
		echo "📦 Alias: ${label}"
		echo "🔧 Executa: ${cmd}"
		;;
	function)
		echo "⚙️  Função: ${label}"
		type "$label" 2>/dev/null | head -10 || echo "   (definida no shell)"
		;;
	git)
		echo "🌿 Branch: ${label}"
		echo "📋 Log recente:"
		git log --oneline -3 "${label}" 2>/dev/null || echo "   (sem histórico)"
		;;
	docker)
		echo "🐳 Container: ${label}"
		docker ps --filter "name=${label}" --format "Status: {{.Status}}" 2>/dev/null || echo "   (status indisponível)"
		;;
	history)
		echo "📜 Histórico: ${label}"
		;;
	favorite)
		echo "⭐ Favorito: ${label}"
		;;
	*)
		echo "❓ Tipo: ${type}"
		echo "📋 Comando: ${cmd}"
		;;
	esac
}

# 🎬 Processa ação selecionada
# @usage: cc_standalone_action <key> <line>
# @param: key - Tecla pressionada (enter, ctrl-y, ctrl-e, ctrl-x)
# @param: line - Linha selecionada
# @return: Executa ação
# @side-effects: Log no SQLite, clipboard, nvim, etc.
function cc_standalone_action {
	local key="$1"
	local line="$2"

	# Parse
	local type="${line%%|*}"
	local rest="${line#*|}"
	local label="${rest%%|*}"
	local cmd="${rest#*|}"

	# Log inicial
	local start_time=$(date +%s%3N)

	case "$key" in
	ctrl-y)
		# 📋 Copia para clipboard
		echo -n "$cmd" | xclip -selection clipboard 2>/dev/null || echo -n "$cmd" | pbcopy 2>/dev/null || echo -n "$cmd" | wl-copy 2>/dev/null
		yoga_terra "📋 Copiado: ${cmd:0:50}"
		cc_standalone_log "$cmd" "$type" "copied" 0
		;;
	ctrl-e)
		# 📝 Abre no nvim
		if [[ -f "$cmd" ]]; then
			nvim "$cmd"
		else
			# Cria buffer temporário
			local tmpfile=$(mktemp /tmp/yoga-cc-XXXXXX.sh)
			echo "#!/bin/zsh" >"$tmpfile"
			echo "# Comando: $cmd" >>"$tmpfile"
			echo "" >>"$tmpfile"
			echo "$cmd" >>"$tmpfile"
			nvim "$tmpfile"
			rm -f "$tmpfile" 2>/dev/null || true
		fi
		cc_standalone_log "$cmd" "$type" "edited" 0
		;;
	ctrl-x)
		# ⚡ Ação contextual
		cc_standalone_contextual "$type" "$cmd" "$label"
		;;
	*)
		# 🚀 Executa diretamente (Enter ou vazio)
		yoga_terra "🚀 Executando: ${cmd:0:50}"
		local exec_start=$(date +%s%3N)

		# Executa
		eval "$cmd"
		local exit_code=$?

		# Calcula duração
		local end_time=$(date +%s%3N)
		local duration=$((end_time - exec_start))

		if [[ $exit_code -eq 0 ]]; then
			yoga_terra "✅ Concluído em ${duration}ms"
			cc_standalone_log "$cmd" "$type" "success" "$duration"
			cc_standalone_update_favorite "$cmd" "$label"
		else
			yoga_fogo "❌ Erro (código: $exit_code)"
			cc_standalone_log "$cmd" "$type" "error" "$duration"
		fi
		;;
	esac
}

# 🎭 Ação contextual especial
# @usage: cc_standalone_contextual <type> <cmd> <label>
function cc_standalone_contextual {
	local type="$1"
	local cmd="$2"
	local label="$3"

	case "$type" in
	git)
		eval "$cmd"
		yoga_terra "🌿 Branch trocado para: $label"
		;;
	docker)
		eval "$cmd"
		;;
	*)
		yoga_agua "💫 Ação contextual não implementada para: $type"
		;;
	esac

	cc_standalone_log "$cmd" "$type" "contextual" 0
}

# 📝 Log no SQLite
# @usage: cc_standalone_log <command> <type> <status> <duration>
function cc_standalone_log {
	local cmd="$1"
	local type="$2"
	local cc_status="$3"
	local duration="$4"

	# Log para SQLite (silencioso)
	if [[ -f "$YOGA_STATE_DB" ]]; then
		local escaped_cmd=$(echo "$cmd" | sed "s/'/''/g")
		sqlite3 "$YOGA_STATE_DB" "
            INSERT INTO commands (type, command, description, status, last_used)
            VALUES ('$type', '$escaped_cmd', '${escaped_cmd:0:100}', '$cc_status', datetime('now'))
            ON CONFLICT(command) DO UPDATE SET
                usage_count = usage_count + 1,
                status = '$cc_status',
                last_used = datetime('now');
        " 2>/dev/null || true
	fi

	# Log JSONL
	local log_entry=$(jq -n \
		--arg ts "$(date -Iseconds)" \
		--arg module "cc" \
		--arg cmd "$cmd" \
		--arg type "$type" \
		--arg status "$cc_status" \
		--argjson dur "$duration" \
		'{timestamp: $ts, level: "INFO", module: $module, command: $cmd, type: $type, status: $status, duration_ms: $dur}')

	echo "$log_entry" >>"${YOGA_HOME}/logs/yoga.jsonl" 2>/dev/null || true
}

# ⭐ Atualiza favoritos
# @usage: cc_standalone_update_favorite <command> <description>
function cc_standalone_update_favorite {
	local cmd="$1"
	local desc="$2"

	# Se usou 5+ vezes, vira favorito automaticamente
	if [[ -f "$YOGA_STATE_DB" ]]; then
		local count=$(sqlite3 "$YOGA_STATE_DB" "SELECT usage_count FROM commands WHERE command='$cmd';" 2>/dev/null || echo "0")
		if [[ "$count" -gt 5 ]]; then
			sqlite3 "$YOGA_STATE_DB" "UPDATE commands SET is_favorite=1 WHERE command='$cmd';" 2>/dev/null || true
		fi
	fi
}
