#!/usr/bin/env zsh
# 🦜 core/modules/workspace/standalone.sh
# @name: workspace-standalone
# @desc: Workspace Manager - Reimplementação NATIVA de ccp
# @version: 3.0.0
# @usage: yoga workspace [list|switch|create|kill]
# @author: Yoga Lôro Barizon Edition
# @requires: tmux, fzf
#
# @workflow:
#   1. Lista projetos em ~/code/*
#   2. Mostra status 🟢 para sessões ativas
#   3. Interface fzf com preview
#   4. Cria/anexa sessão tmux
#   5. Atualiza state SQLite
#
# @keybindings:
#   Enter: Switch/Create sessão
#   Ctrl-X: Kill sessão
#   Ctrl-V: Split vertical
#   Ctrl-H: Split horizontal
#   Ctrl-T: New window
#
# @examples:
#   yoga workspace              # Lista interativa
#   yoga workspace list         # Lista simples
#   yoga workspace switch foo   # Troca para projeto foo
#   yoga workspace create bar   # Cria projeto bar
#
# @state:
#   Tabela: workspaces (SQLite)
#   Campos: id, name, path, tmux_session, is_active, last_accessed

emulate -L zsh
set -euo pipefail

YOGA_HOME="${YOGA_HOME:-$HOME/.yoga}"
CODE_DIR="${YOGA_CODE_DIR:-$HOME/code}"
source "$YOGA_HOME/core/utils/ui.sh"
source "$YOGA_HOME/core/state/api.sh"

# ═══════════════════════════════════════════════════════════════
# FUNÇÕES PÚBLICAS
# ═══════════════════════════════════════════════════════════════

# 🌌 Lista workspaces interativo (principal)
# @usage: workspace_standalone_list_interactive
# @return: Navega para workspace selecionado
function workspace_standalone_list_interactive {
	local -a rows=()

	# Coleta sessões ativas uma única vez
	local active_sessions=$(tmux list-sessions -F "#S" 2>/dev/null || true)

	# Monta lista de projetos em ~/code
	for proj in "$CODE_DIR"/*(/N); do
		[[ -d "$proj" ]] || continue

		local name=$(basename "$proj")
		local tname=$(echo "$name" | tr '.' '_')
		local ws_status=""

		# Verifica se sessão está ativa
		if grep -q "^${tname}$" <<<"$active_sessions" 2>/dev/null; then
			ws_status=" 🟢"
		fi

		rows+=("${name}${ws_status}|${proj}")
	done

	# Se não encontrou projetos
	if [[ ${#rows[@]} -eq 0 ]]; then
		yoga_fogo "❌ Nenhum projeto encontrado em $CODE_DIR"
		yoga_agua "💡 Crie projetos em $CODE_DIR ou defina YOGA_CODE_DIR"
		return 1
	fi

	# Fzf interface
	local out=$(printf '%s\n' "${rows[@]}" | fzf \
		--prompt="📂 Workspaces > " \
		--pointer="👉" \
		--header="Enter: Open/Switch | Ctrl-x: Kill | Ctrl-v: V-Split | Ctrl-h: H-Split | Ctrl-t: Tab" \
		--expect=ctrl-v,ctrl-h,ctrl-t,ctrl-x \
		--delimiter='\|' \
		--with-nth=1 \
		--preview='ls -la {2} 2>/dev/null | head -20' \
		--preview-window=right:50%)

	[[ -z "$out" ]] && return

	local key=$(head -1 <<<"$out")
	local selection=$(sed -n '2p' <<<"$out")
	[[ -z "$selection" ]] && return

	local dir="${selection#*|}"
	local name=$(basename "$dir" | tr '.' '_')

	# Processa ação
	case "$key" in
	ctrl-x)
		workspace_standalone_action_kill "$name"
		;;
	ctrl-v)
		workspace_standalone_action_split_v "$dir"
		;;
	ctrl-h)
		workspace_standalone_action_split_h "$dir"
		;;
	ctrl-t)
		workspace_standalone_action_new_window "$dir" "$name"
		;;
	*)
		workspace_standalone_action_switch "$name" "$dir"
		;;
	esac
}

# 🔄 Switch/Create workspace
# @usage: workspace_standalone_action_switch <name> <dir>
function workspace_standalone_action_switch {
	local name="$1"
	local dir="$2"

	# Valida diretório
	if [[ ! -d "$dir" ]]; then
		yoga_fogo "❌ Diretório não existe: $dir"
		return 1
	fi

	# Cria sessão se não existir
	if ! tmux has-session -t "$name" 2>/dev/null; then
		tmux new-session -ds "$name" -c "$dir"
		yoga_terra "🏗️ Workspace criado: $name"

		# Cria janelas padrão
		tmux new-window -t "$name:1" -n "editor" -c "$dir" 2>/dev/null || true
		tmux new-window -t "$name:2" -n "terminal" -c "$dir" 2>/dev/null || true
	fi

	# Switch ou attach
	if [[ -n "${TMUX:-}" ]]; then
		# Já estamos em tmux
		tmux switch-client -t "$name"
	else
		# Attach normal
		tmux attach-session -t "$name"
	fi

	# Atualiza state
	workspace_standalone_update_state "$name" "$dir"
	yoga_terra "🌌 Workspace ativado: $name"
}

# 💀 Kill workspace
# @usage: workspace_standalone_action_kill <name>
function workspace_standalone_action_kill {
	local name="$1"

	# Confirma
	yoga_prompt "💀 Matar sessão '$name'? [y/N] "
	read -r confirm
	[[ "$confirm" != "y" && "$confirm" != "Y" ]] && return

	if tmux has-session -t "$name" 2>/dev/null; then
		tmux kill-session -t "$name"
		yoga_terra "💀 Workspace encerrado: $name"
	else
		yoga_sol "ℹ️ Workspace não estava ativo: $name"
	fi

	# Remove do state
	local escaped_name=$(echo "$name" | sed "s/'/''/g")
	sqlite3 "$YOGA_STATE_DB" "DELETE FROM workspaces WHERE name='$escaped_name';" 2>/dev/null || true
}

# 📐 Split vertical
function workspace_standalone_action_split_v {
	local dir="$1"
	[[ -n "${TMUX:-}" ]] && tmux split-window -h -c "$dir"
}

# ➖ Split horizontal
function workspace_standalone_action_split_h {
	local dir="$1"
	[[ -n "${TMUX:-}" ]] && tmux split-window -v -c "$dir"
}

# 🆕 New window
function workspace_standalone_action_new_window {
	local dir="$1"
	local name="$2"
	[[ -n "${TMUX:-}" ]] && tmux new-window -c "$dir" -n "$name"
}

# 💾 Atualiza state no SQLite
function workspace_standalone_update_state {
	local name="$1"
	local dir="$2"
	local id=$(echo "$dir" | sha256sum | cut -c1-16)

	# Desativa todos primeiro
	sqlite3 "$YOGA_STATE_DB" "UPDATE workspaces SET is_active=0;" 2>/dev/null || true

	# Ativa/atualiza este
	local escaped_name=$(echo "$name" | sed "s/'/''/g")
	local escaped_dir=$(echo "$dir" | sed "s/'/''/g")

	sqlite3 "$YOGA_STATE_DB" "
        INSERT INTO workspaces (id, name, path, tmux_session, is_active, last_accessed)
        VALUES ('$id', '$escaped_name', '$escaped_dir', '$escaped_name', 1, datetime('now'))
        ON CONFLICT(id) DO UPDATE SET
            is_active=1,
            last_accessed=datetime('now');
    " 2>/dev/null || true

	# Log
	workspace_standalone_log "switch" "$name" "$dir"
}

# 📝 Log
function workspace_standalone_log {
	local action="$1"
	local name="$2"
	local dir="$3"

	local log_entry=$(jq -n \
		--arg ts "$(date -Iseconds)" \
		--arg module "workspace" \
		--arg act "$action" \
		--arg name "$name" \
		--arg dir "$dir" \
		'{timestamp: $ts, level: "INFO", module: $module, action: $act, workspace: $name, path: $dir}')

	echo "$log_entry" >>"${YOGA_HOME}/logs/yoga.jsonl" 2>/dev/null || true
}

# 📋 Lista simples (não interativo)
function workspace_standalone_list_simple {
	echo "🌌 Workspaces em $CODE_DIR:"
	echo ""

	local active_sessions=$(tmux list-sessions -F "#S" 2>/dev/null || true)

	for proj in "$CODE_DIR"/*(/N); do
		[[ -d "$proj" ]] || continue

		local name=$(basename "$proj")
		local tname=$(echo "$name" | tr '.' '_')
		local ws_status="⚪"

		if grep -q "^${tname}$" <<<"$active_sessions" 2>/dev/null; then
			ws_status="🟢"
		fi

		printf "  %s %s\n" "$ws_status" "$name"
	done
}
