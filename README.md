# yoga-files

![🧘 Yoga Development Environment](https://raw.githubusercontent.com/yoga-files/brand/main/yoga-logo-banner.png)

> **Seu ambiente de desenvolvimento com essência YOGA + inteligência artificial**  
> *ASDF + LazyVim + OpenAI + GitHub Copilot + JavaScript/TypeScript Focus*

---

## 📋 **Visão Geral**

**yoga-files** é uma configuração de ambiente de desenvolvimento moderno e inteligente que combina:

- 🧘 **Filosofia Yoga**: Cores vibrantes (FOGO 🔥, ÁGUA 💧, TERRA 🌿, AR 🌬️, ESPÍRITO 🧘) e feedback visual expressivo
- 🛠️ **ASDF**: Version manager universal para Node.js, TypeScript, Python, PHP e mais
- 🎨 **LazyVim**: Editor Neovim moderno com performance superior e plugins específicos
- 🤖 **OpenAI Integration**: Ferramentas de IA assistente para desenvolvimento acelerado
- 🔗 **Git Multi-Perfil**: Sistema de perfis Git interativo e fácil de usar
- ⚡ **JavaScript/TypeScript Focus**: Stack completo com ferramentas modernas

---

## 🎯 **Principais Características**

### 🌈 **Interface Visual Yoga**
- **Cores vibrantes**: Sistema de cores baseado nos elementos yoga
- **Feedback expressivo**: Mensagens com ícones e emojis temáticos
- **Status visual**: Indicadores claros para cada estado/operação
- **Terminal animado**: Transições suaves e feedback visual constante

### 🛠️ **Gestão de Versões (ASDF)**
- **Gerenciamento universal**: Uma ferramenta para todas as linguagens
- **Mudança instantânea**: Troca rápida entre versões por projeto
- **Interface interativa**: Menu colorido para seleção e instalação
- **Auto-deteção**: Versões automáticas baseadas no projeto

### 🎨 **Editor Moderno (LazyVim)**
- **Performance superior**: Lazy-loading e startup em 0.5s
- **LSP avançado**: IntelliSense completo para JavaScript/TypeScript
- **Plugins modernos**: Telescope, Treesitter, Git integrations
- **Tema yoga**: Cores personalizadas que seguem a filosofia
- **Configuração flexível**: Customização via arquivos Lua

### 🤖 **Integração OpenAI**
- **Chat direto**: Interface conversacional com GPT-4
- **Geração de código**: Criação assistida de componentes e funções
- **Review automático**: Análise de código com IA especialista
- **Explicação inteligente**: Documentação e tutoriais contextualizados
- **Multi-provider**: OpenAI, Claude, Gemini, Copilot, etc.

### 🔗 **Git Inteligente**
- **Múltiplos perfis**: Crie e alterne entre perfis Git facilmente
- **Setup interativo**: Wizard guiado para configuração inicial
- **Integração automática**: Perfil por projeto ou repositório
- **Gestão visual**: Dashboard para gerenciar identidades

---

## 🚀 **Instalação Rápida**

### Pré-requisitos
- **Shell**: Zsh (ou Bash com adaptações)
- **Git**: Versão 2.19+ 
- **Neovim**: v0.11.2+ (com LuaJIT)
- **Curl**: Para downloads e APIs

### Instalação com um comando
```bash
# Requer zsh
curl -fsSL https://raw.githubusercontent.com/rodrigocnascimento/yoga-files/main/install.sh | zsh
```

O instalador irá:
1. ✨ Detectar seu sistema operacional
2. 🛠️ Instalar ASDF e configurar linguagens
3. 🎨 Configurar LazyVim com plugins JavaScript/TypeScript
4. 🤖 Integrar ferramentas OpenAI e Copilot
5. 🔗 Configurar sistema de perfis Git
6. 🧘 Aplicar tema yoga em todo o ambiente

---

## 📚 **Documentação**

- **[📖 Guia Completo](docs/SETUP_GUIDE.md)**: Instalação passo a passo detalhada
- **[🧭 Guia de Uso](docs/USAGE_GUIDE.md)**: Do zero ao uso de cada ferramenta
- **[🎨 Configuração LazyVim](docs/LAZYVIM_SETUP.md)**: Personalização completa do editor
- **[🛠️ ASDF Guide](docs/ASDF_GUIDE.md)**: Gerenciamento de versões
- **[🤖 AI Integration](docs/AI_INTEGRATION.md)**: Configuração de ferramentas IA
- **[🔗 Git Profiles](docs/GIT_PROFILES.md)**: Sistema de perfis Git
- **[🎮 JavaScript Stack](docs/JAVASCRIPT_STACK.md)**: Ferramentas e boas práticas
- **[🛠️ Troubleshooting](docs/TROUBLESHOOTING.md)**: Problemas comuns e soluções

---

## 🎯 **Stack JavaScript/TypeScript**

### Ferramentas Inclusíveis
| Categoria | Ferramenta | Versão | Integração |
|-----------|-----------|---------|------------|
| **Runtime** | ASDF Node.js | Gerenciado por ASDF |
| **Package Manager** | npm | Padrão do Node.js |
| **Linter/Formatter** | Biome | Substituto ESLint+Prettier |
| **Type Checking** | TypeScript | LSP integrado no Neovim |
| **Testing** | Vitest | Test runner moderno |
| **Bundling** | Vite | Dev server ultra-rápido |
| **Build Tools** | SWC/esbuild | Compilação performática |

### Templates de Projeto
```bash
# React + TypeScript
create_js_project react meu-app

# Node.js + TypeScript  
create_js_project node minha-api

# Next.js + TypeScript
create_js_project next meu-frontend
```

---

## 🎨 **Configuração do Ambiente**

### Variáveis de Ambiente
```bash
# Variáveis principais
export YOGA_HOME="$HOME/.yoga"
export YOGA_CONFIG="$YOGA_HOME/config.yaml"
export ASDF_DATA_DIR="$HOME/.asdf"
export ASDF_DEFAULT_TOOL_VERSIONS_SOURCE_PRIORITY=asdf
```

### Configuração Personalizada
```yaml
# ~/.yoga/config.yaml
user:
  name: "Seu Nome"
  email: "seu.email@exemplo.com"
  github: "seu-username"

preferences:
  theme: "yoga_elements"
  ai_provider: "openai"  # openai | copilot | claude | gemini
  auto_save: true
  git_signing: true

tools:
  javascript:
    package_manager: "npm"
    linter: "biome"
    formatter: "biome"
    test_runner: "vitest"
  
  editor:
    name: "lazyvim"
    fonts: "JetBrains Mono Nerd Font"
    
  ai:
    model: "gpt-4"
    max_tokens: 2000
    temperature: 0.7
```

---

## 🎮 **Comandos Principais**

### Comandos Yoga
```bash
# Menu principal
yoga                    # Dashboard interativo
yoga-menu              # Menu de configurações
yoga-status            # Status completo do ambiente

# Respiration e Flow
yoga-breath           # Respiração consciente
yoga-flow             # Entrar em flow state
yoga-pose "Namastê"    # Pose aleatória com tema yoga

# Git Inteligente
git-profile            # Gerenciar perfis Git
git-switch             # Alternar perfil rápido
git-commit             # Commit assistido por IA
```

### Comandos de Desenvolvimento
```bash
# ASDF e Version Management
asdf-menu             # Interface ASDF interativa
node-version            # Gerenciar versões Node.js
npm-version             # Gerenciar versões npm
typescript-version       # Gerenciar versões TypeScript

# JavaScript/TypeScript
js-dev                 # Iniciar desenvolvimento (npm run dev)
js-build               # Buildar projeto (npm run build)
js-test                # Executar testes (npm run test)
js-fix                 # Formatar código com Biome
js-create              # Criar novo projeto

# LazyVim
nvim                   # Abrir Neovim
nvim-reload            # Recarregar configuração
nvim-config            # Abrir pasta de config
```

### Comandos IA
```bash
# OpenAI Integration
ai-chat                # Conversar com GPT-4
ai-code                # Gerar código com IA
ai-review              # Revisar código com IA
ai-explain             # Explicar código com IA
ai-fix                 # Corrigir bugs com IA assistência
ai-help                # Ajuda para escrever comandos

# GitHub Copilot
copilot                # Toggle Copilot no editor
copilot-chat            # Chat com Copilot
copilot-explain         # Explicar código com Copilot
```

### 🤖 **yoga-ai: Assistente Direto no Terminal**

Fale diretamente com a IA para ajudar com comandos, correções e desenvolvimento:

```bash
# Pedir ajuda para escrever um comando
yoga-ai help "como fazer grep recursivo em arquivos .js?"
# Resposta: grep -r --include="*.js" "pattern" .

# Corrigir comando errado
yoga-ai fix "git comit -m 'minha mensagem'"
# Resposta: git commit -m 'minha mensagem'

# Gerar comando complexo
yoga-ai cmd "listar todos os arquivos modificados hoje ordenados por tamanho"
# Resposta: find . -type f -mtime -1 -exec ls -la {} \; | sort -k5 -n

# Explicar comando
yoga-ai explain "tar -czf backup.tar.gz --exclude=node_modules ."
# Resposta: Cria arquivo compactado gzip excluindo node_modules

# Chat livre sobre desenvolvimento
yoga-ai "qual a melhor forma de estruturar um projeto React com TypeScript?"
# Resposta detalhada com exemplos e boas práticas

# Gerar código direto
yoga-ai code "função TypeScript para validar CPF brasileiro"
# Resposta: código completo com tipagem e testes

# Debug de erro
yoga-ai debug "TypeError: Cannot read property 'map' of undefined"
# Resposta: análise do erro e soluções possíveis

# Otimizar código
yoga-ai optimize "for (let i = 0; i < arr.length; i++) { console.log(arr[i]) }"
# Resposta: arr.forEach(item => console.log(item)) ou for...of
```

### 🎯 **Exemplos Práticos de Uso Diário**

```bash
# Manhã - Começar o dia
yoga-ai "resumo das melhores práticas TypeScript 2025"
yoga-ai "criar script para automatizar build e deploy"

# Durante desenvolvimento
yoga-ai fix "meu useState não está atualizando o componente"
yoga-ai code "custom hook para fetch com cache e retry"
yoga-ai explain "como funciona o reconciliation no React 18"

# Debugging
yoga-ai debug "memory leak no useEffect"
yoga-ai "porque meu bundle está com 5MB?"

# Aprendizado
yoga-ai learn "Server Components no Next.js 14"
yoga-ai "diferenças entre Vitest e Jest"

# Fim do dia
yoga-ai "gerar relatório das alterações de hoje"
yoga-ai "criar TODO list para amanhã baseado nos commits"
```

---

## 🏗️ **Estrutura de Arquivos**

```
yoga-files/
├── 📄 README.md                    # Este arquivo
├── 🚀 install.sh                  # Instalador principal
├── 🔄 init.sh                     # Bootloader do ambiente
├── 📋 config.yaml                  # Configurações centrais
├── core/                          # Módulos principais
│   ├── utils.sh                  # Funções yoga_* ❤️
│   ├── aliases.sh                # Aliases principais
│   ├── functions.sh              # Funções principais
│   ├── env.sh                    # Detecção de ambiente
│   ├── version-managers/         # Gerenciadores de versão
│   │   ├── asdf/              # ASDF scripts
│   │   │   ├── install.sh    # Instalador ASDF
│   │   │   ├── plugins.sh    # Plugins ASDF
│   │   │   ├── interactive.sh # Menu interativo
│   │   │   └── versions.sh   # Gerência de versões
│   │   └── lazyvim/           # Configuração LazyVim
│   │       ├── install.sh     # Instalador LazyVim
│   │       ├── init.lua        # Configuração principal
│   │       └── plugins/        # Plugins específicos
│   │           ├── core.lua      # Configurações base
│   │           ├── lsp.lua       # LSP e completion
│   │           ├── ai.lua        # Plugins OpenAI/Copilot
│   │           └── yoga-theme.lua # Tema yoga
│   └── ai/                      # Integração OpenAI
│       ├── openai-cli.sh        # CLI OpenAI personalizado
│       ├── openai-nvim.lua      # Plugin OpenAI Neovim
│       └── copilot.lua          # Plugin Copilot
│   └── git/                     # Sistema Git
│       ├── git-wizard.sh        # Wizard de perfis
│       ├── profiles/            # Perfis Git
│       └── gitconfig-basic      # Config base
├── editor/                         # Configurações de editor
│   └── nvim/                  # Neovim/LazyVim
│       ├── init.lua            # Configuração principal
│       ├── lazy-lock.json     # Lockfile de plugins
│       └── lua/               # Arquivos Lua
│           ├── plugins/           # Configurações de plugins
│           └── config/          # Configurações personalizadas
├── docs/                           # Documentação
│   ├── SETUP_GUIDE.md      # Guia de instalação
│   ├── LAZYVIM_SETUP.md   # Configuração LazyVim
│   ├── ASDF_GUIDE.md        # Guia ASDF
│   ├── AI_INTEGRATION.md     # Integração OpenAI
│   └── TROUBLESHOOTING.md # Problemas comuns
└── tests/                           # Testes do ambiente
    ├── install.test.sh       # Testes de instalação
    └── ai.test.sh          # Testes de IA
```

---

## 🎯 **Roadmap Futuro**

### Versão 2.1 (Q1 2026)
- [ ] **Performance Suite**: Ferramentas de análise e otimização
- [ ] **Collaboration Hub**: Integração real-time entre desenvolvedores
- [ ] **AI Team Agent**: Assistente especializado para sua stack
- [ ] **Cloud Deploy**: Deploy automatizado para Vercel, AWS, etc
- [ ] **Mobile Dev**: React Native e desenvolvimento mobile

### Versão 2.2 (Q2 2026)
- [ ] **Code Templates**: Templates avançados por framework
- [ ] **Security Tools**: Varredura de segurança automatizada
- [ ] **Database Tools**: Gerenciamento visual de bancos de dados
- [ ] **Documentation Generator**: README e docs automáticas

---

## ❤️ **Contribuição**

### Como Contribuir
1. **Fork** o repositório
2. **Crie** uma branch para sua feature: `git checkout -b feature/sua-contribuição`
3. **Faça** suas alterações
4. **Teste** suas mudanças: `./tests/run-all.sh`
5. **Envie** um pull request com descrição clara

### Guias de Contribuição
- **Código**: Siga os padrões estabelecidos (TypeScript, Biome, etc)
- **Commits**: Mensagens claras com contexto yoga (🔥 feature:, 🌿 fix:, etc)
- **Documentação**: Atualize a documentação relevante
- **Testes**: Cubra seus novos recursos com testes

---

## 🤝 **Créditos e Agradecimentos**

### Desenvolvimento Principal
- **[@rodrigocnascimento](https://github.com/rodrigocnascimento)** - Criador e mantenedor principal

### Ferramentas Inspiradoras
- **ASDF** - Version manager universal
- **LazyVim** - Framework de configuração Neovim
- **Biome** - Linter e formatter moderno
- **OpenAI** - Plataforma de IA para desenvolvedores
- **GitHub Copilot** - Assistente de código Microsoft

### Comunidade
- Contribuidores e todos que ajudaram a evoluir este projeto
- Comunidade Slack/Discord de usuários yoga-files

---

## 📄 **Licença**

MIT License - Use como quiser, modifique como precisar, mas mantenha os créditos.

---

## 🔗 **Links Importantes**

- **Repositório Principal**: https://github.com/rodrigocnascimento/yoga-files
- **Documentação**: https://yoga-files.dev/docs
- **Issues e Bugs**: https://github.com/rodrigocnascimento/yoga-files/issues
- **Discord Community**: https://discord.gg/yoga-files
- **Roadmap Público**: https://github.com/rodrigocnascimento/yoga-files/projects/1

---

<div align="center">

### 🧘 **Namastê** - Que seu desenvolvimento seja produtivo, consciente e com inteligência artificial!

*Feito com 🧘 e ❤️ no Rio de Janeiro*

---

## 📋 **Checklist de Funcionalidades**

### ✅ **Instalação e Setup**
- [ ] **Ambiente**: ASDF + LazyVim configurados
- [ ] **Git**: Perfis criados e funcionando
- [ ] **IA**: OpenAI API configurada
- [ ] **Themes**: Tema yoga aplicado em todo lugar

### ✅ **Ferramentas JavaScript/TypeScript**
- [ ] **ASDF**: Node.js, npm, TypeScript gerenciados
- [ ] **LazyVim**: LSP, completion, temas funcionando
- [ ] **Biome**: Linting e formatting automático
- [ ] **Testing**: Vitest configurado e funcionando

### ✅ **Integrações IA**
- [ ] **OpenAI CLI**: Funcional e testado
- [ ] **Copilot**: Plugin Neovim funcionando
- [ ] **Code Review**: Análise automática implementada
- [ ] **Documentation**: Geração de docs assistida

### ✅ **Qualidade**
- [ ] **Performance**: Tempo de startup < 2s
- [ ] **Cobertura**: Testes > 90% de cobertura
- [ ] **Segurança**: Análise de vulnerabilidades automática
- [ ] **Documentação**: 100% dos comandos documentados

---

## 🔥 **Quick Start**

```bash
# Instalação completa (2-3 minutos)
curl -fsSL https://raw.githubusercontent.com/rodrigocnascimento/yoga-files/main/install.sh | bash
source ~/.yoga/init.sh

# Criar projeto React+TypeScript em 30s
yoga-create react meu-app

# Chat com IA sobre seu código
ai-review src/components/Button.tsx

# Dashboard completo do ambiente
yoga
```

---

**Este README está sempre sendo atualizado. Confira a documentação mais recente em [yoga-files.dev/docs](https://yoga-files.dev/docs)**
