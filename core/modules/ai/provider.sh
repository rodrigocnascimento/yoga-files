#!/usr/bin/env zsh
# 🤖 core/modules/ai/provider.sh
# @name: ai-provider
# @desc: Provider abstraction (Ollama/OpenAI/Anthropic) 🤖
# @usage: source "${YOGA_HOME}/core/modules/ai/provider.sh"
# @author: Yoga 3.0 Lôro Barizon Edition 🦜

set -euo pipefail

# 📦 Source
source "${YOGA_HOME}/core/utils/ui.sh"

# 🎯 Config
YOGA_AI_PROVIDER="${YOGA_AI_PROVIDER:-ollama}"
YOGA_AI_MODEL="${YOGA_AI_MODEL:-llama3.2}"
YOGA_OLLAMA_HOST="${OLLAMA_HOST:-http://localhost:11434}"

# ═══════════════════════════════════════════════════════════
# 🔌 PROVIDER INTERFACE
# ═══════════════════════════════════════════════════════════

function ai_provider_query {
	local question="$1"
	local context="${2:-}"

	case "$YOGA_AI_PROVIDER" in
	ollama)
		_ai_provider_ollama "$question" "$context"
		;;
	openai)
		_ai_provider_openai "$question" "$context"
		;;
	anthropic)
		_ai_provider_anthropic "$question" "$context"
		;;
	*)
		yoga_fogo "❌ Provider desconhecido: $YOGA_AI_PROVIDER"
		return 1
		;;
	esac
}

function _ai_provider_ollama {
	local question="$1"
	local context="$2"

	# Build prompt with context
	local full_prompt="$question"
	[[ -n "$context" ]] && full_prompt="Contexto:\n${context}\n\nPergunta: ${question}"

	# Check if Ollama is running
	if ! curl -s "$YOGA_OLLAMA_HOST/api/tags" &>/dev/null; then
		yoga_fogo "🤖 Ollama não está rodando em $YOGA_OLLAMA_HOST"
		return 1
	fi

	# Call Ollama API
	local response
	response=$(curl -s -X POST "$YOGA_OLLAMA_HOST/api/generate" \
		-H "Content-Type: application/json" \
		-d "$(jq -n \
			--arg model "$YOGA_AI_MODEL" \
			--arg prompt "$full_prompt" \
			'{model: $model, prompt: $prompt, stream: false}')" \
		2>/dev/null)

	# Parse response
	echo "$response" | jq -r '.response // "🤔 Não consegui gerar resposta"'
}

function _ai_provider_openai {
	local question="$1"
	local context="$2"

	yoga_error "🔌 OpenAI provider - TODO (implementar)"
	return 1
}

function _ai_provider_anthropic {
	local question="$1"
	local context="$2"

	yoga_error "🔌 Anthropic provider - TODO (implementar)"
	return 1
}
