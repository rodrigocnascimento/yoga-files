#!/usr/bin/env zsh
# 🔗 core/sync/api.sh
# @name: sync-api
# @desc: Dual-mode Sync API (Local SQLite / Firebase Firestore) for Yoga 3.0 🔗
# @usage: source "$YOGA_HOME/core/sync/api.sh"
# @author: Yoga 3.0 Lôro Barizon Edition 🦜

set -euo pipefail

YOGA_SYNC_MODE="${YOGA_SYNC_MODE:-local}"
YOGA_SYNC_CONFIG="${YOGA_HOME}/.yoga-sync.json"

function _yoga_sync_mode {
	if [[ "$YOGA_SYNC_MODE" == "cloud" ]]; then
		echo "cloud"
	else
		echo "local"
	fi
}

function _yoga_sync_is_cloud {
	[[ "$YOGA_SYNC_MODE" == "cloud" ]] && [[ -f "${YOGA_HOME}/.firebase-credentials.json" ]]
}

function _yoga_sync_is_configured {
	if [[ "$YOGA_SYNC_MODE" == "cloud" ]]; then
		[[ -f "${YOGA_HOME}/.firebase-credentials.json" ]]
	else
		return 0
	fi
}

function _yoga_sync_get_user_id {
	if [[ -f "$YOGA_SYNC_CONFIG" ]]; then
		local user_id=$(jq -r '.userId // "unknown"' "$YOGA_SYNC_CONFIG" 2>/dev/null || echo "unknown")
		echo "$user_id"
	else
		echo "unknown"
	fi
}

function _yoga_sync_get_last_sync {
	if [[ -f "$YOGA_SYNC_CONFIG" ]]; then
		local last_sync=$(jq -r '.lastSync // "never"' "$YOGA_SYNC_CONFIG" 2>/dev/null || echo "never")
		echo "$last_sync"
	else
		echo "never"
	fi
}

function _yoga_sync_count_workspaces {
	if [[ -f "${YOGA_HOME}/state.db" ]]; then
		sqlite3 "${YOGA_HOME}/state.db" "SELECT COUNT(*) FROM workspaces;" 2>/dev/null || echo "0"
	else
		echo "0"
	fi
}

function _yoga_sync_count_commands {
	if [[ -f "${YOGA_HOME}/state.db" ]]; then
		sqlite3 "${YOGA_HOME}/state.db" "SELECT COUNT(*) FROM commands;" 2>/dev/null || echo "0"
	else
		echo "0"
	fi
}

function _yoga_sync_count_ai_context {
	if [[ -f "${YOGA_HOME}/state.db" ]]; then
		sqlite3 "${YOGA_HOME}/state.db" "SELECT COUNT(*) FROM ai_context;" 2>/dev/null || echo "0"
	else
		echo "0"
	fi
}

function _yoga_sync_status {
	local mode="$(_yoga_sync_mode)"
	local user_id="$(_yoga_sync_get_user_id)"
	local last_sync="$(_yoga_sync_get_last_sync)"
	local ws_count="$(_yoga_sync_count_workspaces)"
	local cmd_count="$(_yoga_sync_count_commands)"
	local ai_count="$(_yoga_sync_count_ai_context)"

	echo "📁 Mode: $mode"

	if _yoga_sync_is_cloud; then
		echo "🔗 Cloud: configured (Firebase)"
		echo "👤 User: $user_id"
		echo "📤 Last synced: $last_sync"
	else
		echo "📦 Cloud: not configured (local mode)"
		echo "💡 Run: yoga sync setup"
	fi

	echo "🎯 Workspaces: $ws_count ($(_yoga_sync_mode))"
	echo "📝 Commands: $cmd_count ($(_yoga_sync_mode))"
	echo "🤖 AI Context: $ai_count ($(_yoga_sync_mode))"
	echo "📋 Logs: local only (not synced)"
}

function _yoga_sync_setup_local {
	YOGA_SYNC_MODE="local"

	jq -n --arg mode "local" '{mode: $mode, lastSync: "never"}' >"$YOGA_SYNC_CONFIG"

	yoga_terra "✅ Local mode configured"
	yoga_agua "   Data stays on this machine only."
}

function _yoga_sync_setup_cloud {
	yoga_agua "🔗 Setting up cloud sync..."

	if ! command -v node &>/dev/null; then
		yoga_fogo "❌ Node.js is required for cloud sync!"
		yoga_sol "   Install with: https://nodejs.org"
		return 1
	fi

	local sync_dir="${YOGA_HOME}/core/sync"
	if [[ ! -d "$sync_dir/node_modules" ]]; then
		yoga_agua "📦 Installing Firebase dependencies..."
		(cd "$sync_dir" && npm install --silent 2>/dev/null) || {
			yoga_fogo "❌ Failed to install Firebase dependencies"
			return 1
		}
	fi

	yoga_sol "⚠️ Firebase OAuth setup is coming in the next phase."
	yoga_sol "   For now, place your Firebase credentials in:"
	yoga_sol "   ${YOGA_HOME}/.firebase-credentials.json"
	yoga_sol ""
	yoga_sol "   Set YOGA_SYNC_MODE=cloud to enable cloud sync."

	YOGA_SYNC_MODE="cloud"
	jq -n --arg mode "cloud" --arg userId "pending" '{mode: $mode, userId: $userId, lastSync: "never"}' >"$YOGA_SYNC_CONFIG"
}

function _yoga_sync_reset {
	YOGA_SYNC_MODE="local"

	jq -n --arg mode "local" '{mode: $mode, lastSync: "never"}' >"$YOGA_SYNC_CONFIG"

	if [[ -f "${YOGA_HOME}/.firebase-credentials.json" ]]; then
		rm -f "${YOGA_HOME}/.firebase-credentials.json"
		yoga_terra "✅ Firebase credentials removed"
	fi

	yoga_terra "✅ Reverted to local mode (SQLite)"
	yoga_sol "   Set YOGA_SYNC_MODE=local to make it permanent"
}

function _yoga_sync_push {
	if ! _yoga_sync_is_cloud; then
		yoga_fogo "❌ Cloud sync is not configured!"
		yoga_sol "   Run: yoga sync setup"
		return 1
	fi

	yoga_agua "📤 Pushing data to Firebase..."

	local sync_dir="${YOGA_HOME}/core/sync"
	if [[ ! -d "$sync_dir/node_modules" ]]; then
		yoga_fogo "❌ Firebase dependencies not installed!"
		yoga_sol "   Run: yoga sync setup"
		return 1
	fi

	node "${sync_dir}/sync.mjs" push 2>/dev/null || {
		yoga_fogo "❌ Push failed!"
		return 1
	}

	local now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
	local tmp=$(mktemp)
	jq --arg ts "$now" '.lastSync = $ts' "$YOGA_SYNC_CONFIG" >"$tmp" && mv "$tmp" "$YOGA_SYNC_CONFIG"

	yoga_terra "✅ Data pushed to cloud!"
}

function _yoga_sync_pull {
	if ! _yoga_sync_is_cloud; then
		yoga_fogo "❌ Cloud sync is not configured!"
		yoga_sol "   Run: yoga sync setup"
		return 1
	fi

	yoga_agua "📥 Pulling data from Firebase..."

	local sync_dir="${YOGA_HOME}/core/sync"
	if [[ ! -d "$sync_dir/node_modules" ]]; then
		yoga_fogo "❌ Firebase dependencies not installed!"
		yoga_sol "   Run: yoga sync setup"
		return 1
	fi

	node "${sync_dir}/sync.mjs" pull 2>/dev/null || {
		yoga_fogo "❌ Pull failed!"
		return 1
	}

	local now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
	local tmp=$(mktemp)
	jq --arg ts "$now" '.lastSync = $ts' "$YOGA_SYNC_CONFIG" >"$tmp" && mv "$tmp" "$YOGA_SYNC_CONFIG"

	yoga_terra "✅ Data pulled from cloud!"
}
