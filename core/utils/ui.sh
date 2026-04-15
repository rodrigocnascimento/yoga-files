#!/usr/bin/env zsh
# 🎨 core/utils/ui.sh
# @name: ui-utils
# @desc: Funções de UI com emojis para Yoga 3.0 🦜
# @usage: source "$YOGA_HOME/core/utils/ui.sh"
# @author: Yoga 3.0 Lôro Barizon Edition 🦜

# 🏷️ Version & Identity (single source of truth)
export YOGA_VERSION="${YOGA_VERSION:-3.0.0}"
export YOGA_CODENAME="${YOGA_CODENAME:-Lôro Barizon Edition}"
export YOGA_EMOJI="${YOGA_EMOJI:-🦜}"

# 🌈 Cores ANSI
export YOGA_COLOR_RESET='\033[0m'
export YOGA_COLOR_FOGO='\033[0;31m'     # 🔥 Vermelho
export YOGA_COLOR_TERRA='\033[0;32m'    # 🌍 Verde
export YOGA_COLOR_AGUA='\033[0;34m'     # 💧 Azul
export YOGA_COLOR_AR='\033[0;36m'       # 💨 Ciano
export YOGA_COLOR_ESPIRITO='\033[0;35m' # 👻 Magenta
export YOGA_COLOR_SOL='\033[0;33m'      # ☀️ Amarelo
export YOGA_COLOR_LUA='\033[0;37m'      # 🌙 Cinza claro
export YOGA_COLOR_BOLD='\033[1m'        # 💪 Negrito

# 🎯 Elementos da Natureza (estados)
function yoga_fogo {
	# 🔥 Erro crítico - sai com erro
	printf "${YOGA_COLOR_FOGO}🔥 ERRO: %s${YOGA_COLOR_RESET}\n" "$*" >&2
	return 1
}

function yoga_terra {
	# 🌍 Sucesso/Confirmação
	printf "${YOGA_COLOR_TERRA}✅ %s${YOGA_COLOR_RESET}\n" "$*"
}

function yoga_agua {
	# 💧 Info/Processando
	printf "${YOGA_COLOR_AGUA}💧 %s${YOGA_COLOR_RESET}\n" "$*"
}

function yoga_ar {
	# 💨 Aviso/Alerta
	printf "${YOGA_COLOR_AR}⚠️  %s${YOGA_COLOR_RESET}\n" "$*"
}

function yoga_espirito {
	# 👻 Debug/Detalhes técnicos
	printf "${YOGA_COLOR_ESPIRITO}👻 %s${YOGA_COLOR_RESET}\n" "$*"
}

function yoga_sol {
	# ☀️ Destaque importante
	printf "${YOGA_COLOR_SOL}☀️  %s${YOGA_COLOR_RESET}\n" "$*"
}

function yoga_lua {
	# 🌙 Secundário/Subtle
	printf "${YOGA_COLOR_LUA}🌙 %s${YOGA_COLOR_RESET}\n" "$*"
}

# 🎨 Funções específicas por contexto
function yoga_header {
	# 📦 Header decorado
	local title="$1"
	printf "\n${YOGA_COLOR_BOLD}${YOGA_COLOR_AGUA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${YOGA_COLOR_RESET}\n"
	printf "${YOGA_COLOR_BOLD}${YOGA_COLOR_AGUA}  🧘‍♂️  %s${YOGA_COLOR_RESET}\n" "$title"
	printf "${YOGA_COLOR_BOLD}${YOGA_COLOR_AGUA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${YOGA_COLOR_RESET}\n\n"
}

function yoga_section {
	# 📑 Seção
	local title="$1"
	printf "\n${YOGA_COLOR_BOLD}${YOGA_COLOR_TERRA}▶ %s${YOGA_COLOR_RESET}\n" "$title"
	printf "${YOGA_COLOR_TERRA}────────────────────────────────────${YOGA_COLOR_RESET}\n"
}

function yoga_loading {
	# ⏳ Loading spinner message
	local msg="${1:-Processando...}"
	printf "${YOGA_COLOR_AGUA}⏳ %s${YOGA_COLOR_RESET}\n" "$msg"
}

function yoga_success {
	# 🎉 Sucesso celebrado
	printf "${YOGA_COLOR_TERRA}🎉 %s${YOGA_COLOR_RESET}\n" "$*"
}

function yoga_error {
	# 💥 Erro sem sair
	printf "${YOGA_COLOR_FOGO}💥 %s${YOGA_COLOR_RESET}\n" "$*" >&2
}

function yoga_warning {
	# ⚡ Warning
	printf "${YOGA_COLOR_SOL}⚡ %s${YOGA_COLOR_RESET}\n" "$*"
}

function yoga_info {
	# ℹ️ Info neutra
	printf "${YOGA_COLOR_AGUA}ℹ️  %s${YOGA_COLOR_RESET}\n" "$*"
}

function yoga_debug {
	# 🐛 Debug (só mostra se YOGA_DEBUG=1)
	if [[ "${YOGA_DEBUG:-0}" == "1" ]]; then
		printf "${YOGA_COLOR_ESPIRITO}🐛 [DEBUG] %s${YOGA_COLOR_RESET}\n" "$*"
	fi
}

# 🎪 Funções interativas
function yoga_prompt {
	# ❓ Pergunta ao usuário
	local question="$1"
	printf "${YOGA_COLOR_SOL}❓ %s${YOGA_COLOR_RESET} " "$question"
}

function yoga_choice {
	# 🔢 Escolha numérica
	local n="$1"
	local text="$2"
	printf "${YOGA_COLOR_AGUA}  [%s]${YOGA_COLOR_RESET} %s\n" "$n" "$text"
}

function yoga_progress {
	# 📊 Progresso (current/total)
	local current="$1"
	local total="$2"
	local msg="${3:-Progresso}"
	printf "${YOGA_COLOR_AGUA}📊 %s: %d/%d${YOGAGA_COLOR_RESET}\n" "$msg" "$current" "$total"
}

# 🏷️ Tags e labels
function yoga_tag {
	# 🏷️ Tag colorida
	local color="$1"
	local text="$2"

	case "$color" in
	red | error | erro) printf "${YOGA_COLOR_FOGO}[%s]${YOGA_COLOR_RESET}" "$text" ;;
	green | ok | success) printf "${YOGA_COLOR_TERRA}[%s]${YOGA_COLOR_RESET}" "$text" ;;
	blue | info) printf "${YOGA_COLOR_AGUA}[%s]${YOGA_COLOR_RESET}" "$text" ;;
	yellow | warn) printf "${YOGA_COLOR_SOL}[%s]${YOGA_COLOR_RESET}" "$text" ;;
	purple | debug) printf "${YOGA_COLOR_ESPIRITO}[%s]${YOGA_COLOR_RESET}" "$text" ;;
	*) printf "[%s]" "$text" ;;
	esac
}

# 📊 Tabela simples
function yoga_table_header {
	# 📋 Header de tabela
	printf "\n${YOGA_COLOR_BOLD}%-20s %s${YOGA_COLOR_RESET}\n" "$1" "$2"
	printf "${YOGA_COLOR_LUA}────────────────────────────────────────────────${YOGA_COLOR_RESET}\n"
}

function yoga_table_row {
	# 📄 Linha de tabela
	printf "%-20s %s\n" "$1" "$2"
}

# 🧹 Utils
function yoga_clear_line {
	# Limpa linha atual (para spinners)
	printf "\r\033[K"
}

function yoga_spinner {
	# 🔄 Retorna próximo char de spinner
	local chars='🌑🌒🌓🌔🌕🌖🌗🌘'
	# Uso: while true; do printf "\r%s Processando..." "$(yoga_spinner)"; sleep 0.1; done
	echo -n "${chars:$((i % 8)):1}"
}

# 🎭 Emojis helpers
function yoga_emoji {
	# Retorna emoji por categoria
	local category="$1"
	case "$category" in
	daemon) echo "👹" ;;
	cc) echo "🎯" ;;
	workspace) echo "🌌" ;;
	ai) echo "🤖" ;;
	plugin) echo "🔌" ;;
	log) echo "📝" ;;
	state) echo "💾" ;;
	git) echo "🌿" ;;
	docker) echo "🐳" ;;
	*) echo "✨" ;;
	esac
}

# 🎨 Banner
function yoga_banner {
	# 🦜 Banner do Yoga — uses YOGA_VERSION, YOGA_CODENAME, YOGA_EMOJI
	local v_line="  ${YOGA_EMOJI}  YOGA ${YOGA_VERSION} - ${YOGA_CODENAME}  "
	local s_line="     ✨ Engine de Desenvolvimento     "
	printf "\n"
	printf "${YOGA_COLOR_AGUA}    ╭──────────────────────────────────────╮${YOGA_COLOR_RESET}\n"
	printf "${YOGA_COLOR_AGUA}    │${YOGA_COLOR_RESET}${YOGA_COLOR_BOLD}%s${YOGA_COLOR_RESET}${YOGA_COLOR_AGUA}│${YOGA_COLOR_RESET}\n" "$v_line"
	printf "${YOGA_COLOR_AGUA}    │${YOGA_COLOR_RESET}%s${YOGA_COLOR_AGUA}│${YOGA_COLOR_RESET}\n" "$s_line"
	printf "${YOGA_COLOR_AGUA}    ╰──────────────────────────────────────╯${YOGA_COLOR_RESET}\n"
	printf "\n"
}

# 🏁 Inicialização
function yoga_ui_init {
	# Verifica se terminal suporta cores
	if [[ -t 1 && "${TERM}" != "dumb" ]]; then
		YOGA_UI_COLORS=1
	else
		YOGA_UI_COLORS=0
		# Desabilita cores se não suportado
		YOGA_COLOR_RESET=''
		YOGA_COLOR_FOGO=''
		YOGA_COLOR_TERRA=''
		YOGA_COLOR_AGUA=''
		YOGA_COLOR_AR=''
		YOGA_COLOR_ESPIRITO=''
		YOGA_COLOR_SOL=''
		YOGA_COLOR_LUA=''
		YOGA_COLOR_BOLD=''
	fi
}

# Inicializa automaticamente
yoga_ui_init
