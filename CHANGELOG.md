# 📋 CHANGELOG - Yoga Files

> Histórico de evoluções do seu ambiente de desenvolvimento YOGA

---

## Unreleased

- Docs: add missing guides under `docs/`
- Roadmap: align milestones and delivery plan
- Release: add `docs/RELEASE_CHECKLIST.md`
- Installer: copy `editor/` overlays into `~/.yoga`
- Editor: add LazyVim JS/TS + AI overlays under `editor/nvim/`
- AI: provider/model via `config.yaml` (OpenAI + Copilot)
- Doctor: add `--full` optional checks
- Docs: add `docs/USAGE_GUIDE.md`

---

## Versao 2.0.0 *(Fevereiro 2026)*

### Principais mudancas

- Installer e bootstrap reestruturados (`install.sh`, `init.sh`)
- Utilitarios e tema Yoga (mensagens/cores) consolidados
- Dashboard interativo no terminal
- Primeira integracao de IA no terminal (OpenAI via `OPENAI_API_KEY`)
- Git profiles wizard (multi-identidade)

### 🔥 **Novas Ferramentas**
- **biome**: Substituto ESLint+Prettier (15x mais rápido)
- **vitest**: Test runner moderno com Hot Module Replacement
- **npm**: Package manager padrão do Node.js
- **tsx**: Execução TypeScript zero-config

### Notas

- A integracao de IA depende de `curl` + `jq` e de uma API key valida.
- O comportamento e os comandos podem mudar enquanto v2.0 estabiliza.

### 🎯 **Novos Comandos**
```bash
yoga-ai          # Menu completo de IA
ai-chat            # Chat com OpenAI GPT-4
ai-code            # Geração assistida de código
ai-review          # Review automatizado
copilot             # GitHub Copilot integration
opencode            # OpenCode development integration
```

### 📦 **Novos Templates**
```bash
create_js_project react my-app     # React + TypeScript + LazyVim
create_js_project node my-api    # Node.js + ASDF + OpenAI
create_js_project next my-blog   # Next.js + Yoga Theme
```

---

## Versao 1.x

### ⚡ **Melhorias de Editor**
- Migração completa para LazyVim
- Plugins modernos: Telescope, Treesitter, LSP
- Configuração centralizada em arquivos Lua
- Performance: lazy-loading e cache inteligente

### 🛠️ **ASDF Integration**
- Suporte para Node.js, Python, PHP, TypeScript
- Interface interativa para seleção de versões
- Auto-detecção de versões por projeto
- Scripts de instalação automatizados

### 🌈 **Cores Yoga Aprimoradas**
- Paleta refinada: FOGO 🔥, ÁGUA 💧, TERRA 🌿, AR 🌬️, ESPÍRITO 🧘
- Feedback visual mais expressivo
- Animações sutis no terminal

### 📝 **Novos Aliases**
```bash
yoga-create       # Criar projeto com IA assistência
yoga-review       # Revisar código com especialista IA
asdf-menu        # Menu ASDF interativo
js-fix            # Formatar código com Biome
copilot           # Ativar/desativar Copilot
```

---

## Versao 1.0

### 🌱 **Estrutura Inicial**
- Projeto criado como "yoga-files"
- Sistema modular em `core/` com módulos especializados
- Scripts de instalação automatizados
- Primeira versão das funções yoga_* com cores

### 🧘 **Primeiras Features**
- Funções yoga de cores (yoga_fogo, yoga_agua, etc)
- Sistema de aliases básicos
- Scripts para Node.js, Python, Git
- Instalador principal (install.sh)
- README inicial com documentação básica

### 🔥 **Ferramentas Originais**
- ESLint para JavaScript
- Prettier para formatação
- NVM para gerenciar Node.js
- Plugin manager: vim-plug
- Git básico com .gitconfig estático

### 📈 **Primeiras Melhorias**
- Sistema cross-platform (Linux/macOS/Windows)
- Detecção automática de ambiente
- Instalação de dependências via script
- Integração com ferramentas modernas

### 🌿 **Limitações Iniciais**
- Configuração manual de ferramentas
- Sem gerenciamento unificado de versões
- Performance limitada de plugins de editor
- Sem integração com ferramentas de IA

---

## Proximas versoes

See `docs/ROADMAP.md`.

---

## 📝 **Notas de Versão**

### ✅ **Releases Estáveis**
- Marcadas com versões semânticas (major.minor.patch)
- Backward compatibility mantida
- Documentação completa para cada versão

### 🧪 **Releases Experimentais**
- Para testar funcionalidades novas
- Disponíveis como branches separadas
- Feedback da comunidade incentivado

---

## 🤝 **Agradecimentos Especiais**

### Versão 1.0
- Comunidade beta testers
- Feedback inicial de usabilidade
- Ideias e sugestões iniciais

### Versão 1.5  
- Contributors de LazyVim
- Testadores da versão ASDF
- Traduções e adaptações culturais

### Versão 2.0
- Comunidade OpenAI e Copilot
- Contribuidores de plugins
- Todos que ajudaram a evoluir o projeto

---

**Cada versão representa um passo importante na jornada de transformar seu ambiente de desenvolvimento em um ecossistema cada vez mais poderoso e intuitivo! 🧘✨**
