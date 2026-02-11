#!/bin/zsh
# yoga-files v2.0 - Sistema de Cores e Funções Yoga

##################
# Code # Colors  #
##################
#  00  # Off     #
#  30  # Black   #
#  31  # Red     #
#  32  # Green   #
#  33  # Yellow  #
#  34  # Blue    #
#  35  # Magenta #
#  36  # Cyan    #
#  37  # White   #
##################

# Cores Yoga Elements
export YOGA_FOGO='\033[1;31m'      # 🔥 Vermelho - Energia, ação, alerta
export YOGA_AGUA='\033[1;36m'      # 💧 Ciano - Fluidez, processo, informação
export YOGA_TERRA='\033[1;32m'     # 🌿 Verde - Estabilidade, sucesso, confirmação
export YOGA_AR='\033[1;34m'        # 🌬️ Azul - Leveza, progresso, movimento
export YOGA_ESPIRITO='\033[1;35m'  # 🧘 Roxo - Transcendência, sabedoria, conclusão
export YOGA_SOL='\033[1;33m'       # ☀️ Amarelo - Iluminação, aviso, atenção
export YOGA_LUA='\033[0;37m'       # 🌙 Branco - Clareza, pureza, neutro
export YOGA_RESET='\033[0m'        # Reset para cor padrão

# Emojis Yoga
export YOGA_FOGO_ICON='🔥'
export YOGA_AGUA_ICON='💧'
export YOGA_TERRA_ICON='🌿'
export YOGA_AR_ICON='🌬️'
export YOGA_ESPIRITO_ICON='🧘'
export YOGA_SOL_ICON='☀️'
export YOGA_LUA_ICON='🌙'

# Funções de Mensagem com Elementos Yoga
function yoga_fogo {
    echo -e "${YOGA_FOGO}${YOGA_FOGO_ICON} FOGO! $1 ${YOGA_RESET}"
}

function yoga_agua {
    echo -e "${YOGA_AGUA}${YOGA_AGUA_ICON} ÁGUA! $1 ${YOGA_RESET}"
}

function yoga_terra {
    echo -e "${YOGA_TERRA}${YOGA_TERRA_ICON} TERRA! $1 ${YOGA_RESET}"
}

function yoga_ar {
    echo -e "${YOGA_AR}${YOGA_AR_ICON} AR! $1 ${YOGA_RESET}"
}

function yoga_espirito {
    echo -e "${YOGA_ESPIRITO}${YOGA_ESPIRITO_ICON} ESPÍRITO! $1 ${YOGA_RESET}"
}

function yoga_sol {
    echo -e "${YOGA_SOL}${YOGA_SOL_ICON} SOL! $1 ${YOGA_RESET}"
}

function yoga_lua {
    echo -e "${YOGA_LUA}${YOGA_LUA_ICON} LUA! $1 ${YOGA_RESET}"
}

# Funções Legacy (mantidas para compatibilidade)
function yoga_fail {
    yoga_fogo "✖ $1 ✖"
}

function yoga_success {
    yoga_terra "✔ $1 ✔"
}

function yoga_message {
    yoga_ar "$1"
}

function yoga_warn {
    yoga_sol "⚠ $1 ⚠"
}

function yoga_action {
    echo -e "${YOGA_SOL}==> [$1] $2 ✔${YOGA_RESET}"
}

function yoga_readln {
    echo -en "${YOGA_AGUA}${YOGA_AGUA_ICON} $1 ${YOGA_RESET}"
    read answer
}

# Funções de Estado Yoga
function yoga_flow {
    echo -e "${YOGA_AGUA}🌊 FLOW STATE ATIVADO! ${YOGA_RESET}"
    echo -e "${YOGA_ESPIRITO}Você está em sincronia com o código...${YOGA_RESET}"
}

function yoga_breath {
    local message="${1:-Respire fundo e mantenha o foco...}"
    echo -e "${YOGA_AR}🫁 RESPIRAÇÃO: ${message}${YOGA_RESET}"
    sleep 1
}

function yoga_pose {
    local pose="${1:-Warrior}"
    echo -e "${YOGA_ESPIRITO}🧘 POSE: ${pose}${YOGA_RESET}"
}

function yoga_meditation {
    echo -e "${YOGA_ESPIRITO}🧘 MEDITAÇÃO: Centrando energia...${YOGA_RESET}"
    for i in {1..3}; do
        echo -n "."
        sleep 1
    done
    echo ""
    echo -e "${YOGA_TERRA}✨ Pronto para continuar!${YOGA_RESET}"
}

# Funções de Progresso
function yoga_progress {
    local current=$1
    local total=$2
    local percent=$((current * 100 / total))
    local bar_length=30
    local filled=$((percent * bar_length / 100))
    
    echo -en "\r${YOGA_AGUA}Progress: ["
    for ((i=0; i<filled; i++)); do echo -n "═"; done
    for ((i=filled; i<bar_length; i++)); do echo -n " "; done
    echo -en "] $percent% ${YOGA_RESET}"
}

# Função de Dashboard
function yoga_status {
    echo ""
    echo -e "${YOGA_ESPIRITO}╔══════════════════════════════════╗${YOGA_RESET}"
    echo -e "${YOGA_ESPIRITO}║    🧘 YOGA STATUS CHECK 🧘      ║${YOGA_RESET}"
    echo -e "${YOGA_ESPIRITO}╚══════════════════════════════════╝${YOGA_RESET}"
    echo ""
    
    # Check Git
    if command -v git &>/dev/null; then
        echo -e "${YOGA_TERRA}✔ Git instalado${YOGA_RESET}"
    else
        echo -e "${YOGA_FOGO}✖ Git não encontrado${YOGA_RESET}"
    fi
    
    # Check Node
    if command -v node &>/dev/null; then
        echo -e "${YOGA_TERRA}✔ Node.js $(node -v)${YOGA_RESET}"
    else
        echo -e "${YOGA_FOGO}✖ Node.js não encontrado${YOGA_RESET}"
    fi
    
    # Check Neovim
    if command -v nvim &>/dev/null; then
        echo -e "${YOGA_TERRA}✔ Neovim instalado${YOGA_RESET}"
    else
        echo -e "${YOGA_FOGO}✖ Neovim não encontrado${YOGA_RESET}"
    fi
    
    # Check ASDF
    if command -v asdf &>/dev/null; then
        echo -e "${YOGA_TERRA}✔ ASDF instalado${YOGA_RESET}"
    else
        echo -e "${YOGA_FOGO}✖ ASDF não encontrado${YOGA_RESET}"
    fi
    
    echo ""
}

# Exportar funcoes apenas quando suportado (bash).
if [ -n "${BASH_VERSION-}" ]; then
  export -f yoga_fogo
  export -f yoga_agua
  export -f yoga_terra
  export -f yoga_ar
  export -f yoga_espirito
  export -f yoga_sol
  export -f yoga_lua
  export -f yoga_fail
  export -f yoga_success
  export -f yoga_message
  export -f yoga_warn
  export -f yoga_action
  export -f yoga_readln
  export -f yoga_flow
  export -f yoga_breath
  export -f yoga_pose
  export -f yoga_meditation
  export -f yoga_progress
  export -f yoga_status
fi
