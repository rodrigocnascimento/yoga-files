#!/usr/bin/env zsh
# 🤖 core/modules/ai/rag.sh
# @name: ai-rag
# @desc: RAG (Retrieval Augmented Generation) usando logs 🤖
# @usage: source "${YOGA_HOME}/core/modules/ai/rag.sh"
# @author: Yoga 3.0 Lôro Barizon Edition 🦜

set -euo pipefail

# 📦 Source
source "${YOGA_HOME}/core/utils/ui.sh"
source "${YOGA_HOME}/core/state/api.sh"

# ═══════════════════════════════════════════════════════════
# 🔍 RAG RETRIEVAL
# ═══════════════════════════════════════════════════════════

function ai_rag_retrieve {
	local query="$1"
	local limit="${2:-5}"

	# 🔍 Simple keyword search (BM25 via SQLite FTS5)
	local keywords=$(echo "$query" | tr ' ' '|')

	local results
	results=$(sqlite3 "$YOGA_STATE_DB" "
        SELECT content FROM logs_fts 
        WHERE logs_fts MATCH '$keywords'
        ORDER BY rank
        LIMIT $limit;
    " 2>/dev/null || true)

	# Format results
	if [[ -n "$results" ]]; then
		echo "Contexto relevante dos logs:"
		echo "$results" | while IFS= read -r line; do
			echo "- $line"
		done
	else
		echo "(sem contexto relevante encontrado)"
	fi
}

function ai_rag_index_log {
	local content="$1"
	local source="${2:-log}"

	# Add to ai_context table
	yoga_ai_context_add "$content" "$source"
}
