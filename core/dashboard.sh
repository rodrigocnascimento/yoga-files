#!/bin/zsh
# yoga-files v2.0 - Dashboard Principal

YOGA_HOME="${YOGA_HOME:-$HOME/.yoga}"
source "$YOGA_HOME/core/utils.sh"

# Dashboard interativo principal
yoga_dashboard() {
    clear
    
    # Banner
    echo ""
    echo -e "${YOGA_ESPIRITO}╔════════════════════════════════════════╗${YOGA_RESET}"
    echo -e "${YOGA_ESPIRITO}║        🧘 YOGA FILES DASHBOARD 🧘      ║${YOGA_RESET}"
    echo -e "${YOGA_ESPIRITO}╚════════════════════════════════════════╝${YOGA_RESET}"
    echo ""
    
    # Status do Sistema
    echo -e "${YOGA_FOGO}🔥 STATUS DO SISTEMA${YOGA_RESET}"
    echo -e "${YOGA_FOGO}━━━━━━━━━━━━━━━━━━━${YOGA_RESET}"
    
    # Git
    if command -v git &>/dev/null; then
        local git_user=$(git config --global user.name 2>/dev/null || echo "Não configurado")
        local git_email=$(git config --global user.email 2>/dev/null || echo "Não configurado")
        echo -e "${YOGA_TERRA}✅ Git:${YOGA_RESET} $git_user <$git_email>"
    else
        echo -e "${YOGA_FOGO}❌ Git:${YOGA_RESET} Não instalado"
    fi
    
    # Node.js
    if command -v node &>/dev/null; then
        echo -e "${YOGA_TERRA}✅ Node.js:${YOGA_RESET} $(node -v)"
    else
        echo -e "${YOGA_FOGO}❌ Node.js:${YOGA_RESET} Não instalado"
    fi
    
    # npm
    if command -v npm &>/dev/null; then
        echo -e "${YOGA_TERRA}✅ npm:${YOGA_RESET} v$(npm -v)"
    else
        echo -e "${YOGA_FOGO}❌ npm:${YOGA_RESET} Não instalado"
    fi
    
    # TypeScript
    if command -v tsc &>/dev/null; then
        echo -e "${YOGA_TERRA}✅ TypeScript:${YOGA_RESET} v$(tsc -v | awk '{print $2}')"
    else
        echo -e "${YOGA_SOL}⚠️ TypeScript:${YOGA_RESET} Não instalado"
    fi
    
    # Neovim
    if command -v nvim &>/dev/null; then
        echo -e "${YOGA_TERRA}✅ Neovim:${YOGA_RESET} $(nvim --version | head -1)"
    else
        echo -e "${YOGA_FOGO}❌ Neovim:${YOGA_RESET} Não instalado"
    fi
    
    # ASDF
    if command -v asdf &>/dev/null; then
        echo -e "${YOGA_TERRA}✅ ASDF:${YOGA_RESET} $(asdf --version | cut -d' ' -f1-2)"
    else
        echo -e "${YOGA_FOGO}❌ ASDF:${YOGA_RESET} Não instalado"
    fi
    
    # OpenAI
    if [ -n "$OPENAI_API_KEY" ]; then
        echo -e "${YOGA_TERRA}✅ OpenAI:${YOGA_RESET} API key configurada"
    else
        echo -e "${YOGA_SOL}⚠️ OpenAI:${YOGA_RESET} API key não configurada"
    fi
    
    echo ""
    
    # Menu de Opções
    echo -e "${YOGA_AGUA}💧 AÇÕES RÁPIDAS${YOGA_RESET}"
    echo -e "${YOGA_AGUA}━━━━━━━━━━━━━━━${YOGA_RESET}"
    echo "  1. 🚀 Criar novo projeto (yoga-create)"
    echo "  2. 🤖 IA no terminal (yoga-ai)"
    echo "  3. 📦 Gerenciar versões (asdf-menu)"
    echo "  4. 🔗 Git profiles (git-wizard)"
    echo "  5. 🎨 Abrir Neovim"
    echo "  6. 🧘 Entrar em Flow State"
    echo "  7. 🩺 Doctor (yoga-doctor)"
    echo "  8. 🔄 Atualizar Yoga Files (yoga-update)"
    echo "  9. 📖 Ver documentação"
    echo "  0. 🚪 Sair"
    echo ""
    
    echo -en "${YOGA_AR}🌬️ Escolha uma opção: ${YOGA_RESET}"
    read choice
    
    case $choice in
        1)
            yoga_create_project
            ;;
        2)
            yoga_ai_menu
            ;;
        3)
            yoga_asdf_menu
            ;;
        4)
            yoga_git_profiles
            ;;
        5)
            nvim
            ;;
        6)
            yoga_flow_state
            ;;
        7)
            yoga_doctor
            ;;
        8)
            yoga_update
            ;;
        9)
            yoga_docs
            ;;
        0)
            yoga_espirito "🧘 Namastê! Até logo!"
            return 0
            ;;
        *)
            yoga_fogo "❌ Opção inválida!"
            sleep 2
            yoga_dashboard
            ;;
    esac
    
    # Retornar ao menu após ação
    echo ""
    echo -en "${YOGA_AGUA}Pressione ENTER para voltar ao menu...${YOGA_RESET}"
    read
    yoga_dashboard
}

# Criar projeto
yoga_create_project() {
    clear
    yoga_fogo "🔥 CRIAR NOVO PROJETO"
    echo ""
    
    echo "Tipos de projeto disponíveis:"
    echo "  1. React + TypeScript"
    echo "  2. Node.js + TypeScript (API)"
    echo "  3. Next.js + TypeScript"
    echo "  4. Vanilla TypeScript"
    echo "  5. Express + TypeScript"
    echo ""
    
    echo -en "${YOGA_AGUA}Escolha o tipo: ${YOGA_RESET}"
    read project_type
    
    echo -en "${YOGA_AGUA}Nome do projeto: ${YOGA_RESET}"
    read project_name
    
    local template=""
    case $project_type in
        1) template="react" ;;
        2) template="node" ;;
        3) template="next" ;;
        4) template="ts" ;;
        5) template="express" ;;
        *) yoga_fogo "❌ Tipo inválido!" ; return 1 ;;
    esac

    if command -v yoga-create >/dev/null 2>&1; then
        yoga_agua "Criando projeto ($template)..."
        yoga-create "$template" "$project_name"
        yoga_terra "✅ Projeto criado!"
        return 0
    fi

    yoga_fogo "❌ yoga-create not found in PATH (add $YOGA_HOME/bin to PATH)"
}

# IA menu (delegates to yoga-ai)
yoga_ai_menu() {
    clear
    yoga_espirito "🤖 YOGA AI"
    echo ""
    if ! command -v yoga-ai >/dev/null 2>&1; then
        yoga_fogo "❌ yoga-ai not found in PATH (add $YOGA_HOME/bin to PATH)"
        return 1
    fi

    echo "1) Mode (help/fix/cmd/explain/debug/code/learn)"
    echo "2) Freeform question"
    echo ""
    echo -en "${YOGA_AGUA}Choose (1-2): ${YOGA_RESET}"
    read -r kind

    case "$kind" in
        1)
            echo -en "${YOGA_AGUA}Mode: ${YOGA_RESET}"
            read -r mode
            echo -en "${YOGA_AGUA}Query: ${YOGA_RESET}"
            read -r query
            [ -z "$mode" ] && return 0
            yoga-ai "$mode" "$query"
            ;;
        2)
            echo -en "${YOGA_AGUA}Question: ${YOGA_RESET}"
            read -r query
            [ -z "$query" ] && return 0
            yoga-ai "$query"
            ;;
        *)
            return 0
            ;;
    esac
}

# Menu ASDF
yoga_asdf_menu() {
    clear
    yoga_ar "🌬️ ASDF"
    echo ""
    if command -v asdf-menu >/dev/null 2>&1; then
        asdf-menu
        return $?
    fi
    yoga_fogo "❌ asdf-menu not found in PATH (add $YOGA_HOME/bin to PATH)"
    return 1
}

# Git profiles
yoga_git_profiles() {
    clear
    yoga_ar "🔗 GIT PROFILES"
    echo ""
    if command -v git-wizard >/dev/null 2>&1; then
        git-wizard
        return $?
    fi
    yoga_fogo "❌ git-wizard not found in PATH (add $YOGA_HOME/bin to PATH)"
    return 1
}

# Flow State
yoga_flow_state() {
    clear
    yoga_flow
    echo ""
    yoga_breath "Preparando ambiente para máxima produtividade..."
    echo ""
    
    echo -e "${YOGA_ESPIRITO}Dicas para manter o Flow State:${YOGA_RESET}"
    echo "  • Feche todas as distrações"
    echo "  • Use fones com música instrumental"
    echo "  • Mantenha água por perto"
    echo "  • Faça pausas de 5min a cada 25min"
    echo "  • Respire profundamente 3x antes de começar"
    echo ""
    
    yoga_meditation
    echo ""
    yoga_terra "✨ Você está pronto! Boa sessão de código!"
}

# Performance Check
yoga_performance_check() {
    clear
    yoga_fogo "📊 PERFORMANCE CHECK"
    echo ""
    
    yoga_agua "Testando velocidade das ferramentas..."
    echo ""
    
    # Test npm
    if command -v npm &>/dev/null; then
        echo -n "npm version: "
        time npm --version >/dev/null 2>&1
    fi
    
    # Test node
    if command -v node &>/dev/null; then
        echo -n "node version: "
        time node --version >/dev/null 2>&1
    fi
    
    # Test git
    if command -v git &>/dev/null; then
        echo -n "git status: "
        time git status >/dev/null 2>&1
    fi
    
    # Test nvim
    if command -v nvim &>/dev/null; then
        echo -n "nvim startup: "
        time nvim --headless +qall 2>/dev/null
    fi
    
    echo ""
    yoga_terra "✅ Performance check completo!"
}

# Update
yoga_update() {
    clear
    yoga_agua "🔄 ATUALIZANDO YOGA FILES"
    echo ""
    
    if command -v yoga-update >/dev/null 2>&1; then
        yoga-update
        yoga_terra "✅ Atualização completa!"
        return 0
    fi

    cd "$YOGA_HOME"
    yoga_ar "Baixando atualizações..."
    git pull origin main
    yoga_terra "✅ Atualização completa!"
}

yoga_doctor() {
    clear
    if command -v yoga-doctor >/dev/null 2>&1; then
        yoga-doctor
        return $?
    fi
    yoga_fogo "❌ yoga-doctor not found in PATH (add $YOGA_HOME/bin to PATH)"
    return 1
}

# Documentação
yoga_docs() {
    clear
    yoga_espirito "📖 DOCUMENTAÇÃO"
    echo ""
    
    echo "Recursos disponíveis:"
    echo "  1. README principal"
    echo "  2. Guia de instalação"
    echo "  3. Roadmap do projeto"
    echo "  4. Guia de contribuição"
    echo "  5. Changelog"
    echo ""
    
    echo -en "${YOGA_AGUA}Escolha o documento: ${YOGA_RESET}"
    read doc_choice
    
    case $doc_choice in
        1)
            less "$HOME/.yoga/README.md"
            ;;
        2)
            less "$YOGA_HOME/docs/SETUP_GUIDE.md"
            ;;
        3)
            less "$YOGA_HOME/docs/ROADMAP.md"
            ;;
        4)
            less "$YOGA_HOME/CONTRIBUTING.md"
            ;;
        5)
            less "$YOGA_HOME/CHANGELOG.md"
            ;;
    esac
}

# Alias principal
alias yoga='yoga_dashboard'
alias yoga-dash='yoga_dashboard'

# Note: do not auto-run the dashboard on source.
