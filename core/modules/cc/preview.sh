#!/usr/bin/env zsh
# 🎯 core/modules/cc/preview.sh
# @name: cc-preview
# @desc: Preview para itens do Command Center 🎯
# @usage: cc_preview <line>
# @author: Yoga 3.0 Lôro Barizon Edition 🦜

set -euo pipefail

function cc_preview {
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
		type "$label" 2>/dev/null | head -5
		;;
	git)
		echo "🌿 Branch: ${label}"
		echo "📋 Log recente:"
		git log --oneline -3 "${label}" 2>/dev/null || echo "  (sem histórico)"
		;;
	docker)
		echo "🐳 Container: ${label}"
		docker ps --filter "name=${label}" --format "Status: {{.Status}}" 2>/dev/null || echo "  (status indisponível)"
		;;
	history)
		echo "📜 Histórico: ${label}"
		;;
	*)
		echo "❓ Tipo desconhecido: ${type}"
		echo "📋 Linha: ${line}"
		;;
	esac
}
