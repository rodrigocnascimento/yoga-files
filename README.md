# yoga-files

![🧘 Yoga Development Environment](assets/yoga-files.png)

> **Seu ambiente de desenvolvimento com essência YOGA + inteligência artificial**
> *ASDF + LazyVim + IA Multi-provider + JavaScript/TypeScript Focus*

---

## 🦜 **O que é o Yoga**

**yoga-files** é um framework de ambiente de desenvolvimento que combina ASDF, LazyVim, IA multi-provider e Tmux numa experiência CLI-first. Funciona **under the hood** — sem dashboard, sem traps, sem `~/.zsh/`. Tudo roda via `yoga <comando>`.

- 🧘 **Ninja Mode**: CLI-first, sem dashboard interrupts
- 👹 **Daemon Obrigatório**: State management via Unix socket + SQLite
- 🎯 **Command Center**: Interface fzf interativa
- 🌌 **Workspaces**: Gerenciamento nativo com tmux
- 🚇 **Tunnel**: Wrapper para Cloudflare Tunnels
- 🛠️ **ASDF**: Version manager universal com menu interativo
- 🎨 **LazyVim**: Debug JS/TS funcional com `pwa-node`
- 🖥️ **Tmux A++**: Smart sessions, popups, fzf integration

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

Após instalar, inicie o daemon:
```bash
source ~/.yoga/init.sh
yoga daemon start
```

---

## 🎮 **Comandos (CLI 3.0)**

| Comando | Descrição |
|---------|-----------|
| `yoga cc` | Command Center interativo (fzf) |
| `yoga workspace list` | Listar workspaces |
| `yoga workspace create <nome>` | Criar workspace |
| `yoga workspace switch <nome>` | Trocar workspace |
| `yoga tunnel` | Cloudflare Tunnels (requer `~/cf-tunnels/`) |
| `yoga status` | Status do ambiente e daemon |
| `yoga doctor` | Diagnóstico completo do ambiente |
| `yoga daemon start\|stop\|restart` | Gerenciar daemon |
| `yoga ai ask "<pergunta>"` | Assistente IA no terminal |
| `yoga logs tail` | Acompanhar logs em tempo real |
| `yoga update` | Atualizar yoga-files |
| `yoga version` | Versão atual |
| `yoga create <template> <nome>` | Criar projeto (react, node, next, ts, express) |
| `yoga remove <lang>` | Remover runtime ASDF completamente |

### ASDF — Instalar e Remover Runtimes

```bash
# Instalar runtime interativamente (menu fzf)
yoga-asdf

# Instalar versão específica
asdf install nodejs 20.11.0
asdf install python 3.12.2

# Definir versão global
asdf global nodejs 20.11.0

# Remover runtime completamente (versões + plugin + .tool-versions)
yoga remove nodejs
```

### Comandos de Desenvolvimento

```bash
# LazyVim
nvim                    # Abrir Neovim
nvim-reload             # Recarregar configuração
nvim-config             # Abrir pasta de config

# Git Inteligente
git-profile             # Gerenciar perfis Git
git-wizard              # Wizard interativo de perfis

# IA no Terminal
yoga-ai help            # Ajuda
yoga-ai fix "comando"   # Corrigir comando
yoga-ai code "desc"     # Gerar código
ai-chat                 # Chat com IA (alias)
```

---

## 👹 **Daemon**

O daemon é **obrigatório** — gerencia estado, plugins, IA e logs via Unix socket + SQLite.

```bash
yoga daemon start      # Iniciar
yoga daemon stop       # Parar
yoga daemon restart    # Reiniciar
yoga status            # Verificar status
```

Requisitos: `socat` ou `nc`, `sqlite3`, `jq`

---

## 🚇 **Tunnel (cf-tunnels)**

Wrapper para `~/cf-tunnels/` com UI Yoga e logging estruturado.

```bash
yoga tunnel list              # Listar túneis
yoga tunnel add --hostname api.example.com --type http --service localhost:3000
yoga tunnel hud               # Dashboard TUI
```

Requer: `~/cf-tunnels/` instalado

---

## 🎨 **LazyVim + Debug JS/TS**

Debug funcional para JavaScript/TypeScript usando `pwa-node` (não o obsoleto `node2`):

- `js-debug-adapter` instalado via Mason
- Suporte a `.vscode/launch.json` com conversão automática de `node-terminal` → `pwa-node`
- Busca híbrida: raiz do projeto → subpastas → pergunta ao usuário

```bash
# No Neovim: <leader>dc para iniciar debug
# Ou: :DapContinue
```

---

## 🖥️ **Tmux A++**

Configuração Grade A++ com:

- **Smart Session Manager**: `t-smart-tmux-session-manager`
- **Popups**: lazygit (`<prefix>g`), btop (`<prefix>b`), scratchpad (`<prefix>s`)
- **fzf Integration**: switching de sessão e janela
- **4 Plugins Extras**: tmux-yank, prefix-highlight, tmux-fzf, floax
- **Temas**: Catppuccin Mocha

Config: `~/.config/tmux/tmux.conf`

---

## 🏗️ **Estrutura de Arquivos**

```
yoga-files/
├── bin/                      # Executáveis CLI
│   ├── yoga                  # Entry point (subcommand routing)
│   ├── yoga-tunnel           # Wrapper cf-tunnels
│   ├── yoga-daemon           # Daemon lifecycle
│   ├── yoga-ai               # Assistente IA
│   ├── yoga-create           # Criar projetos
│   ├── yoga-doctor           # Diagnóstico
│   ├── yoga-status           # Status do ambiente
│   ├── yoga-remove           # Remover runtimes ASDF
│   ├── yoga-asdf             # Menu ASDF interativo
│   └── opencode-compile      # Compilar regras .opencode/
├── core/                      # Módulos principais
│   ├── utils.sh              # Funções yoga_* (cores, UI)
│   ├── aliases.sh             # Aliases
│   ├── functions.sh           # Funções utilitárias
│   ├── common.sh              # Helpers comuns
│   ├── modules/               # Módulos standalone
│   │   ├── cc/                # Command Center
│   │   └── workspace/         # Workspace Manager
│   ├── daemon/                # Daemon (server/client/lifecycle)
│   ├── ai/                    # Integração IA
│   ├── git/                   # Git wizard + perfis
│   └── version-managers/      # ASDF scripts
├── init.sh                    # Bootloader do ambiente
├── install.sh                 # Instalador principal
├── specs/                     # Technical Design Documents
├── docs/                      # Documentação completa
└── tests/                     # Testes smoke (bash/zsh)
```

---

## 🔧 **Configuração**

```bash
export YOGA_HOME="$HOME/.yoga"
export YOGA_SILENT=1            # Modo silencioso (ninja)
```

---

## 📚 **Documentação**

- **[📖 Yoga System](docs/yoga/README.md)**: Arquitetura, daemon, módulos
- **[📖 LazyVim](docs/lazyvim/README.md)**: Setup, debug, keymaps
- **[📖 Tmux](docs/tmux/README.md)**: Keybindings, plugins, workflow
- **[📖 Tunnel](docs/tunnel/README.md)**: Cloudflare Tunnels
- **[📖 Troubleshooting](docs/lazyvim/troubleshooting.md)**: Problemas comuns

---

## ❤️ **Contribuição**

### Como Contribuir
1. **Fork** o repositório
2. **Crie** uma branch: `git checkout -b feat/<issue>-<slug>`
3. **Faça** suas alterações
4. **Teste**: `./tests/run-all.sh`
5. **Envie** um pull request com descrição clara

### Convenções
- **Commits**: Conventional Commits (`feat(api): add endpoint`)
- **Código**: Siga os padrões em `CODE_STANDARDS.md`
- **Testes**: Cubra novos recursos com testes

---

## 📄 **Licença**

MIT License — Use como quiser, modifique como precisar, mas mantenha os créditos.

---

## 🔗 **Links**

- **Repositório**: https://github.com/rodrigocnascimento/yoga-files
- **Documentação**: `./docs/`
- **Issues**: https://github.com/rodrigocnascimento/yoga-files/issues

---

<div align="center">

### 🧘 **Namastê** — Que seu desenvolvimento seja produtivo, consciente e inteligente!

*Feito com 🧘 e ❤️ no Rio de Janeiro*