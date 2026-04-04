# TDD: Fix yoga-remove Complete Uninstallation

**File target:** `specs/tdd-ISSUE-004-fix-yoga-remove.md`

## 1. Objective & Scope

**What:** `yoga-remove` only uninstalls a specific version (`asdf uninstall`). It does NOT remove the ASDF plugin, clean `~/.tool-versions`, or handle the case where versions were already removed but the plugin lingers.

**Why:** After running `yoga-remove golang`, the system still shows:
- `asdf plugin list` → `golang` (plugin present)
- `~/.tool-versions` → `golang 1.26.1` (stale entry)
- `~/.asdf/installs/golang/` → empty directory

Three bugs:
1. No plugin removal after uninstalling all versions
2. No `~/.tool-versions` cleanup
3. Early exit when no versions found, leaving the plugin as ghost state

## 2. Proposed Technical Strategy

**Impacted files:**
- `bin/yoga-remove` (sole file modified)

**Changes:**
1. After uninstalling a version, check if any remain. If none, offer to remove the plugin entirely.
2. When no versions are installed (early-exit path), offer plugin removal instead of just exiting.
3. After plugin removal, clean `~/.tool-versions` of matching entries.
4. Add "all" option when multiple versions exist.

## 3. Implementation Plan

### Helper: cleanup_tool_versions
```bash
cleanup_tool_versions() {
    local lang=$1
    local tvfile="$HOME/.tool-versions"
    if [ -f "$tvfile" ]; then
        sed -i.bak "/^${lang} /d" "$tvfile"
        rm -f "${tvfile}.bak"
    fi
}
```

### Helper: remove_plugin
```bash
remove_plugin() {
    local lang=$1
    if asdf plugin remove "$lang" 2>/dev/null; then
        yoga_terra "Plugin '$lang' removed"
    fi
    cleanup_tool_versions "$lang"
    yoga_terra "Cleaned $lang from ~/.tool-versions"
}
```

### Flow changes
- **No versions path:** ask to remove plugin → `remove_plugin`
- **After single version uninstall:** check remaining, if empty offer plugin removal
- **Multiple versions:** add "all" choice to remove everything at once
