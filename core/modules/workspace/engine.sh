#!/usr/bin/env zsh
# 🌌 core/modules/workspace/engine.sh
# @name: workspace-engine
# @desc: Gerenciamento de Workspaces (reimplementação de ccp.zsh) 🌌
# @usage: source "${YOGA_HOME}/core/modules/workspace/engine.sh"
# @author: Yoga 3.0 Lôro Barizon Edition 🦜

emulate -L zsh
set -euo pipefail

# 📦 Source
source "${YOGA_HOME}/core/utils/ui.sh"
source "${YOGA_HOME}/core/state/api.sh"
source "${YOGA_HOME}/core/modules/workspace/tmux.sh"

# ═══════════════════════════════════════════════════════════
# 🌌 WORKSPACE API
# ═══════════════════════════════════════════════════════════

# 📋 Lista workspaces interativo (replica ccp.zsh)
function workspace_engine_list_interactive {
	local -a rows=()

	# Coleta sessões ativas
	local active_sessions=$(tmux list-sessions -F "#S" 2>/dev/null || true)

	# Monta lista de projetos em ~/code
	for proj in ~/code/*(/N); do
		local name=$(basename "$proj")
		local tname=$(echo "$name" | tr '.' '_')
		local status=""

		# Verifica se sessão está ativa
		if grep -q "^${tname}$" <<<"$active_sessions" 2>/dev/null; then
			status=" 🟢"
		fi

		rows+=("${name}${status}|${proj}")
	done

	# Fzf interface
	local out=$(printf '%s\n' "${rows[@]}" | fzf \
		--prompt="📂 Workspaces > " \
		--pointer="👉" \
		--header="Enter: Open/Switch | Ctrl-x: Kill | Ctrl-v: V-Split | Ctrl-h: H-Split | Ctrl-t: Tab" \
		--expect=ctrl-v,ctrl-h,ctrl-t,ctrl-x \
		--delimiter='\|' \
		--with-nth=1 \
		--preview='ls -la {2} 2>/dev/null | head -20')

	[[ -z "$out" ]] && return

	local key=$(head -1 <<<"$out")
	local selection=$(sed -n '2p' <<<"$out")
	[[ -z "$selection" ]] && return

	local dir="${selection#*|}"
	local name=$(basename "$dir" | tr '.' '_')

	# Processa ação
	case "$key" in
	ctrl-x)
		workspace_action_kill "$name"
		;;
	ctrl-v)
		workspace_action_split_v "$dir"
		;;
	ctrl-h)
		workspace_action_split_h "$dir"
		;;
	ctrl-t)
		workspace_action_new_window "$dir" "$name"
		;;
	*)
		workspace_action_switch "$name" "$dir"
		;;
	esac
}

# 🔄 Switch/Create workspace
function workspace_action_switch {
	local name="$1"
	local dir="$2"

	# Cria sessão se não existir
	if ! tmux has-session -t "$name" 2>/dev/null; then
		tmux new-session -ds "$name" -c "$dir"
		yoga_terra "🏗️ Workspace criado: $name"
	fi

	# Attach ou switch
	if [[ -n "${TMUX:-}" ]]; then
		tmux switch-client -t "$name"
	else
		tmux attach-session -t "$name"
	fi

	# Atualiza state
	yoga_workspace_activate "$name"
}

# 💀 Kill workspace
function workspace_action_kill {
	local name="$1"

	if tmux has-session -t "$name" 2>/dev/null; then
		tmux kill-session -t "$name"
		yoga_terra "💀 Workspace encerrado: $name"
	else
		yoga_sol "ℹ️ Workspace não estava ativo: $name"
	fi

	# Remove do state
	yoga_workspace_kill "$name" 2>/dev/null || true
}

# 📐 Split vertical
function workspace_action_split_v {
	local dir="$1"
	[[ -n "${TMUX:-}" ]] && tmux split-window -h -c "$dir"
}

# ➖ Split horizontal
function workspace_action_split_h {
	local dir="$1"
	[[ -n "${TMUX:-}" ]] && tmux split-window -v -c "$dir"
}

# 🆕 New window
function workspace_action_new_window {
	local dir="$1"
	local name="$2"
	[[ -n "${TMUX:-}" ]] && tmux new-window -c "$dir" -n "$name"
}
