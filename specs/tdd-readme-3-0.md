# TDD: Update README for Yoga 3.0 Lôro Barizon Edition

## Objective & Scope

- **What**: Rewrite `README.md` to reflect Yoga 3.0 — succinct, factual, no dashboard references, following the existing project style (Portuguese, emoji section headers, expressive tone)
- **Why**: Current README documents 2.0 (dashboard-centric, outdated `yoga_dashboard` commands, 477 lines, references things that don't exist in 3.0). The 3.0 architecture is CLI-first with `yoga <command>` subcommands, standalone modules (no `~/.zsh/` dep), mandatory daemon, Tmux A++, and functional JS/TS debugging.
- **File Target**: `specs/tdd-readme-3-0.md`

## Proposed Technical Strategy

### What Changes in 3.0 vs 2.0

| Removed (2.0) | Replaced By (3.0) |
|---|---|
| `core/dashboard.sh` (entire file) | `bin/yoga` CLI with subcommands |
| `yoga` → `yoga_dashboard` alias trap | `yoga` → `bin/yoga` CLI (no trap) |
| `yoga-menu` dashboard menu | `yoga cc` Command Center |
| `yoga-status` standalone binary | `yoga status` subcommand via daemon |
| `ai-chat`, `ai-code`, `ai-review` aliases | `yoga ai ask <query>` |
| `~/.zsh/` external dependency | Standalone modules in `core/modules/` |
| Sonarlint plugin | Removed (non-functional) |
| No tunnel support | `yoga tunnel` wraps `~/cf-tunnels/` |
| No workspace manager | `yoga workspace` native tmux integration |

### Style Guide (from existing README)

Keep the Portuguese + expressive style:
- Section headers with emoji: `## 🚀 **Instalação Rápida**`
- Bold labels: `- **Gestão universal**: Uma ferramenta...`
- Code blocks for all commands
- Center-aligned closing: `*Feito com 🧘 e ❤️ no Rio de Janeiro*`
- But **cut the bloat**: remove aspirational sections (checklist, roadmap 2.1/2.2), inflated config.yaml examples, and 30+ AI example lines

### New README Structure (~180 lines)

```
# yoga-files
> tagline + badges

## 🦜 **O que é o Yoga 3.0**
4 lines explaining: CLI-first dev environment, ninja mode (no dashboard trap), standalone modules, daemon

## 🚀 **Instalação Rápida**
Same curl command + what the installer does (6 steps, keep current style)

## 🎮 **Comandos (3.0 CLI)**
Table with:
- yoga cc | Command Center interativo
- yoga workspace | Gerenciador de workspaces (tmux)
- yoga tunnel | Cloudflare Tunnels
- yoga status | Status do ambiente e daemon
- yoga doctor | Diagnóstico do ambiente
- yoga daemon start/stop/restart | Gerenciamento do daemon
- yoga ai ask <query> | Assistente IA
- yoga create <template> <name> | Criar projeto
- yoga remove <lang> | Remover runtime ASDF

## 👹 **Daemon**
Brief: obrigatório, Unix socket, state management, 3 lines

## 🚇 **Tunnel (cf-tunnels)**
Brief: wrapper, requires ~/cf-tunnels/, 3 lines

## 🎨 **LazyVim + Debug JS/TS**
Brief: pwa-node (not node2), VS Code launch.json support, js-debug-adapter, 5 lines

## 🖥️ **Tmux A++**
Brief: smart sessions, popups, fzf, plugins, 5 lines

## 🏗️ **Estrutura de Arquivos**
Simplified tree (~25 lines, only key dirs)

## 🔧 **Configuração**
Just YOGA_HOME env var, 5 lines total

## 📚 **Documentação**
Links to docs/ (keep current style)

## ❤️ **Contribuição + Licença**
Keep current style, concise

## Namastê closing
```

### What to Remove

- `## 📋 Visão Geral` — merge into "O que é" (shorter)
- `## 🎯 Principais Características` — 5 sub-sections (30 lines) → merge key points into "O que é"
- `## 📚 Documentação` — keep but update links for 3.0 docs structure
- `## 🎯 Stack JavaScript/TypeScript` — keep the table, remove `create_js_project` examples (still exists as `yoga create`)
- `## 🎨 Configuração do Ambiente` — remove full config.yaml block, keep just env vars
- `## 🎮 Comandos Principais` — complete rewrite for 3.0 subcommands
- `## 🤖 yoga-ai: Assistente` — cut from 30+ lines to 5 example lines
- `## 🎯 Exemplos Práticos` — remove entirely
- `## 🏗️ Estrutura de Arquivos` — simplify, reflect 3.0 structure (no dashboard.sh, add modules/, daemon/, etc.)
- `## 🎯 Roadmap Futuro` — remove (2.1/2.2 never delivered)
- `## 📋 Checklist de Funcionalidades` — remove (aspirational)
- `## 🔥 Quick Start` — merge into Instalação section

### Impacted Files

| File | Change |
|---|---|
| `README.md` | Full rewrite — 3.0 content, same style |

## Implementation Plan

### Step 1: Create branch from updated main

```bash
git checkout main  # already on main, already pulled
git checkout -b docs/ISSUE-6-readme-3-0
```

### Step 2: Rewrite README.md

Rewrite following the structure above. Keep:
- Portuguese language
- Emoji section headers (🦜🚀🎮👹🚇🎨🖥️🏗️🔧📚❤️)
- Expressive tone (fogo, água, terra style)
- Code blocks for installation and commands
- Center-aligned closing

Remove:
- All dashboard references
- Config.yaml full example
- AI 30-line examples → 5 lines max
- Roadmap, Checklist sections
- `yoga_dashboard`, `yoga-menu`, `yoga-status` (standalone) references
- `js-dev/build/test/fix/create` aliases (some still exist as bin scripts but not as 3.0 CLI commands)

Replace with:
- `yoga cc`, `yoga workspace`, `yoga tunnel`, `yoga status`, `yoga doctor`, `yoga daemon`, `yoga ai`, `yoga create`, `yoga remove`
- Daemon explanation
- Tmux A++ brief
- LazyVim debug (pwa-node) brief
- Updated file structure tree

Target: ~180 lines (from 477)

### Step 3: Commit

```bash
git add README.md
git commit -m "docs(readme): rewrite for yoga 3.0 loro barizon edition"
```
