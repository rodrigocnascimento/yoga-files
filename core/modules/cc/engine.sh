#!/usr/bin/env zsh
# 🎯 core/modules/cc/engine.sh
# @name: cc-engine
# @desc: Command Center interativo (reimplementação de cc.zsh) 🎯
# @usage: source "${YOGA_HOME}/core/modules/cc/engine.sh" && cc_engine_run
# @author: Yoga 2.0 Efigenia Edition 🧘‍♂️

emulate -L zsh
set -euo pipefail

# 📦 Source
source "${YOGA_HOME}/core/utils/ui.sh"
source "${YOGA_HOME}/core/modules/cc/data.sh"
source "${YOGA_HOME}/core/modules/cc/action.sh"

# ═══════════════════════════════════════════════════════════
# 🎯 MAIN ENGINE
# ═══════════════════════════════════════════════════════════

function cc_engine_run {
	yoga_agua "🎯 Coletando dados..."

	# 📊 Coleta dados
	local data=$(cc_data_collect)

	# 🎨 Interface fzf (replica cc.zsh original)
	local selected=$(echo "$data" | fzf \
		--prompt="🚀 Command Center > " \
		--height=90% \
		--layout=reverse \
		--border \
		--delimiter='\|' \
		--with-nth=2 \
		--preview 'cc_preview {}' \
		--preview-window=down:3:wrap \
		--expect=enter,ctrl-y,ctrl-e,ctrl-x)

	[[ -z "$selected" ]] && return

	# 🔍 Parse
	local key=$(head -1 <<<"$selected")
	local line=$(sed -n '2p' <<<"$selected")
	[[ -z "$line" ]] && return

	# 🎯 Processa
	cc_action_process "$key" "$line"
}
