#!/usr/bin/env zsh
#!/usr/bin/env zsh
# yoga-files v2.0 - Instalador Principal
# ASDF + LazyVim + OpenAI + Git Multi-Perfil + JavaScript/TypeScript Focus

# NOTE: This project is zsh-first. If you run this file using bash (e.g. `curl ... | bash`),
# the zsh-only syntax will fail. This guard prints a clear warning early.
if [ -z "${ZSH_VERSION-}" ]; then
  echo "yoga-files: zsh is required." >&2
  echo "Install zsh and re-run with: curl -fsSL <url>/install.sh | zsh" >&2
  echo "" >&2

  if command -v zsh >/dev/null 2>&1; then
    echo "zsh is installed. Re-run using zsh." >&2
    exit 1
  fi

  case "$(uname -s 2>/dev/null)" in
    Darwin)
      echo "macOS: install with Homebrew: brew install zsh" >&2
      ;;
    Linux)
      echo "Linux: install with your package manager:" >&2
      echo "  Debian/Ubuntu: sudo apt-get install -y zsh" >&2
      echo "  Fedora/RHEL:   sudo dnf install -y zsh" >&2
      echo "  Arch:          sudo pacman -S zsh" >&2
      ;;
    *)
      echo "Install zsh for your OS, then re-run with zsh." >&2
      ;;
  esac

  exit 1
fi

emulate -L zsh
set -euo pipefail

# Detectar diretório de instalação
export YOGA_HOME="${YOGA_HOME:-$HOME/.yoga}"

bootstrap_install() {
  echo "yoga-files: bootstrapping into $YOGA_HOME" >&2

  if ! command -v git >/dev/null 2>&1; then
    echo "yoga-files: missing required command: git" >&2
    exit 1
  fi

  if [ -d "$YOGA_HOME/.git" ]; then
    git -C "$YOGA_HOME" pull --rebase
  else
    mkdir -p "${YOGA_HOME:h}" 2>/dev/null || true
    git clone https://github.com/rodrigocnascimento/yoga-files.git "$YOGA_HOME"
  fi

  exec zsh "$YOGA_HOME/install.sh" "$@"
}

SCRIPT_DIR="${0:A:h}"
if [ ! -f "$SCRIPT_DIR/core/utils.sh" ]; then
  # Likely running via `curl ... | zsh` (no on-disk script path).
  bootstrap_install "$@"
fi

# Importar funções yoga
source "$SCRIPT_DIR/core/utils.sh"
source "$SCRIPT_DIR/core/common.sh"

# ASCII Art do Yoga
show_yoga_banner() {
    clear 2>/dev/null || true
    echo ""
    echo "    🧘 YOGA FILES v2.0 INSTALLER 🧘"
    echo "    ================================"
    echo "    ASDF + LazyVim + OpenAI Integration"
    echo "    JavaScript/TypeScript Focused"
    echo ""
    yoga_espirito "Transforme seu ambiente de desenvolvimento!"
    echo ""
}

# Detectar sistema operacional
detect_os() {
    yoga_agua "💧 Detectando sistema operacional..."
    
    case "$(uname -s)" in
        Linux*)     OS="linux" ;;
        Darwin*)    OS="macos" ;;
        CYGWIN*|MINGW*|MSYS*) OS="windows" ;;
        *)          OS="unknown" ;;
    esac
    
    case "$(uname -m)" in
        x86_64)  ARCH="amd64" ;;
        arm64)   ARCH="arm64" ;;
        aarch64) ARCH="arm64" ;;
        *)       ARCH="unknown" ;;
    esac
    
    export OS ARCH
    yoga_terra "🌿 Sistema: $OS ($ARCH)"
}

# Verificar pré-requisitos
check_prerequisites() {
    yoga_ar "🌬️ Verificando pré-requisitos..."
    
    local missing_deps=()
    
    # Verificar comandos essenciais
    command -v git >/dev/null 2>&1 || missing_deps+=("git")
    command -v curl >/dev/null 2>&1 || missing_deps+=("curl")
    command -v jq >/dev/null 2>&1 || missing_deps+=("jq")
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        yoga_fogo "🔥 Dependências faltando: ${missing_deps[*]}"
        yoga_agua "💧 Instalando dependências..."
        install_dependencies "${missing_deps[@]}"
    else
        yoga_terra "🌿 Todas as dependências encontradas!"
    fi
}

# Instalar dependências do sistema
install_dependencies() {
    local deps=("$@")
    
    case "$OS" in
        macos)
            if ! command -v brew >/dev/null 2>&1; then
                yoga_agua "💧 Instalando Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            for dep in "${deps[@]}"; do
                brew install "$dep"
            done
            ;;
        linux)
            if command -v apt-get >/dev/null 2>&1; then
                sudo apt-get update
                for dep in "${deps[@]}"; do
                    sudo apt-get install -y "$dep"
                done
            elif command -v yum >/dev/null 2>&1; then
                for dep in "${deps[@]}"; do
                    sudo yum install -y "$dep"
                done
            elif command -v pacman >/dev/null 2>&1; then
                for dep in "${deps[@]}"; do
                    sudo pacman -S --noconfirm "$dep"
                done
            fi
            ;;
        windows)
            yoga_fogo "🔥 Windows detectado - use WSL2 para melhor experiência"
            ;;
    esac
}

# Criar estrutura de diretórios
create_directory_structure() {
    yoga_agua "💧 Criando estrutura de diretórios..."
    
    mkdir -p "$YOGA_HOME"/{bin,core,editor/nvim,docs,tests,config}
    mkdir -p "$YOGA_HOME"/core/{ai,version-managers,git}
    mkdir -p "$YOGA_HOME"/core/version-managers/{asdf,lazyvim}
    mkdir -p "$YOGA_HOME"/editor/nvim/{lua/plugins,lua/config}
    
    yoga_terra "🌿 Estrutura criada!"
}

# Copiar arquivos do yoga
copy_yoga_files() {
    yoga_ar "🌬️ Copiando arquivos yoga..."
    
    # Copiar core
    cp -r "$SCRIPT_DIR/core/"* "$YOGA_HOME/core/" 2>/dev/null || true
    
    # Copiar documentação
    cp -r "$SCRIPT_DIR/docs/"* "$YOGA_HOME/docs/" 2>/dev/null || true
    
    # Copiar configurações
    [ -f "$SCRIPT_DIR/config.yaml" ] && cp "$SCRIPT_DIR/config.yaml" "$YOGA_HOME/config/"
    
    # Copiar init.sh
    cp "$SCRIPT_DIR/init.sh" "$YOGA_HOME/"

    # Copiar bin
    if [ -d "$SCRIPT_DIR/bin" ]; then
        cp -r "$SCRIPT_DIR/bin/"* "$YOGA_HOME/bin/" 2>/dev/null || true
        chmod +x "$YOGA_HOME"/bin/* 2>/dev/null || true
    fi

    # Copiar editor config (LazyVim overlays)
    if [ -d "$SCRIPT_DIR/editor" ]; then
        mkdir -p "$YOGA_HOME/editor"
        cp -r "$SCRIPT_DIR/editor/"* "$YOGA_HOME/editor/" 2>/dev/null || true
    fi
    
    yoga_terra "🌿 Arquivos copiados!"
}

# Configurar shell (zsh/bash)
setup_shell_integration() {
    yoga_agua "💧 Configurando integração com shell..."

    local shell_rc="$HOME/.zshrc"
    [ -f "$shell_rc" ] || touch "$shell_rc"
    
    # Adicionar yoga ao PATH e source init.sh
    if ! grep -q "source $YOGA_HOME/init.sh" "$shell_rc" 2>/dev/null; then
        cat >> "$shell_rc" << EOF

# Yoga Files Integration
export YOGA_HOME="$YOGA_HOME"
export PATH="\$YOGA_HOME/bin:\$PATH"
source "\$YOGA_HOME/init.sh"
EOF
        yoga_terra "🌿 Shell configurado!"
    else
        yoga_agua "💧 Shell já configurado"
    fi
}

install_node_stack() {
    yoga_fogo "🔥 Installing Node.js (ASDF)"

    if [ ! -f "$YOGA_HOME/core/node/install.sh" ]; then
        yoga_fogo "❌ Missing: $YOGA_HOME/core/node/install.sh"
        return 1
    fi

    zsh "$YOGA_HOME/core/node/install.sh"
}

# Instalar ASDF
install_asdf() {
    yoga_fogo "🔥 Instalando ASDF version manager..."
    
    if command -v asdf >/dev/null 2>&1; then
        yoga_agua "💧 ASDF já instalado"
        return 0
    fi
    
    # Clonar ASDF
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
    
    # Adicionar ao shell
    local shell_rc="$HOME/.zshrc"
    
    cat >> "$shell_rc" << 'EOF'

# ASDF Version Manager
. "$HOME/.asdf/asdf.sh"
EOF
    
    # Carregar ASDF imediatamente
    . "$HOME/.asdf/asdf.sh"
    
    yoga_terra "🌿 ASDF instalado!"
}

# Instalar plugins ASDF
install_asdf_plugins() {
    yoga_ar "🌬️ Instalando plugins ASDF..."

    # Plugin Python
    asdf plugin-add python https://github.com/danhper/asdf-python.git 2>/dev/null || true
    
    # Plugin PHP (opcional)
    asdf plugin-add php https://github.com/asdf-community/asdf-php.git 2>/dev/null || true
    
    yoga_terra "🌿 Plugins ASDF instalados!"
}

# Instalar versões padrão
install_default_versions() {
    yoga_agua "💧 Instalando versões padrão..."

    # Python 3
    asdf install python latest:3.11
    asdf global python latest:3.11
    
    yoga_terra "🌿 Versões padrão instaladas!"
}

# Instalar Neovim
install_neovim() {
    yoga_fogo "🔥 Instalando Neovim..."
    
    if command -v nvim >/dev/null 2>&1; then
        yoga_agua "💧 Neovim já instalado"
        return 0
    fi
    
    case "$OS" in
        macos)
            brew install neovim
            ;;
        linux)
            if command -v apt-get >/dev/null 2>&1; then
                sudo apt-get install -y neovim
            elif command -v pacman >/dev/null 2>&1; then
                sudo pacman -S --noconfirm neovim
            else
                # Instalar do source
                yoga_agua "💧 Instalando Neovim do source..."
                curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
                sudo tar -C /opt -xzf nvim-linux64.tar.gz
                sudo ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
                rm nvim-linux64.tar.gz
            fi
            ;;
    esac
    
    yoga_terra "🌿 Neovim instalado!"
}

# Configurar LazyVim
setup_lazyvim() {
    yoga_ar "🌬️ Configurando LazyVim..."
    
    # Backup configuração existente
    if [ -d "$HOME/.config/nvim" ]; then
        yoga_agua "💧 Fazendo backup da configuração existente..."
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d)"
    fi
    
    # Clonar LazyVim starter
    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
    
    # Remover .git do starter
    rm -rf "$HOME/.config/nvim/.git"
    
    # Copiar configurações personalizadas
    if [ -d "$YOGA_HOME/editor/nvim" ]; then
        cp -r "$YOGA_HOME/editor/nvim/"* "$HOME/.config/nvim/" 2>/dev/null || true
    fi
    
    yoga_terra "🌿 LazyVim configurado!"
}

# Instalar ferramentas JavaScript/TypeScript
install_javascript_tools() {
    # Installed as part of the ASDF Node setup (core/node/install.sh).
    yoga_agua "💧 JS/TS tools are handled by core/node/install.sh"
}

# Configurar Git multi-perfil
setup_git_profiles() {
    yoga_agua "💧 Configurando sistema de perfis Git..."

    local profiles_file="$YOGA_HOME/config/git-profiles.yaml"
    mkdir -p "${profiles_file:h}"

    if [ ! -f "$profiles_file" ]; then
        cat > "$profiles_file" << 'EOF'
# Git Profiles Configuration
# Managed by yoga-files git wizard
profiles:
  personal:
    name: ""
    email: ""
    signingkey: ""
    default: true
  work:
    name: ""
    email: ""
    signingkey: ""
    default: false
EOF
    fi

    yoga_terra "🌿 Git profiles ready: $profiles_file"
}

# Configurar OpenAI
setup_openai() {
    yoga_ar "🌬️ Configurando integração OpenAI..."
    
    # Verificar se existe API key
    if [ -z "$OPENAI_API_KEY" ]; then
        yoga_agua "💧 Para usar recursos de IA, configure sua OPENAI_API_KEY:"
        echo "   export OPENAI_API_KEY='sua-chave-aqui'"
        echo "   Adicione ao seu ~/.zshrc ou ~/.bashrc"
    else
        yoga_terra "🌿 OpenAI API key detectada!"
    fi
}

# Função principal
main() {
    show_yoga_banner
    
    yoga_warn "🧘 INICIANDO INSTALAÇÃO DO YOGA FILES v2.0"
    echo ""
    
    # 1. Detectar sistema
    detect_os
    
    # 2. Verificar pré-requisitos
    check_prerequisites
    
    # 3. Criar estrutura
    create_directory_structure
    
    # 4. Copiar arquivos
    copy_yoga_files
    
    # 5. Configurar shell
    setup_shell_integration
    
    # 6. Instalar ASDF
    install_asdf
    install_asdf_plugins
    install_default_versions

    # 6b. Node.js via ASDF module
    install_node_stack
    
    # 7. Instalar Neovim
    install_neovim
    setup_lazyvim
    
    # 8. Instalar ferramentas JS/TS
    install_javascript_tools
    
    # 9. Configurar Git
    setup_git_profiles
    
    # 10. Configurar OpenAI
    setup_openai
    
    echo ""
    yoga_success "⭐⭐⭐ YOGA FILES v2.0 INSTALADO! ⭐⭐⭐"
    echo ""
    yoga_espirito "🧘 Para começar a usar:"
    echo "   1. Recarregue seu shell: source ~/.zshrc"
    echo "   2. Execute: yoga"
    echo "   3. Ou teste: yoga-ai 'olá mundo'"
    echo ""
    yoga_fogo "🔥 Namastê! Seu ambiente está pronto!"
}

# Executar instalação
main "$@"
