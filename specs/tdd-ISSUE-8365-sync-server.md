# TDD: Yoga Dual-Mode Sync (ISSUE-8365)

## Objective & Scope

**What:** Implement a dual-mode sync architecture for Yoga:
1. **Local Mode** — SQLite database (default, works out of the box)
2. **Cloud Mode** — Firebase Firestore sync (optional, via `yoga sync setup`)

Enable workspace, commands, AI context, and config to sync across devices. Keep logs local-only.

**Why:** Users work across multiple devices (laptop, desktop, tablet). Currently, `state.db` is local-only, so they lose sync state when switching machines.

**File Target:** `specs/tdd-ISSUE-8365-sync-server.md`

## Proposed Technical Strategy

### 1. Dual-Mode Architecture

| Mode | Storage | Sync | Data Synced |
|------|---------|------|------------|
| **Local** | SQLite (`state.db`) | None | All + logs |
| **Cloud** | Firebase Firestore | Auto | All except logs |

**Default:** Local SQLite — fresh install works immediately.

**Cloud:** Enabled via `yoga sync setup` → OAuth flow → Firebase.

### 2. Data Segregation

| Data | Local Only | Synced |
|------|-----------|--------|
| Workspaces | ❌ | ✅ |
| Commands | ❌ | ✅ |
| AI Context | ❌ | ✅ |
| Config | ❌ | ✅ |
| **Logs** | ✅ | ❌ |

### 3. Firebase Collections

```
users/{userId}/
  workspaces/{workspaceId}
  commands/{commandId}
  ai_context/{contextId}
  config/{configId}
```

Supports multi-user, per-user settings, future sharing.

### 4. Firebase Setup Flow (Auto Setup)

```bash
yoga sync setup
# 1. Opens browser for Google OAuth
# 2. Creates user/{userId}/ in Firestore
# 3. Prompts: Use cloud sync or stay local?
# 4. Done!
```

User-friendly: no manual config, no API keys to copy.

### 5. Sync Commands

| Command | Description |
|---------|-------------|
| `yoga sync setup` | Enable cloud sync (OAuth flow) |
| `yoga sync status` | Show connection + sync status |
| `yoga sync pull` | Force download from cloud |
| `yoga sync push` | Force upload to cloud |
| `yoga sync reset` | Disconnect cloud, revert to local |

### 6. Status Output Example

```
$ yoga sync status
🔗 Cloud Sync: ACTIVE
📡 Status: Connected
👤 User: your-email@gmail.com
📁 Mode: cloud
📤 Last synced: 2026-04-18 10:30:00
🎯 Workspaces: 5 (synced)
📝 Commands: 127 (synced)
🤖 AI Context: 3 (synced)
⚙️ Config: synced
📋 Logs: local only (not synced)
```

### 7. Tool Validation (Enhanced)

#### Core/Mandatory (Installation Fails If Missing)
| Tool | Purpose |
|------|---------|
| git | Version control |
| sqlite3 | Local database |
| jq | JSON processing |
| tmux | Terminal sessions |
| node | Runtime |
| npm | Package manager (for firebase SDK) |

#### Optional (Shows Warning, Degraded Mode)
| Tool | Feature |
|------|---------|
| fzf | Fuzzy finder |
| docker | Container commands |
| gh | GitHub CLI |
| gum | UI prompts |
| nvim | Editor |
| asdf | Version manager |
| pbcopy/xclip/wl-copy | Clipboard |

#### Enhanced `yoga doctor`
- Validates ALL required tools are present
- Shows warnings for missing optional tools
- Suggests installation for missing optional deps when needed
- Shows cloud sync status if enabled

### 8. Implementation Phases

#### Phase 1: Tool Validation
- [ ] Enhance `yoga doctor` to check all required tools
- [ ] Make installation fail if core tools missing
- [ ] Show warnings for optional tools

#### Phase 2: Firebase Cloud Mode
- [ ] Add Firebase Admin SDK (Node.js)
- [ ] Create Firebase collections schema
- [ ] Implement `yoga sync setup` (OAuth flow)
- [ ] Implement `yoga sync status`
- [ ] Implement `yoga sync pull/push/reset`

#### Phase 3: Data Migration
- [ ] Export current SQLite data to Firestore
- [ ] One-time migration script
- [ ] Verify data integrity

#### Phase 4: Client Changes
- [ ] Replace SQLite calls with Firestore calls in cloud mode
- [ ] Keep SQLite for local mode
- [ ] Add dual-mode detection logic
- [ ] Update `bin/yoga --help`

#### Phase 5: Testing & Documentation
- [ ] Test local mode
- [ ] Test cloud sync across devices
- [ ] Update docs

### 9. Dependency Handling Strategy

**Core tools:**
- Installation MUST fail if core tools are missing
- User cannot proceed without git, sqlite3, jq, tmux, node, npm

**Optional tools:**
- Yoga must function without them (graceful degradation)
- When user invokes a feature requiring an optional tool, prompt:
  ```
  ⚠️ Feature "docker commands" requires "docker".
  Install it now? [Y/n]
  ```
- `yoga doctor` shows missing optional tools with installation hints

### 10. Language-Specific Guardrails

**TypeScript/Node.js (Firebase):**
- Use try/catch for async Firebase calls
- Define interfaces for Firestore documents (no `any`)
- Use Firebase Admin SDK with service account
- Path resolution: relative imports only (no `@/` aliases)

**Shell (bin/yoga):**
- Use `set -euo pipefail`
- Use `yoga_*` UI functions for output
- Check `command -v` before using external tools

## Path Resolution

- Client changes: `bin/yoga`
- Firebase config: `core/firebase/`
- Docs: `docs/SYNC.md`
- Tests: `tests/`

## Naming Standards

- `yoga sync setup` — enable cloud sync
- `yoga sync status` — show status
- `yoga sync pull` / `push` — manual sync
- `yoga sync reset` — disconnect
- Environment: `YOGA_FIREBASE_CREDS`, `YOGA_SYNC_MODE`

---

## Questions Answered

| # | Question | Answer |
|---|----------|--------|
| 1 | Core tools required? | Yes — installation fails if missing |
| 2 | Optional tools handled? | Yes — warnings shown, degraded mode works, prompts for deps |
| 3 | Improve yoga doctor? | Yes — validate all required tools |
| 4 | SQLite default? | Yes — local mode works out of the box |
| 5 | Logs synced? | No — logs stay on local machine |
| 6 | Firebase auth? | Google OAuth via `yoga sync setup` |