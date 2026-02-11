#!/bin/zsh
# yoga-files v2.0 - Initialization Script

# Definir YOGA_HOME
export YOGA_HOME="${YOGA_HOME:-$HOME/.yoga}"

# zsh-only setup: no shell preference file.

# Verificar se YOGA está instalado
if [ ! -d "$YOGA_HOME" ]; then
    echo "🔥 YOGA FILES não está instalado!"
    echo "Execute: curl -fsSL https://raw.githubusercontent.com/rodrigocnascimento/yoga-files/main/install.sh | zsh"
    return 1
fi

# Carregar configurações e funções
source "$YOGA_HOME/core/utils.sh"
source "$YOGA_HOME/core/observability/logger.sh" 2>/dev/null || true
source "$YOGA_HOME/core/aliases.sh"
source "$YOGA_HOME/core/functions.sh"
source "$YOGA_HOME/core/dashboard.sh" 2>/dev/null

# Plugins (optional)
if [ -f "$YOGA_HOME/core/plugins/loader.sh" ]; then
    source "$YOGA_HOME/core/plugins/loader.sh"
    yoga_plugins_load || true
fi

# Carregar ferramentas AI se disponível
[ -f "$YOGA_HOME/core/ai/yoga-ai-terminal.sh" ] && source "$YOGA_HOME/core/ai/yoga-ai-terminal.sh"

# Compat: aliases/entrypoints work in zsh and bash (interactive)
alias yoga='yoga_dashboard'
alias yoga-dash='yoga_dashboard'
alias asdf-menu='bash "$YOGA_HOME/core/version-managers/asdf/interactive.sh"'
alias git-wizard='bash "$YOGA_HOME/core/git/git-wizard.sh"'

# Configurar PATH
export PATH="$YOGA_HOME/bin:$PATH"

# ASDF
if [ -f "$HOME/.asdf/asdf.sh" ]; then
    . "$HOME/.asdf/asdf.sh"
fi

# FZF configurações
export FZF_DEFAULT_OPTS='--height 40% --border --pointer=👉 --color=16'

# OpenAI API Key (se configurada)
[ -f "$HOME/.openai_key" ] && export OPENAI_API_KEY="$(cat "$HOME/.openai_key")"

# Load custom configurations
[ -f ~/.custom.aliases ] && source ~/.custom.aliases
[ -f ~/.custom.functions ] && source ~/.custom.functions

# Mensagem de boas-vindas
if [ -z "$YOGA_SILENT" ]; then
    # Mostrar apenas na primeira vez
    if [ -z "$YOGA_WELCOMED" ]; then
        export YOGA_WELCOMED=1
        echo ""
        yoga_espirito "🧘 Yoga Files v2.0 carregado!"
        echo -e "${YOGA_AGUA}Digite 'yoga' para abrir o dashboard${YOGA_RESET}"
        echo ""
    fi
fi

# Auto-update check (desabilitado por padrão para performance)
if [ "$YOGA_AUTO_UPDATE" = "true" ] && [ -d "$YOGA_HOME/.git" ]; then
    # Verificar atualizações em background
    (
        cd "$YOGA_HOME"
        git fetch origin main --quiet 2>/dev/null
        LOCAL=$(git rev-parse @)
        REMOTE=$(git rev-parse @{u})
        
        if [ "$LOCAL" != "$REMOTE" ]; then
            yoga_sol "🔄 Atualização disponível! Execute: yoga-update"
        fi
    ) &
fi

# Ativar ambiente virtual Python se existir
[ -f "$YOGA_HOME/venv/bin/activate" ] && source "$YOGA_HOME/venv/bin/activate"

# Node.js version via ASDF
if command -v asdf &>/dev/null; then
    # Auto-switch baseado em .tool-versions
    if [ "$YOGA_ASDF_AUTO_INSTALL" = "true" ] && [ -f ".tool-versions" ]; then
        asdf install 2>/dev/null || true
    fi
fi
