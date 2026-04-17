#!/usr/bin/env zsh
# 🎯 core/modules/cc/action.sh
# @name: cc-action
# @desc: Ações contextuais para Command Center 🎯
# @usage: source "${YOGA_HOME}/core/modules/cc/action.sh"
# @author: Yoga 3.0 Lôro Barizon Edition 🦜

set -euo pipefail

# 📦 Source
source "${YOGA_HOME}/core/utils/ui.sh"

# ═══════════════════════════════════════════════════════════
# 🎯 ACTION PROCESSING
# ═══════════════════════════════════════════════════════════

function cc_action_process {
	local key="$1"
	local line="$2"

	# Parse line: TYPE|LABEL|COMMAND
	local type="${line%%|*}"
	local rest="${line#*|}"
	local label="${rest%%|*}"
	local cmd="${rest#*|}"

	case "$key" in
	ctrl-y)
		# 📋 Copia para clipboard
		cc_action_copy "$cmd"
		;;
	ctrl-e)
		# 📝 Abre no nvim
		cc_action_edit "$cmd"
		;;
	ctrl-x)
		# ⚡ Ação contextual especial
		cc_action_contextual "$type" "$cmd"
		;;
	*)
		# 🚀 Executa diretamente
		cc_action_execute "$cmd"
		;;
	esac
}

function cc_action_copy {
	local cmd="$1"

	if command -v xclip &>/dev/null; then
		echo -n "$cmd" | xclip -selection clipboard
	elif command -v wl-copy &>/dev/null; then
		echo -n "$cmd" | wl-copy
	elif command -v pbcopy &>/dev/null; then
		echo -n "$cmd" | pbcopy
	else
		yoga_error "❌ Nenhum clipboard manager encontrado (xclip/wl-copy/pbcopy)"
		return 1
	fi

	yoga_terra "📋 Copiado: $cmd"
}

function cc_action_edit {
	local cmd="$1"

	# Se for um arquivo, abre o arquivo
	if [[ -f "$cmd" ]]; then
		nvim "$cmd"
	else
		# Cria buffer temporário com o comando
		local tmpfile=$(mktemp /tmp/yoga-cc-XXXXXX)
		echo "$cmd" >"$tmpfile"
		nvim "$tmpfile"
		rm -f "$tmpfile"
	fi
}

function cc_action_contextual {
	local type="$1"
	local cmd="$2"

	case "$type" in
	git)
		# 🌿 Git checkout
		eval "$cmd"
		yoga_terra "🌿 Branch trocado!"
		;;
	docker)
		# 🐳 Docker exec
		eval "$cmd"
		;;
	*)
		yoga_agua "💫 Ação contextual não implementada para: $type"
		;;
	esac
}

function cc_action_execute {
	local cmd="$1"

	yoga_terra "🚀 Executando: $cmd"
	eval "$cmd"
}
