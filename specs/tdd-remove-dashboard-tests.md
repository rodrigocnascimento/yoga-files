# TDD: Remove Dashboard References from Smoke Tests & Aliases

## Objective & Scope

- **What**: Remove all references to the deleted `core/dashboard.sh` and `yoga_dashboard` from test files and aliases, adapting the smoke tests for the Yoga 3.0 architecture (no dashboard).
- **Why**: The `core/dashboard.sh` file was deleted in the Lôro Barizon Edition (3.0), but `tests/smoke.bash`, `tests/smoke.zsh`, and `core/aliases.sh` still reference it, causing test failures and keeping a dead alias trap.
- **File Target**: `specs/tdd-remove-dashboard-tests.md`

## Proposed Technical Strategy

### Problem Analysis

After `core/dashboard.sh` was deleted, 3 files still carry dashboard-related references:

1. **`tests/smoke.bash`** (lines 30, 34):
   - Line 30: `zsh -n "$ROOT_DIR/core/dashboard.sh"` — syntax check for deleted file
   - Line 34: `bash -c "... type yoga_dashboard >/dev/null"` — runtime check for deleted function

2. **`tests/smoke.zsh`** (lines 32, 36):
   - Line 32: `zsh -n "$ROOT_DIR/core/dashboard.sh"` — syntax check for deleted file
   - Line 36: `zsh -c "... whence -w yoga_dashboard >/dev/null"` — runtime check for deleted function

3. **`core/aliases.sh`** (lines 63-64):
   - Line 63: `alias yoga='yoga_dashboard'` — the alias trap that caused the original 2.0 "trapping" problem
   - Line 64: `alias yogi='yoga_dashboard'`

### Logic Flow

1. Remove the `core/dashboard.sh` syntax check lines from both smoke tests
2. Remove the `yoga_dashboard` runtime check lines from both smoke tests
3. Replace with meaningful 3.0 checks:
   - Check that `init.sh` sources without error (already exists)
   - Add a check that `bin/yoga` command is available (the new CLI entry point)
   - Add a check that `yoga_status` function is still available (it's in `functions.sh`)
4. Update `core/aliases.sh`:
   - Remove `alias yoga='yoga_dashboard'` (the trap)
   - Change `alias yogi='yoga_dashboard'` → `alias yogi='yoga'` (points to `bin/yoga` CLI)
   - This keeps the `yogi` alias functional via the CLI, not via a deleted function

### Impacted Files

| File | Change |
|------|--------|
| `tests/smoke.bash` | Remove dashboard.sh syntax check + `yoga_dashboard` check; add `bin/yoga` check |
| `tests/smoke.zsh` | Remove dashboard.sh syntax check + `yoga_dashboard` check; add `bin/yoga` check |
| `core/aliases.sh` | Remove `yoga='yoga_dashboard'` trap; change `yogi` alias to point to `yoga` CLI |

### Language-Specific Guardrails

- **Shell**: Use `set -euo pipefail` (bash) and `set -euo pipefail` with `emulate -L zsh` (zsh) as already present
- **Error Handling**: Each check should exit 1 on failure, preserving the existing `need_cmd` pattern
- **Cross-shell**: Both `.bash` and `.zsh` tests must pass independently

## Implementation Plan

### 1. `tests/smoke.bash`

**Remove:**
- Line 30: `bash -n "$ROOT_DIR/core/dashboard.sh"` — deleted file
- Line 34: `bash -c "... type yoga_dashboard >/dev/null"` — deleted function

**Add:**
```bash
echo "==> bin/yoga CLI"
bash -c "export YOGA_HOME='$ROOT_DIR'; export YOGA_SILENT=1; source '$ROOT_DIR/init.sh'; command -v yoga >/dev/null"
```

This verifies the `yoga` command resolves (via PATH to `bin/yoga`) after `init.sh` is sourced.

### 2. `tests/smoke.zsh`

**Remove:**
- Line 32: `zsh -n "$ROOT_DIR/core/dashboard.sh"` — deleted file
- Line 36: `zsh -c "... whence -w yoga_dashboard >/dev/null"` — deleted function

**Add:**
```zsh
print "==> bin/yoga CLI"
zsh -c "export YOGA_HOME='$ROOT_DIR'; export YOGA_SILENT=1; source '$ROOT_DIR/init.sh'; command -v yoga >/dev/null"
```

Note: Also keep the `whence -w yoga_status` check that's already on line 36 (partially), but drop the `yoga_dashboard` part.

### 3. `core/aliases.sh`

**Remove:**
- Line 63: `alias yoga='yoga_dashboard'`

**Change:**
- Line 64: `alias yogi='yoga_dashboard'` → `alias yogi='yoga'`

The `yoga` command will resolve to `bin/yoga` (the CLI), which is the correct 3.0 behavior. No more dashboard trap.

### Execution Order

1. Edit `tests/smoke.bash` — remove dashboard lines, add yoga CLI check
2. Edit `tests/smoke.zsh` — remove dashboard lines, add yoga CLI check
3. Edit `core/aliases.sh` — remove `yoga_dashboard` trap, remap `yogi`
4. Run `./tests/run-all.sh` to verify all tests pass
