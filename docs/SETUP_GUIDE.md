# 🧘 Guia Completo de Instalação

> **Transforme seu ambiente de desenvolvimento em um ecossistema YOGA moderno e inteligente**

---

## 🎯 **Visão Geral do Setup**

Este guia levará você através da instalação completa do yoga-files v2.0, incluindo:

- 🛠️ **ASDF** - Version manager universal
- 🎨 **LazyVim** - Editor moderno com plugins JavaScript/TypeScript
- 🤖 **OpenAI Integration** - Ferramentas de IA assistente
- 🔗 **Git Multi-Perfil** - Sistema inteligente de perfis
- 🌈 **Tema Yoga** - Interface visual com cores vibrantes

---

## 📋 **Pré-requisitos**

### Sistema Operacional
- **Linux**: Ubuntu 20.04+, Debian 11+, Fedora 35+
- **macOS**: Monterey 12.0+ (Intel/Apple Silicon)
- **Windows**: WSL2 com Ubuntu 20.04+ ou nativo

### Software Requerido
```bash
# Verificar se já tem
command -v git || echo "❌ Git é obrigatório"
command -v curl || echo "❌ Curl é obrigatório"
command -v jq || echo "❌ jq é recomendado (para IA)"
```

### Hardware Recomendado
- **RAM**: Mínimo 8GB (16GB recomendado)
- **Armazenamento**: 20GB livres para ASDF + projetos
- **Processador**: Multi-core para melhor performance

---

## 🚀 **Passo 1: Download e Instalação**

### Clone do Repositório
```bash
# Clone Git (recomendado)
git clone https://github.com/rodrigocnascimento/yoga-files.git ~/.yoga
cd ~/.yoga

# Tornar executável
chmod +x install.sh
```

### Instalação Principal
```bash
# Executar instalador interativo
./install.sh
```

O instalador irá:
1. 🔍 **Detectar sistema** e dependências
2. 🛠️ **Instalar ASDF** como version manager
3. 🎨 **Configurar LazyVim** com plugins específicos
4. 🤖 **Integrar OpenAI** e ferramentas de IA
5. 🔗 **Configurar Git profiles** com wizard interativo
6. 🌈 **Aplicar tema yoga** em todo o ambiente

---

## 🛠️ **Passo 2: Configuração ASDF**

### O que é ASDF?
ASDF é um version manager universal que permite instalar múltiplas linguagens e ferramentas com um único comando.

### Instalação do ASDF
```bash
# O instalador cuida disso automaticamente
asdf --version  # Deve mostrar versão recent
```

### Plugins Essenciais
O instalador irá configurar automaticamente:

- **nodejs** - Runtime JavaScript
- **npm** - Package manager padrão do Node.js
- **typescript** - Type checking
- **python** - Python e gerenciamento
- **php** - Para backend PHP

### Comandos ASDF Básicos
```bash
# Listar versões disponíveis
asdf list-all nodejs

# Instalar versão específica
asdf install nodejs 20.11.0

# Setar versão global
asdf global nodejs 20.11.0

# Listar versões instaladas
asdf list nodejs

# Verificar versão atual
asdf current nodejs
```

---

## 🎨 **Passo 3: Configuração LazyVim**

### Backup de Configurações Existentes
```bash
# O instalador fará backup automaticamente
cp ~/.vimrc ~/.vimrc.backup.$(date +%Y%m%d)
cp -r ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d) 2>/dev/null || true
```

### Instalação do LazyVim
```bash
# Verificar se Neovim está instalado
nvim --version

# Instalar LazyVim starter (se você quiser fazer manualmente)
git clone https://github.com/LazyVim/starter ~/.config/nvim
```

### Configuração de Plugins JavaScript/TypeScript

O instalador configurará automaticamente:

#### 1. LSP (Language Server Protocol)
- **tsserver** - Para JavaScript/TypeScript
- **biome** - Linting e formatting moderno
- **html** - Para desenvolvimento web
- **css** - Para estilização

#### 2. Completion Inteligente
- **nvim-cmp** - Engine de completion moderno
- **cmp-path** - Completion para arquivos
- **cmp-buffer** - Completion para buffers abertos

#### 3. Navegação e Busca
- **telescope** - Fuzzy finder ultra-rápido
- **telescope-fzf-native** - Integração com fzf
- **neo-tree** - File explorer visual

#### 4. Tema Yoga
- **kanagawa.nvim** - Tema base customizado
- **cores-yoga.lua** - Esquema de cores personalizadas
- **icons-font** - Nerd Fonts para ícones

### Configuração Pós-Instalação
```bash
# Testar configuração
nvim --headless "+checkhealth" +qall

# Abrir LazyVim primeira vez
nvim
```

---

## 🤖 **Passo 4: Integração OpenAI**

### Configuração de API Key
```bash
# Configurar API key (necessário apenas uma vez)
export OPENAI_API_KEY="sua-chave-aqui"

# Ou usar arquivo seguro
echo "export OPENAI_API_KEY='sua-chave-aqui'" >> ~/.zshrc
```

### Ferramentas OpenAI Incluídas

#### 1. CLI Personalizado (yoga-ai)
- **Chat direto** com GPT-4
- **Geração de código** assistida
- **Review de código** especializado
- **Explicação** contextualizada

#### 2. GitHub Copilot
- **Integração** no Neovim via plugin
- **Chat** direto no terminal
- **Sugestões** inline de código

#### 3. Plugins Neovim
- **openai.nvim** - Plugin para OpenAI no editor
- **minuet-ai.nvim** - Multi-provider AI completion
- **augment.vim** - Augmented development

### Configuração dos Tools
```bash
# Instalar CLI tools (opcional)
npm install -g @biomejs/biome
npm install -g typescript tsx
```

Para comandos de IA no terminal (se carregado pelo `init.sh`):

```bash
yai help "como listar arquivos modificados no git"
yai fix "git comit -m 'msg'"
```

---

## 🔗 **Passo 5: Configuração Git Profiles**

### Criando Perfis Git
```bash
# Abrir wizard de configuração (interativo)
bash core/git/git-wizard.sh

# Ou adicionar um perfil direto
bash core/git/git-wizard.sh add
```

### Alternando Entre Perfis
```bash
# Listar perfis disponíveis
bash core/git/git-wizard.sh list

# Mudar perfil
bash core/git/git-wizard.sh switch

# Ver perfil atual
bash core/git/git-wizard.sh current
```

---

## ✅ **Passo 6: Validação e Testes**

### Testar Ambiente
```bash
# Abrir dashboard
yoga

# Checagens rapidas
asdf --version
nvim --version
bash core/git/git-wizard.sh current
```

### Testar Desenvolvimento JavaScript/TypeScript
```bash
# Testar ferramentas
npm --version
biome --version
nvim --headless "+checkhealth" +qall
```

---

## 🔧 **Personalização do Ambiente**

### Configuração Personalizada
Edite `~/.yoga/config.yaml` para personalizar:

```yaml
# ~/.yoga/config.yaml
user:
  name: "Seu Nome Completo"
  email: "seu.email@pessoal.com"
  github: "seu-username"
  
preferences:
  theme: "yoga_elements"  # yoga_elements | dark | light | auto
  ai_provider: "openai"  # openai | copilot | claude | gemini
  auto_save: true
  
tools:
  javascript:
    package_manager: "npm"  # npm | yarn | pnpm
    linter: "biome"        # biome | eslint
    formatter: "biome"     # biome | prettier
    test_runner: "vitest"   # vitest | jest
    
  editor:
    font_size: 14
    line_numbers: true
    relative_line_numbers: true
    
  ai:
    model: "gpt-4"
    max_tokens: 4000
    temperature: 0.7
    context_window: 10
```

### Customização do Tema
```bash
# Modificar cores yoga
echo 'export YOGA_FOGO="\033[0;38;2m"' >> ~/.zshrc  # Roxo personalizado
echo 'export YOGA_AGUA="\033[0;36;1m"' >> ~/.zshrc   # Ciano personalizado
# etc...
```

---

## 📚 **Próximos Passos**

### 1. Sincronização de Configurações
```bash
# Backup e sincronizar
yoga-backup
yoga-sync
```

### 2. Aprendizado da Ferramentas
- Estudar comandos: `yoga --help`
- Explorar plugins LazyVim: `:Telescope`
- Dominar ASDF: Leia `docs/ASDF_GUIDE.md`
- Aprender OpenAI: Leia `docs/AI_INTEGRATION.md`

### 3. Comunidade
- Junte-se ao Discord: https://discord.gg/yoga-files
- Participe de discussões: GitHub Issues
- Contribua com código: Pull Requests bem-vindas

---

## 🎉 **Parabéns!**

Ao completar este guia, você terá:

- ✅ **Ambiente completo** com ASDF + LazyVim + OpenAI
- 🧘 **Filosofia Yoga** aplicada ao desenvolvimento
- ⚡ **Performance otimizada** para JavaScript/TypeScript
- 🤖 **IA assistente** integrada em todo o workflow
- 🔗 **Git inteligente** com múltiplos perfis
- 📈 **Crescimento profissional** sustentável

---

## 🔥 **Ready to Start!**

```bash
# Carregar ambiente
source ~/.yoga/init.sh

# Abrir dashboard
yoga

# Criar primeiro projeto
yoga-create react meu-primeiro-projeto-yoga

# Fazer commit com assistência IA
git-add-auto && git-commit-ai

# Namastê! 🧘
```

---

## 📞 **Suporte**

### Problemas Comuns
- **ASDF não funciona**: Verifique se está no PATH
- **Neovim não inicia**: Verifique instalação do LuaJIT
- **OpenAI API key inválida**: Verifique a chave configurada
- **Plugins não carregam**: Execute `:Lazy sync`

### Como Obter Ajuda
- **Discord**: https://discord.gg/yoga-files
- **GitHub Issues**: https://github.com/rodrigocnascimento/yoga-files/issues
- **Documentation**: https://yoga-files.dev/docs

---

**Agora você está pronto para transformar seu desenvolvimento com a essência YOGA + inteligência artificial! 🧘✨**
