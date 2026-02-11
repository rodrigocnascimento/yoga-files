# 🗺️ Yoga Files v2.0 - Project Tracker

> **Transformando ideias em realidade, um commit de cada vez.**

---

## 🎯 Visao Geral

**Status**: 🚀 EM IMPLEMENTACAO ATIVA
**Timeline**: Q1 2026 - em andamento
**Foco**: ASDF + LazyVim + AI (OpenAI/Copilot) + Git perfis + JavaScript/TypeScript
**Filosofia**: YOGA + feedback visual + performance
**Package Manager**: npm

**Ultima atualizacao**: 2026-02-11

---

## ✅ OKRs / Milestones

### 📋 Q1 2026 - Foundation Release (v2.0.0)

- [x] README expandido com visao do ambiente
- [x] install.sh reestruturado (instalacao + setup)
- [x] init.sh modernizado (bootstrap + shell integration)
- [x] Sistema de cores e mensagens (core/utils.sh)
- [x] Dashboard (core/dashboard.sh)
- [x] Config base (config.yaml)
- [x] Suite minima de smoke tests (tests/smoke.zsh + CI)
- [x] Hardening de shell scripts (quoting, compatibilidade macOS/Linux)

**Status**: 🎯 em progresso

### 📋 Q2 2026 - AI Layer (v2.1.0)

- [x] yoga-ai terminal helper (core/ai/yoga-ai-terminal.sh)
- [ ] Padronizar comandos AI (help/fix/cmd/explain/debug/code/learn)
- [x] Modo seguro: nunca executar comandos sugeridos por padrao
- [ ] Multi-provider (OpenAI / Copilot / Claude / Gemini) via config.yaml

Notas:

- Provider/model via `config.yaml` ja funciona para OpenAI (outros providers ainda pendentes).
- [ ] Integracao Neovim (plugin minimal + docs)

**Status**: 📅 em desenvolvimento

### 📋 Q3 2026 - Editor + Stack (v2.2.0)

- [x] LazyVim: setup JS/TS opinativo (LSP, formatter, lint)
- [x] Templates de projeto (React/Next/Node/Express)
- [ ] Performance: healthcheck e startup profiling
- [ ] Documentacao por modulo (ASDF, LazyVim, Git profiles, AI)

**Status**: 🔄 planejamento

### 📋 Q4 2026 - Workflow Automation (v2.3.0)

- [x] Comandos de update/doctor/status consistentes
- [x] Git profiles wizard: fluxo completo + integracao com dashboard
- [x] CI: instalacao + smoke tests em macos/ubuntu
- [ ] Release checklist + changelog

**Status**: 📋 especificacao

### 📋 2027 - Ecosystem Expansion (v3.0.0)

- [ ] Plugin system (modulos independentes)
- [ ] Community templates (curated)
- [ ] Telemetria opt-in (performance / erros) com privacidade

**Status**: 📋 visao futura

---

## 📊 Progresso Atual (Workstreams)

```text
Q1 2026: bootstrap + install + docs + CI
Q2 2026: AI layer + nvim integration
Q3 2026: editor + templates + perf
Q4 2026: automation + releases
```

Progresso estimado (baseado no `docs/ROADMAP.md`):

```text
Q1 2026 (v2.0.0): 83%
Q2 2026 (v2.1.0): 20%
Q3 2026 (v2.2.0): 0%
Q4 2026 (v2.3.0): 0%
2027 (v3.0.0): 0%

Geral: 29%
```

---

## 🏆 Detalhamento (curto)

### Q1 2026 - Foundation Release

**Meta**: instalar, carregar e usar o ambiente em poucos minutos.

**Arquivos chave**:
- README.md
- install.sh
- init.sh
- core/utils.sh
- core/dashboard.sh
- docs/SETUP_GUIDE.md

---

### Q2 2026 - AI Layer

**Meta**: assistente de terminal confiavel e integracao Neovim minima.

---

### 🔄 Status Atual

**Foco**: consolidar v2.0 (install/init/docs) e deixar CI verde.

Ultimas entregas:

- docs: guias faltantes adicionados (ASDF/LazyVim/AI/Git profiles/JS stack/Troubleshooting)
- CI: workflow ajustado para smoke tests nao-interativos
- scripts: remocao de `readlink -f` e uso consistente de `YOGA_HOME` em modulos principais

---

## 📈 Timeline (alto nivel)

### 2026

- Q1: Foundation (v2.0)
- Q2: AI Layer (v2.1)
- Q3: Editor + Templates (v2.2)
- Q4: Automation + Releases (v2.3)

---

---

## 🎯 Objetivo Final

Transformar o yoga-files em um ambiente de desenvolvimento rapido de instalar, consistente entre maquinas, e com assistencia de IA opcional e segura.
