# 🗺️ Yoga Files Roadmap

> **Direcao de produto e entregas por versao.**

---

## 🎯 Visao 2026

Construir um ambiente de desenvolvimento que seja:

- rapido de instalar (minutos, nao horas)
- consistente entre macOS e Linux
- opinativo para JavaScript/TypeScript (sem travar outras stacks)
- com assistencia de IA opcional e segura

Progresso (estimativa):

```text
v2.0.0 (Q1 2026): 83%
v2.1.0 (Q2 2026): 20%
v2.2.0 (Q3 2026): 0%
v2.3.0 (Q4 2026): 0%
v3.0.0 (2027): 0%

Geral: 29%
```

---

## 📅 Q1 2026 - v2.0.0 Foundation

- [x] Novo README e estrutura de docs
- [x] install.sh e init.sh reestruturados
- [x] Cores/mensagens Yoga (core/utils.sh)
- [x] Dashboard interativo (core/dashboard.sh)
- [ ] Hardening do installer (quoting, checks, idempotencia)
- [ ] CI com smoke tests (macos + ubuntu)

---

## 📅 Q2 2026 - v2.1.0 AI Layer

- [x] Yoga AI no terminal (core/ai/yoga-ai-terminal.sh)
- [ ] Configurar providers via config.yaml
- [ ] Melhorar prompts por modo (help/fix/cmd/explain/debug/code/learn)
- [ ] Padrao de seguranca: nao executar nada automaticamente
- [ ] Integracao minima no Neovim (commands + docs)

---

## 📅 Q3 2026 - v2.2.0 Editor + Templates

- [ ] LazyVim com foco JS/TS (LSP, formatter, lint, test)
- [ ] Templates de projeto (React/Next/Node/Express/Vanilla TS)
- [ ] Healthcheck de performance (nvim startup / node/npm)
- [ ] Guia de troubleshooting por OS

---

## 📅 Q4 2026 - v2.3.0 Workflow Automation

- [ ] Git profiles wizard integrado ao dashboard
- [ ] Comandos consistentes: `yoga-status`, `yoga-update`, `yoga-doctor`
- [ ] Releases: changelog e checklist

---

## 🔮 2027 - v3.0.0 Ecosystem Expansion

- [ ] Plugin system (modulos independentes)
- [ ] Templates da comunidade (curated)
- [ ] Observabilidade opt-in (diagnostico e performance)
