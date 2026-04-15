#!/usr/bin/env zsh
# 🤖 core/modules/ai/engine.sh
# @name: ai-engine
# @desc: AI Assistant engine (reimplementação de rag*.zsh) 🤖
# @usage: source "${YOGA_HOME}/core/modules/ai/engine.sh"
# @author: Yoga 3.0 Lôro Barizon Edition 🦜

emulate -L zsh
set -euo pipefail

# 📦 Source
source "${YOGA_HOME}/core/utils/ui.sh"
source "${YOGA_HOME}/core/modules/ai/provider.sh"
source "${YOGA_HOME}/core/modules/ai/rag.sh"

# ═══════════════════════════════════════════════════════════
# 🤖 MAIN ENGINE
# ═══════════════════════════════════════════════════════════

function ai_engine_ask {
	local question="$1"

	yoga_agua "🔍 Buscando contexto..."
	local context=$(ai_rag_retrieve "$question" 5)

	yoga_agua "🤖 Consultando IA..."
	local response=$(ai_provider_query "$question" "$context")

	echo "$response"
}
