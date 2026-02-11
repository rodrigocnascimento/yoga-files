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
    echo "  1. 🚀 Criar novo projeto JavaScript/TypeScript"
    echo "  2. 🤖 Chat com OpenAI"
    echo "  3. 📦 Gerenciar versões (ASDF)"
    echo "  4. 🔗 Configurar perfis Git"
    echo "  5. 🎨 Abrir Neovim"
    echo "  6. 🧘 Entrar em Flow State"
    echo "  7. 📊 Performance Check"
    echo "  8. 🔄 Atualizar Yoga Files"
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
            yoga_ai_chat
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
            yoga_performance_check
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
    
    case $project_type in
        1)
            yoga_agua "Criando projeto React + TypeScript..."
            npm create vite@latest "$project_name" -- --template react-ts
            cd "$project_name"
            npm install
            yoga_terra "✅ Projeto React criado!"
            ;;
        2)
            yoga_agua "Criando projeto Node.js + TypeScript..."
            mkdir "$project_name" && cd "$project_name"
            npm init -y
            npm install -D typescript @types/node tsx nodemon
            npx tsc --init
            yoga_terra "✅ Projeto Node.js criado!"
            ;;
        3)
            yoga_agua "Criando projeto Next.js + TypeScript..."
            npx create-next-app@latest "$project_name" --typescript --tailwind --app
            cd "$project_name"
            yoga_terra "✅ Projeto Next.js criado!"
            ;;
        4)
            yoga_agua "Criando projeto Vanilla TypeScript..."
            mkdir "$project_name" && cd "$project_name"
            npm init -y
            npm install -D typescript
            npx tsc --init
            yoga_terra "✅ Projeto TypeScript criado!"
            ;;
        5)
            yoga_agua "Criando projeto Express + TypeScript..."
            mkdir "$project_name" && cd "$project_name"
            npm init -y
            npm install express
            npm install -D typescript @types/node @types/express tsx nodemon
            npx tsc --init
            yoga_terra "✅ Projeto Express criado!"
            ;;
        *)
            yoga_fogo "❌ Tipo inválido!"
            ;;
    esac
}

# Chat com AI
yoga_ai_chat() {
    clear
    yoga_espirito "🤖 CHAT COM OPENAI"
    echo ""
    
    if [ -z "$OPENAI_API_KEY" ]; then
        yoga_fogo "❌ OPENAI_API_KEY não configurada!"
        echo "Configure em ~/.zshrc: export OPENAI_API_KEY='sua-chave'"
        return 1
    fi
    
    echo -e "${YOGA_AGUA}Digite sua pergunta (ou 'sair' para voltar):${YOGA_RESET}"
    echo -en "${YOGA_AR}> ${YOGA_RESET}"
    read query
    
    if [ "$query" = "sair" ]; then
        return 0
    fi
    
    yoga_breath "Consultando IA..."
    
    # Fazer chamada para OpenAI
    response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "{
            \"model\": \"gpt-4\",
            \"messages\": [{\"role\": \"user\", \"content\": \"$query\"}],
            \"temperature\": 0.7,
            \"max_tokens\": 1000
        }" \
        https://api.openai.com/v1/chat/completions | jq -r '.choices[0].message.content')
    
    echo ""
    echo -e "${YOGA_ESPIRITO}🤖 Resposta:${YOGA_RESET}"
    echo -e "${YOGA_TERRA}$response${YOGA_RESET}"
    echo ""
    
    echo -en "${YOGA_AGUA}Fazer outra pergunta? (s/n): ${YOGA_RESET}"
    read continue
    
    if [ "$continue" = "s" ]; then
        yoga_ai_chat
    fi
}

# Menu ASDF
yoga_asdf_menu() {
    clear
    yoga_ar "🌬️ GERENCIADOR DE VERSÕES ASDF"
    echo ""
    
    echo "Opções:"
    echo "  1. Listar plugins instalados"
    echo "  2. Instalar novo plugin"
    echo "  3. Listar versões de Node.js"
    echo "  4. Instalar versão de Node.js"
    echo "  5. Definir versão global"
    echo "  6. Voltar"
    echo ""
    
    echo -en "${YOGA_AGUA}Escolha: ${YOGA_RESET}"
    read asdf_choice
    
    case $asdf_choice in
        1)
            asdf plugin list
            ;;
        2)
            echo -en "${YOGA_AGUA}Nome do plugin: ${YOGA_RESET}"
            read plugin_name
            asdf plugin add "$plugin_name"
            ;;
        3)
            asdf list nodejs
            ;;
        4)
            echo -en "${YOGA_AGUA}Versão do Node.js: ${YOGA_RESET}"
            read node_version
            asdf install nodejs "$node_version"
            ;;
        5)
            echo -en "${YOGA_AGUA}Plugin: ${YOGA_RESET}"
            read plugin
            echo -en "${YOGA_AGUA}Versão: ${YOGA_RESET}"
            read version
            asdf global "$plugin" "$version"
            ;;
        6)
            return 0
            ;;
    esac
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
    
    cd "$YOGA_HOME"
    
    yoga_ar "Baixando atualizações..."
    git pull origin main
    
    yoga_ar "Atualizando dependências..."
    npm update -g
    
    yoga_ar "Atualizando plugins ASDF..."
    asdf plugin update --all
    
    yoga_terra "✅ Atualização completa!"
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

# Executar dashboard se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    yoga_dashboard
fi
