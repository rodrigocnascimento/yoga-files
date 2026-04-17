#!/usr/bin/env zsh
# 📦 core/daemon/lifecycle.sh
# @name: daemon-lifecycle
# @desc: Daemon lifecycle management (start/stop/status/restart) 📦
# @usage: source "$YOGA_HOME/core/daemon/lifecycle.sh"
# @author: Yoga 3.0 Lôro Barizon Edition 🦜

emulate -L zsh
set -euo pipefail

# 📦 Source dependencies
source "${YOGA_HOME}/core/utils/ui.sh"
source "${YOGA_HOME}/core/daemon/server.sh"

# ═══════════════════════════════════════════════════════════
# 🚀 PUBLIC API
# ═══════════════════════════════════════════════════════════

# 🎬 Start daemon
# @usage: yoga_daemon_start [--foreground]
function yoga_daemon_start {
	local foreground="${1:-}"

	yoga_header "🚀 Iniciando Yoga Daemon"

	# 🔍 Verifica dependências
	if ! command -v sqlite3 &>/dev/null; then
		yoga_fogo "💾 SQLite3 não instalado!"
		return 1
	fi

	if ! command -v socat &>/dev/null && ! command -v nc &>/dev/null; then
		yoga_fogo "🔌 Socat ou nc não instalados!"
		return 1
	fi

	if ! command -v jq &>/dev/null; then
		yoga_fogo "📦 jq não instalado!"
		return 1
	fi

	# 🧹 Garante diretórios
	mkdir -p "${YOGA_HOME}/logs"
	mkdir -p "${YOGA_HOME}/plugins"

	# 🚀 Inicia servidor
	if [[ "$foreground" == "--foreground" ]]; then
		yoga_sol "👹 Modo foreground ativado (Ctrl+C para parar)"
		yoga_daemon_server_start
		# Aguarda no foreground
		local pid=$(cat "${YOGA_PIDFILE}" 2>/dev/null)
		[[ -n "$pid" ]] && wait "$pid"
	else
		yoga_daemon_server_start
	fi
}

# 🛑 Stop daemon
# @usage: yoga_daemon_stop [--force]
function yoga_daemon_stop {
	local force="${1:-}"

	yoga_header "🛑 Parando Yoga Daemon"

	if ! yoga_daemon_is_running; then
		yoga_sol "👹 Daemon não está rodando"
		return 0
	fi

	if [[ "$force" == "--force" ]]; then
		yoga_warning "💀 Modo forçado ativado!"
	fi

	yoga_daemon_server_stop
}

# 📊 Daemon status
# @usage: yoga_daemon_status
function yoga_daemon_status {
	yoga_header "📊 Status do Yoga Daemon"

	if yoga_daemon_is_running; then
		local pid=$(cat "${YOGA_PIDFILE}" 2>/dev/null)
		local uptime=$(ps -o etime= -p "$pid" 2>/dev/null | tr -d ' ' || echo "?")

		yoga_terra "👹 Daemon está rodando!"
		echo ""
		yoga_table_header "🔧 Propriedade" "📋 Valor"
		yoga_table_row "🆔 PID" "$pid"
		yoga_table_row "⏱️  Uptime" "$uptime"
		yoga_table_row "🔌 Socket" "${YOGA_SOCKET/#$HOME/~}"
		yoga_table_row "💾 Database" "${YOGA_STATE_DB/#$HOME/~}"
		yoga_table_row "📝 Log" "${YOGA_LOG/#$HOME/~}"
		echo ""

		# 📊 Estatísticas
		if [[ -f "$YOGA_STATE_DB" ]]; then
			local workspaces=$(sqlite3 "$YOGA_STATE_DB" "SELECT COUNT(*) FROM workspaces;" 2>/dev/null || echo 0)
			local plugins=$(sqlite3 "$YOGA_STATE_DB" "SELECT COUNT(*) FROM plugins;" 2>/dev/null || echo 0)
			local logs=$(sqlite3 "$YOGA_STATE_DB" "SELECT COUNT(*) FROM logs;" 2>/dev/null || echo 0)

			yoga_section "📈 Estatísticas"
			echo "  🌌 Workspaces: $workspaces"
			echo "  🔌 Plugins: $plugins"
			echo "  📝 Logs: $logs"
		fi
	else
		yoga_error "👹 Daemon não está rodando"
		echo ""
		yoga_agua "💡 Inicie com: yoga daemon start"
	fi
}

# 🔄 Restart daemon
# @usage: yoga_daemon_restart
function yoga_daemon_restart {
	yoga_header "🔄 Reiniciando Yoga Daemon"
	yoga_daemon_stop
	sleep 0.5
	yoga_daemon_start
}

# 🧹 Cleanup (remove stale files)
# @usage: yoga_daemon_cleanup
function yoga_daemon_cleanup {
	yoga_header "🧹 Limpando arquivos stale"

	# Remove socket se não há daemon rodando
	if [[ -S "$YOGA_SOCKET" ]] && ! yoga_daemon_is_running; then
		rm -f "$YOGA_SOCKET"
		yoga_terra "🧹 Socket removido: ${YOGA_SOCKET/#$HOME/~}"
	fi

	# Remove pidfile se processo não existe
	if [[ -f "$YOGA_PIDFILE" ]]; then
		local pid=$(cat "$YOGA_PIDFILE" 2>/dev/null || echo "")
		if ! kill -0 "$pid" 2>/dev/null; then
			rm -f "$YOGA_PIDFILE"
			yoga_terra "🧹 PID file removido: ${YOGA_PIDFILE/#$HOME/~}"
		fi
	fi

	yoga_terra "✅ Cleanup concluído!"
}

# ═══════════════════════════════════════════════════════════
# 🎯 CLI COMMANDS
# ═══════════════════════════════════════════════════════════

# Handler para comando: yoga daemon <action>
function yoga_daemon_command {
	local action="${1:-status}"
	[[ $# -gt 0 ]] && shift

	case "$action" in
	--help | -h)
		echo "👹 Yoga Daemon Manager"
		echo ""
		echo "Usage: yoga daemon <command>"
		echo ""
		echo "Commands:"
		echo "  start        Inicia o daemon"
		echo "  stop         Para o daemon"
		echo "  restart      Reinicia o daemon"
		echo "  status       Mostra status do daemon"
		echo "  cleanup      Remove arquivos stale (socket, pid)"
		echo "  foreground   Inicia em modo foreground (debug)"
		echo ""
		echo "Examples:"
		echo "  yoga daemon start        # Inicia daemon"
		echo "  yoga daemon status       # Verifica status"
		echo "  yoga daemon restart      # Reinicia daemon"
		echo "  yoga daemon cleanup      # Limpa arquivos antigos"
		return 0
		;;
	start)
		yoga_daemon_start "$@"
		;;
	stop)
		yoga_daemon_stop "$@"
		;;
	restart)
		yoga_daemon_restart
		;;
	status)
		yoga_daemon_status
		;;
	cleanup)
		yoga_daemon_cleanup
		;;
	foreground)
		yoga_daemon_start --foreground
		;;
	*)
		yoga_fogo "❌ Ação desconhecida: $action"
		echo ""
		yoga_info "📋 Ações disponíveis:"
		echo "  🚀 start       - Inicia o daemon"
		echo "  🛑 stop        - Para o daemon"
		echo "  🔄 restart     - Reinicia o daemon"
		echo "  📊 status      - Mostra status"
		echo "  🧹 cleanup     - Remove arquivos stale"
		echo "  📺 foreground  - Inicia em modo foreground"
		return 1
		;;
	esac
}
