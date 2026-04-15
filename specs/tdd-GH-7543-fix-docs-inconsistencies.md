# TDD: Fix Documentation Inconsistencies (GH-7543)

## Objective & Scope

**What:** Corrigir todas as inconsistências entre documentação e código real no repositório yoga-files. 79 issues em 22+ arquivos: versões desatualizadas, comandos inexistentes, referências a features removidas, paths incorretos, providers incompletos.

**Why:** Documentação desatualizada pode confundir usuários e contribuidores. Exemplos críticos: comando `yai` documentado mas inexistente, referências ao dashboard removido, paths de socket/PID errados.

**File Target:** `specs/tdd-GH-7543-fix-docs-inconsistencies.md`

## Proposed Technical Strategy

### 6 categorias de correção:

1. **Versão 2.0 → 3.0**: `bin/yoga`, `cli-reference.md`, `logging.md`, `state-management.md`, `workspace-module.md`, `core-functions.md`, `api-reference.md`, `yoga/README.md`
2. **YOGA_HOME**: `bin/yoga` `.yoga-files` → `.yoga` (alinhar com `init.sh`)
3. **Paths socket/pid/db**: `core-functions.md`, `configuration.md` — `yoga.sock` → `daemon.sock`, `yoga.pid` → `daemon.pid`, `state/yoga.db` → `state.db`
4. **Comandos inexistentes**: `AI_INTEGRATION.md`, `CHEATSHEET.md`, `GUIA_DE_TESTES.md`, `SETUP_GUIDE.md`, `USAGE_GUIDE.md`
5. **AI providers**: `AI_INTEGRATION.md`, `ai-module.md`, `configuration.md`
6. **Documento histórico**: `yoga-2-hybrid-architecture.md`

### Impacted Files (22 arquivos):
- `bin/yoga`
- `docs/AI_INTEGRATION.md`
- `docs/CHEATSHEET.md`
- `docs/GUIA_DE_TESTES.md`
- `docs/SETUP_GUIDE.md`
- `docs/USAGE_GUIDE.md`
- `docs/yoga/cli-reference.md`
- `docs/yoga/core-functions.md`
- `docs/yoga/configuration.md`
- `docs/yoga/state-management.md`
- `docs/yoga/logging.md`
- `docs/yoga/workspace-module.md`
- `docs/yoga/api-reference.md`
- `docs/yoga/ai-module.md`
- `docs/yoga/daemon.md`
- `docs/yoga/README.md`
- `docs/ASDF_GUIDE.md`
- `docs/LAZYVIM_SETUP.md`
- `docs/yoga-2-hybrid-architecture.md`
- `docs/ROADMAP.md`

## Implementation Plan

1. Criar branch `docs/GH-7543-fix-docs-inconsistencies`
2. Corrigir `bin/yoga` (versão + YOGA_HOME)
3. Corrigir versões em lote (8 arquivos)
4. Corrigir paths socket/pid/db (2 arquivos)
5. Corrigir comandos inexistentes (5 arquivos)
6. Corrigir AI providers (3 arquivos)
7. Marcar doc histórical (1 arquivo)
8. Rodar testes: `./tests/run-all.sh`
9. Commit + PR