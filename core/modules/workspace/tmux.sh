#!/usr/bin/env zsh
# 🌌 core/modules/workspace/tmux.sh
# @name: workspace-tmux
# @desc: Tmux integration for Workspaces 🌌
# @usage: source "${YOGA_HOME}/core/modules/workspace/tmux.sh"
# @author: Yoga 3.0 Lôro Barizon Edition 🦜

emulate -L zsh
set -euo pipefail

# 📦 Source
source "${YOGA_HOME}/core/utils/ui.sh"

# ═══════════════════════════════════════════════════════════
# 🖥️ TMUX UTILITIES
# ═══════════════════════════════════════════════════════════

function _tmux_check {
	if ! command -v tmux &>/dev/null; then
		yoga_fogo "🖥️ Tmux não está instalado!"
		return 1
	fi
	return 0
}

function tmux_session_exists {
	local name="$1"
	_tmux_check || return 1
	tmux has-session -t "$name" 2>/dev/null
}

function tmux_session_create {
	local name="$1"
	local dir="$2"
	local layout="${3:-default}"

	_tmux_check || return 1

	if ! tmux_session_exists "$name"; then
		tmux new-session -ds "$name" -c "$dir"
		yoga_terra "🖥️ Sessão tmux criada: $name"
		return 0
	fi

	return 1 # Já existe
}

function tmux_session_attach {
	local name="$1"

	_tmux_check || return 1

	if [[ -n "${TMUX:-}" ]]; then
		# Já estamos em tmux, faz switch
		tmux switch-client -t "$name"
	else
		# Attach normal
		tmux attach-session -t "$name"
	fi
}

function tmux_session_kill {
	local name="$1"

	_tmux_check || return 1

	if tmux_session_exists "$name"; then
		tmux kill-session -t "$name"
		yoga_terra "🖥️ Sessão encerrada: $name"
		return 0
	fi

	return 1 # Não existe
}

function tmux_session_list {
	_tmux_check || return 1
	tmux list-sessions -F "#S" 2>/dev/null || true
}
