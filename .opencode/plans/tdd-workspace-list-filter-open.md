# TDD: Workspace List Filter --open

## Objective & Scope

- **What:** Adicionar flag `--open` ao comando `yoga workspace list` para filtrar e mostrar apenas workspaces com sessão tmux ativa (abertos).
- **Why:** O comportamento atual lista todos os projetos em `$CODE_DIR`, incluindo os que não estão abertos. O usuário deseja uma forma de ver rapidamente apenas os workspaces ativos.
- **File Target:** `.opencode/plans/tdd-workspace-list-filter-open.md`

## Proposed Technical Strategy

### Logic Flow

1. Router em `bin/yoga` captura a flag `--open` e passa para as funções de listagem
2. `workspace_standalone_list_interactive` e `workspace_standalone_list_simple` recebem a flag
3. Quando `--open` é passada, filtram apenas projetos que têm sessão tmux ativa
4. Se não houver flag, comportamento padrão permanece listando todos (com indicador visual 🟢)

### Impacted Files

| File | Change |
|------|--------|
| `bin/yoga` | Router capturing `--open` flag |
| `core/modules/workspace/standalone.sh` | Both list functions accept and process `--open` |
| `docs/yoga/workspace-module.md` | Update CLI usage documentation |
| `docs/yoga/cli-reference.md` | Add `--open` flag to command reference |

### Language-Specific Guardrails

- **Shell/Bash:** Usar parsing manual de flags com `case`
- **Error Handling:** Se não houver workspaces ativos, exibir mensagem informativa

## Implementation Plan

### Step 1: Modify Router (`bin/yoga`)

```bash
# Around line 130-136
list|ls)
    local filter_open=false
    if [[ "${1:-}" == "--open" ]]; then
        filter_open=true
        shift
    fi
    if [[ "${1:-}" == "--simple" ]]; then
        workspace_standalone_list_simple "$filter_open"
    else
        workspace_standalone_list_interactive "$filter_open"
    fi
    ;;
```

### Step 2: Modify `workspace_standalone_list_interactive`

```bash
# Update function signature
function workspace_standalone_list_interactive {
    local filter_open="${1:-false}"
    
    # ... existing code ...
    
    # Add filter after collecting projects
    if [[ "$filter_open" == "true" ]]; then
        local -a filtered=()
        for row in "${rows[@]}"; do
            if [[ "$row" == *"🟢"* ]]; then
                filtered+=("$row")
            fi
        done
        rows=("${filtered[@]}")
    fi
}
```

### Step 3: Modify `workspace_standalone_list_simple`

```bash
# Update function signature
function workspace_standalone_list_simple {
    local filter_open="${1:-false}"
    
    # ... existing code ...
    
    # Skip inactive when filter is on
    if [[ "$filter_open" == "true" ]] && [[ "$ws_status" == "⚪" ]]; then
        continue
    fi
}
```

### Step 4: Update Documentation

Atualizar os seguintes arquivos de documentação:

**`docs/yoga/workspace-module.md`:**
```markdown
yoga workspace list             # Lista interativa
yoga workspace list --open     # Lista apenas workspaces abertos
yoga workspace list --simple    # Lista simples (sem fzf)
yoga workspace list --simple --open  # Lista simples apenas abertos
```

**`docs/yoga/cli-reference.md`:**
```markdown
yoga ws list                  # Interactive workspace list
yoga ws list --open           # List only open workspaces
yoga ws ls --simple           # Plain text workspace list
yoga ws ls --simple --open    # Plain text only open workspaces
```

### Step 5: Test

```bash
yoga workspace list              # Lista todos
yoga workspace list --open       # Lista apenas abertos
yoga workspace list --simple     # Lista simples todos
yoga workspace list --simple --open  # Lista simples apenas abertos
```

## Path Resolution

- `bin/yoga`: 2 levels from root
- `core/modules/workspace/standalone.sh`: 3 levels from root
- Relative paths preserved as existing

## Naming Standards

- Flag: `--open` (consistent with CLI conventions)
- Parameter: `filter_open` (boolean string "true"/"false")
- Funções existentes mantêm nomes originais