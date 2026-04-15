# API Reference

Complete reference for every function, variable, and alias in the Yoga framework.

---

## core/utils.sh (v3.0.0)

Core UI and utility functions providing the element-based color system and interactive features.

### Exported Variables

| Variable | Value | Description |
|----------|-------|-------------|
| `YOGA_FOGO` | `\033[1;31m` | Bold red — Energy, action, alerts |
| `YOGA_AGUA` | `\033[1;36m` | Bold cyan — Flow, process, information |
| `YOGA_TERRA` | `\033[1;32m` | Bold green — Stability, success, confirmation |
| `YOGA_AR` | `\033[1;34m` | Bold blue — Lightness, progress, movement |
| `YOGA_ESPIRITO` | `\033[1;35m` | Bold magenta — Transcendence, wisdom |
| `YOGA_SOL` | `\033[1;33m` | Bold yellow — Illumination, warning, attention |
| `YOGA_LUA` | `\033[0;37m` | White — Clarity, neutral text |
| `YOGA_RESET` | `\033[0m` | Reset to default terminal color |
| `YOGA_FOGO_ICON` | `🔥` | Fogo emoji |
| `YOGA_AGUA_ICON` | `💧` | Agua emoji |
| `YOGA_TERRA_ICON` | `🌿` | Terra emoji |
| `YOGA_AR_ICON` | `🌬️` | Ar emoji |
| `YOGA_ESPIRITO_ICON` | `🧘` | Espirito emoji |
| `YOGA_SOL_ICON` | `☀️` | Sol emoji |
| `YOGA_LUA_ICON` | `🌙` | Lua emoji |

---

### `yoga_fogo`

**Signature:** `yoga_fogo <message>`

**Description:** Print bold red error message with 🔥 emoji. Writes to stderr and returns 1.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Message text |

**Return value:** Always returns 1 (error exit code).

**Output:** `🔥 FOGO! <message>` in bold red to stderr.

**Example:**
```zsh
yoga_fogo "File not found"
# Output: 🔥 FOGO! File not found  (red, to stderr)
echo $?  # 1
```

---

### `yoga_agua`

**Signature:** `yoga_agua <message>`

**Description:** Print bold cyan informational message with 💧 emoji.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Message text |

**Return value:** 0.

**Output:** `💧 ÁGUA! <message>` in bold cyan.

**Example:**
```zsh
yoga_agua "Processing data..."
```

---

### `yoga_terra`

**Signature:** `yoga_terra <message>`

**Description:** Print bold green success/confirmation message with 🌿 emoji.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Message text |

**Return value:** 0.

**Output:** `🌿 TERRA! <message>` in bold green.

**Example:**
```zsh
yoga_terra "Operation completed successfully"
```

---

### `yoga_ar`

**Signature:** `yoga_ar <message>`

**Description:** Print bold blue progress/movement message with 🌬️ emoji.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Message text |

**Return value:** 0.

**Output:** `🌬️ AR! <message>` in bold blue.

**Example:**
```zsh
yoga_ar "Deploying to production..."
```

---

### `yoga_espirito`

**Signature:** `yoga_espirito <message>`

**Description:** Print bold magenta wisdom/conclusion message with 🧘 emoji.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Message text |

**Return value:** 0.

**Output:** `🧘 ESPÍRITO! <message>` in bold magenta.

**Example:**
```zsh
yoga_espirito "Analysis complete"
```

---

### `yoga_sol`

**Signature:** `yoga_sol <message>`

**Description:** Print bold yellow warning/highlight message with ☀️ emoji.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Message text |

**Return value:** 0.

**Output:** `☀️ SOL! <message>` in bold yellow.

**Example:**
```zsh
yoga_sol "This action cannot be undone"
```

---

### `yoga_lua`

**Signature:** `yoga_lua <message>`

**Description:** Print white neutral/subtle message with 🌙 emoji.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Message text |

**Return value:** 0.

**Output:** `🌙 LUA! <message>` in white.

**Example:**
```zsh
yoga_lua "Skipping optional step"
```

---

### `yoga_fail`

**Signature:** `yoga_fail <message>`

**Description:** Legacy error function. Delegates to `yoga_fogo` with ✖ markers.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Message text |

**Return value:** 1 (delegates to `yoga_fogo`).

**Output:** `🔥 FOGO! ✖ <message> ✖` in bold red to stderr.

**Example:**
```zsh
yoga_fail "Database connection refused"
```

---

### `yoga_success`

**Signature:** `yoga_success <message>`

**Description:** Legacy success function. Delegates to `yoga_terra` with ✔ markers.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Message text |

**Return value:** 0.

**Output:** `🌿 TERRA! ✔ <message> ✔` in bold green.

**Example:**
```zsh
yoga_success "Deployment finished"
```

---

### `yoga_message`

**Signature:** `yoga_message <message>`

**Description:** General informational message. Delegates to `yoga_ar`.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Message text |

**Return value:** 0.

**Example:**
```zsh
yoga_message "Starting server on port 3000"
```

---

### `yoga_warn`

**Signature:** `yoga_warn <message>`

**Description:** Warning message. Delegates to `yoga_sol` with ⚠ markers.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Message text |

**Return value:** 0.

**Example:**
```zsh
yoga_warn "Low disk space"
```

---

### `yoga_action`

**Signature:** `yoga_action <label> <message>`

**Description:** Action progress indicator with bold yellow formatting.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Action label |
| `$2` | string | Yes | Action description |

**Return value:** 0.

**Output:** `==> [<label>] <message> ✔` in bold yellow.

**Example:**
```zsh
yoga_action "install" "Installing dependencies..."
# Output: ==> [install] Installing dependencies... ✔
```

---

### `yoga_readln`

**Signature:** `yoga_readln <prompt>`

**Description:** Display a prompt in cyan and read user input into the `answer` variable.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Prompt text |

**Return value:** 0.

**Side effects:** Sets the shell variable `answer` with user input.

**Example:**
```zsh
yoga_readln "Enter your name:"
echo "Hello, $answer"
```

---

### `yoga_flow`

**Signature:** `yoga_flow`

**Description:** Display a flow state activation message.

**Parameters:** None.

**Return value:** 0.

**Output:**
```
🌊 FLOW STATE ATIVADO!
🧘 Você está em sincronia com o código...
```

**Example:**
```zsh
yoga_flow
```

---

### `yoga_breath`

**Signature:** `yoga_breath [message]`

**Description:** Display a breathing/pause message with a 1-second sleep.

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `$1` | string | No | `"Respire fundo e mantenha o foco..."` | Custom message |

**Return value:** 0.

**Side effects:** Sleeps for 1 second (`sleep 1`).

**Example:**
```zsh
yoga_breath "Taking a moment..."
# Output: 🌬️ RESPIRAÇÃO: Taking a moment...
```

---

### `yoga_pose`

**Signature:** `yoga_pose [pose]`

**Description:** Display a yoga pose indicator message.

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `$1` | string | No | `"Warrior"` | Pose name |

**Return value:** 0.

**Example:**
```zsh
yoga_pose "Tree"
# Output: 🧘 POSE: Tree
```

---

### `yoga_meditation`

**Signature:** `yoga_meditation`

**Description:** Display a meditation sequence with three animated dots (each with 1-second delay).

**Parameters:** None.

**Return value:** 0.

**Side effects:** Sleeps for 3 seconds total (1 second per dot).

**Output:**
```
🧘 MEDITAÇÃO: Centrando energia...
...
✨ Pronto para continuar!
```

**Example:**
```zsh
yoga_meditation
```

---

### `yoga_progress`

**Signature:** `yoga_progress <current> <total>`

**Description:** Display a progress bar using `═` characters. Overwrites the current line.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | integer | Yes | Current progress value |
| `$2` | integer | Yes | Total value |

**Return value:** 0.

**Output format:** `Progress: [══════════░░░░░░░░░░░░░░░░] 40%`

**Example:**
```zsh
for i in {1..10}; do
    yoga_progress $i 10
    sleep 0.5
done
echo ""
```

---

### `yoga_status`

**Signature:** `yoga_status`

**Description:** Display a system status banner checking for Git, Node.js, Neovim, and ASDF.

**Parameters:** None.

**Return value:** 0.

**Output:** Decorated box containing check marks or crosses for each tool.

**Example:**
```zsh
yoga_status
# Output:
# ╔══════════════════════════════════╗
# ║    🧘 YOGA STATUS CHECK 🧘      ║
# ╚══════════════════════════════════╝
#
# ✔ Git instalado
# ✔ Node.js v20.11.0
# ✖ Neovim não encontrado
# ✔ ASDF instalado
```

---

### `yoga_interactive_menu`

**Signature:** `yoga_interactive_menu <title> <option1> <option2> ...`

**Description:** Display an interactive selection menu. Uses `gum` if available, falls back to `fzf`, or a basic numbered list with `read`.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Menu title (can be empty) |
| `$@` (remaining) | strings | Yes | Option strings to choose from |

**Return value:** Outputs the selected option string to stdout.

**Fallback chain:**
1. **gum** — TUI with cursor (`gum choose`)
2. **fzf** — Fuzzy finder with prompt
3. **read** — Numbered list with manual input

**Example:**
```zsh
result=$(yoga_interactive_menu "Choose environment" "development" "staging" "production")
echo "Selected: $result"
```

---

## core/utils/ui.sh

Extended UI functions with ANSI color codes and formatted output.

### Exported Variables

| Variable | Value | Description |
|----------|-------|-------------|
| `YOGA_COLOR_RESET` | `\033[0m` | Reset all formatting |
| `YOGA_COLOR_FOGO` | `\033[0;31m` | Red (regular weight) |
| `YOGA_COLOR_TERRA` | `\033[0;32m` | Green (regular weight) |
| `YOGA_COLOR_AGUA` | `\033[0;34m` | Blue (regular weight) |
| `YOGA_COLOR_AR` | `\033[0;36m` | Cyan (regular weight) |
| `YOGA_COLOR_ESPIRITO` | `\033[0;35m` | Magenta (regular weight) |
| `YOGA_COLOR_SOL` | `\033[0;33m` | Yellow (regular weight) |
| `YOGA_COLOR_LUA` | `\033[0;37m` | Light gray (regular weight) |
| `YOGA_COLOR_BOLD` | `\033[1m` | Bold modifier |

> Note: In `core/utils.sh`, the same color codes use bold variants (`\033[1;...m`), while `ui.sh` uses regular weight (`\033[0;...m`). The `ui.sh` versions also use `printf` instead of `echo -e` and write errors to stderr.

---

### `yoga_fogo` (ui.sh)

**Signature:** `yoga_fogo <message...>`

**Description:** Print red error message to stderr with 🔥 icon. Returns 1.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$@` | string | Yes | Message text (all args) |

**Return value:** 1.

**Output:** `🔥 ERRO: <message>` in red to stderr.

---

### `yoga_terra` (ui.sh)

**Signature:** `yoga_terra <message...>`

**Description:** Print green success message with ✅ icon.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$@` | string | Yes | Message text (all args) |

**Output:** `✅ <message>` in green.

---

### `yoga_agua` (ui.sh)

**Signature:** `yoga_agua <message...>`

**Description:** Print blue informational message with 💧 icon.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$@` | string | Yes | Message text (all args) |

**Output:** `💧 <message>` in blue.

---

### `yoga_ar` (ui.sh)

**Signature:** `yoga_ar <message...>`

**Description:** Print cyan warning message with ⚠️ icon.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$@` | string | Yes | Message text (all args) |

**Output:** `⚠️  <message>` in cyan.

---

### `yoga_espirito` (ui.sh)

**Signature:** `yoga_espirito <message...>`

**Description:** Print magenta debug/detail message with 👻 icon.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$@` | string | Yes | Message text (all args) |

**Output:** `👻 <message>` in magenta.

---

### `yoga_sol` (ui.sh)

**Signature:** `yoga_sol <message...>`

**Description:** Print yellow highlight message with ☀️ icon.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$@` | string | Yes | Message text (all args) |

**Output:** `☀️  <message>` in yellow.

---

### `yoga_lua` (ui.sh)

**Signature:** `yoga_lua <message...>`

**Description:** Print gray subtle message with 🌙 icon.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$@` | string | Yes | Message text (all args) |

**Output:** `🌙 <message>` in light gray.

---

### `yoga_header`

**Signature:** `yoga_header <title>`

**Description:** Print a decorated header banner with lines.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Header title text |

**Example:**
```zsh
yoga_header "Workspace Manager"
# Output:
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   🧘‍♂️  Workspace Manager
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### `yoga_section`

**Signature:** `yoga_section <title>`

**Description:** Print a section heading with underline.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Section title text |

**Example:**
```zsh
yoga_section "Dependencies"
# Output:
# ▶ Dependencies
# ────────────────────────────────────
```

---

### `yoga_loading`

**Signature:** `yoga_loading [message]`

**Description:** Print a loading/spinner message.

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `$1` | string | No | `"Processando..."` | Loading message |

**Output:** `⏳ <message>` in blue.

---

### `yoga_success`

**Signature:** `yoga_success <message...>`

**Description:** Print a celebration success message with 🎉 icon.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$@` | string | Yes | Message text (all args) |

**Output:** `🎉 <message>` in green.

---

### `yoga_error`

**Signature:** `yoga_error <message...>`

**Description:** Print an error message (without exiting) with 💥 icon to stderr.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$@` | string | Yes | Message text (all args) |

**Output:** `💥 <message>` in red to stderr.

> Note: Unlike `yoga_fogo`, this does NOT return 1. It's a non-fatal error display.

---

### `yoga_warning`

**Signature:** `yoga_warning <message...>`

**Description:** Print a warning message with ⚡ icon.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$@` | string | Yes | Message text (all args) |

**Output:** `⚡ <message>` in yellow.

---

### `yoga_info`

**Signature:** `yoga_info <message...>`

**Description:** Print a neutral informational message with ℹ️ icon.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$@` | string | Yes | Message text (all args) |

**Output:** `ℹ️  <message>` in blue.

---

### `yoga_debug`

**Signature:** `yoga_debug <message...>`

**Description:** Print a debug message (only when `YOGA_DEBUG=1`) with 🐛 icon.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$@` | string | Yes | Message text (all args) |

**Output:** `🐛 [DEBUG] <message>` in magenta (only if `YOGA_DEBUG=1`).

**Environment:** Only displays output when `YOGA_DEBUG` is set to `1`.

---

### `yoga_prompt`

**Signature:** `yoga_prompt <question>`

**Description:** Print a prompt question with ❓ icon. Does not read input (use `yoga_readln` or `read` for that).

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Question text |

**Output:** `❓ <question>` in yellow (no newline before input).

---

### `yoga_choice`

**Signature:** `yoga_choice <number> <text>`

**Description:** Print a numbered choice option.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Choice number |
| `$2` | string | Yes | Choice text |

**Output:** `  [<number>] <text>` with `[<number>]` in blue.

---

### `yoga_progress` (ui.sh)

**Signature:** `yoga_progress <current> <total> [message]`

**Description:** Print a progress counter. Note: this is a counter, not a bar (unlike `core/utils.sh` version).

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `$1` | integer | Yes | — | Current value |
| `$2` | integer | Yes | — | Total value |
| `$3` | string | No | `"Progresso"` | Label text |

**Output:** `📊 <message>: <current>/<total>` in blue.

> Note: There is a typo in the source (`YOGAGA_COLOR_RESET` instead of `YOGA_COLOR_RESET`) which may cause coloring issues.

---

### `yoga_tag`

**Signature:** `yoga_tag <color> <text>`

**Description:** Print a colored tag/label.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Color name or alias |
| `$2` | string | Yes | Tag text |

**Color aliases:**

| Alias | Color |
|-------|-------|
| `red`, `error`, `erro` | Red |
| `green`, `ok`, `success` | Green |
| `blue`, `info` | Blue |
| `yellow`, `warn` | Yellow |
| `purple`, `debug` | Magenta |
| *(any other)* | No color |

**Example:**
```zsh
yoga_tag "green" "PASSED"   # Output: [PASSED] in green
yoga_tag "red" "FAILED"     # Output: [FAILED] in red
yoga_tag "blue" "INFO"      # Output: [INFO] in blue
```

---

### `yoga_table_header`

**Signature:** `yoga_table_header <col1> <col2>`

**Description:** Print a two-column table header with separator line.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | First column header (20 chars wide) |
| `$2` | string | Yes | Second column header |

**Example:**
```zsh
yoga_table_header "Name" "Status"
# Output:
#   Name                 Status
# ────────────────────────────────────────────────
```

---

### `yoga_table_row`

**Signature:** `yoga_table_row <col1> <col2>`

**Description:** Print a two-column table row (20 chars for first column).

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | First column value |
| `$2` | string | Yes | Second column value |

---

### `yoga_clear_line`

**Signature:** `yoga_clear_line`

**Description:** Clear the current terminal line (for spinner/progress overwrites).

**Parameters:** None.

**Output:** `\r\033[K` (carriage return + clear to end of line).

---

### `yoga_spinner`

**Signature:** `yoga_spinner`

**Description:** Return the next moon-phase character for a spinner animation.

**Parameters:** None.

**Return value:** Single character from `🌑🌒🌓🌔🌕🌖🌗🌘` based on iteration.

**Usage pattern:**
```zsh
i=0
while true; do
    printf "\r%s Processando..." "$(yoga_spinner)"
    ((i++))
    sleep 0.1
done
```

> Note: Requires an external `$i` variable to track position (0-7 modulo 8).

---

### `yoga_emoji`

**Signature:** `yoga_emoji <category>`

**Description:** Return an emoji for a given category name.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Category name |

**Category mapping:**

| Category | Emoji |
|----------|-------|
| `daemon` | 👹 |
| `cc` | 🎯 |
| `workspace` | 🌌 |
| `ai` | 🤖 |
| `plugin` | 🔌 |
| `log` | 📝 |
| `state` | 💾 |
| `git` | 🌿 |
| `docker` | 🐳 |
| *(default)* | ✨ |

---

### `yoga_banner`

**Signature:** `yoga_banner`

**Description:** Print the Yoga 3.0 decorative banner.

**Parameters:** None.

**Output:**
```
    ╭──────────────────────────────────────╮
    │  🦜  YOGA 3.0 - Lôro Barizon Edition  │
    │     ✨ Engine de Desenvolvimento     │
    ╰──────────────────────────────────────╯
```

---

### `yoga_ui_init`

**Signature:** `yoga_ui_init`

**Description:** Initialize the UI system. Detects terminal color support and disables color codes if the terminal is dumb or not a TTY. Called automatically when `ui.sh` is sourced.

**Parameters:** None.

**Side effects:** Sets `YOGA_UI_COLORS=1` or `0`, and clears all `YOGA_COLOR_*` variables if colors are disabled.

**Auto-called:** This function is executed at source time.

---

## core/common.sh

Common helpers shared by Yoga scripts.

### `workspace_install`

**Signature:** `workspace_install [root]`

**Description:** Run all `install.sh` scripts found in `$root/core/**/install.sh`. Requires Zsh glob support (`globstar_short`).

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `$1` | string | No | `$YOGA_HOME` | Root directory to search |

**Return value:** Returns 1 if root not found or if not running Zsh (globstar requirement).

**Example:**
```zsh
workspace_install              # Uses $YOGA_HOME
workspace_install "/opt/yoga"  # Custom root
```

---

### `install_yoga`

**Signature:** `install_yoga`

**Description:** Install or update Yoga. If `$YOGA_HOME/.git` exists, runs `git pull --rebase`. Otherwise, clones the repository.

**Parameters:** None.

**Return value:** 0 on success.

**Example:**
```zsh
install_yoga
```

---

### `set_init_on_shell`

**Signature:** `set_init_on_shell`

**Description:** Add Yoga bootstrap lines to the user's shell RC file (`.zshrc` or `.bashrc`). Only adds if not already present.

**Parameters:** None.

**Side effects:** Appends to `$HOME/.zshrc` or `$HOME/.bashrc`:
```sh
# Yoga Files Integration
export YOGA_HOME="$HOME/.yoga"
export PATH="$YOGA_HOME/bin:$PATH"
source "$YOGA_HOME/init.sh"
```

**Example:**
```zsh
set_init_on_shell
```

---

## core/functions.sh

Utility functions for process management, SSH, Docker, and navigation.

### `pid_port`

**Signature:** `pid_port <port>`

**Description:** Find the PID(s) listening on a given port using `lsof`.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | integer | Yes | Port number (1-65535) |

**Return value:** Returns 1 if port is invalid or out of range. Outputs PID(s) to stdout.

**Validation:** Checks that input is numeric and within range 1-65535.

**Example:**
```zsh
pid_port 3000    # Output: 12345
pid_port 8080    # Output: 67890
pid_port abc     # Output: ⚠️ Invalid port number: abc (returns 1)
```

---

### `kill_port`

**Signature:** `kill_port <port>`

**Description:** Kill the process listening on a given port by first finding the PID with `pid_port`, then sending `kill -9`.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | integer | Yes | Port number (1-65535) |

**Return value:** Returns 1 if port is invalid. Returns 0 even if no process was found (kill is skipped silently).

**Example:**
```zsh
kill_port 3000   # Kills the process listening on port 3000
```

---

### `take`

**Signature:** `take <dir...>`

**Description:** Create a directory and `cd` into it. Supports nested creation.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$@` | string | Yes | One or more directory names |

**Return value:** Returns the exit code of `cd` into the last directory.

**Example:**
```zsh
take projects/my-app   # Creates and cds into projects/my-app
```

---

### `ssh_agent_run`

**Signature:** `ssh_agent_run [key...]`

**Description:** Start the SSH agent if not already running, and add the specified key(s) (or default keys) to the agent.

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `$@` | string | No | Default SSH keys | Key file(s) in `~/.ssh/` |

**Example:**
```zsh
ssh_agent_run                    # Starts agent, adds default key
ssh_agent_run id_ed25519         # Starts agent, adds specific key
```

---

### `please`

**Signature:** `please`

**Description:** Re-run the last command with `sudo`. Includes safety check to prevent running obviously dangerous commands.

**Parameters:** None.

**Safety:** Refuses to re-run commands matching the pattern `^(rm|dd|mkfs|>:)`.

**Example:**
```zsh
apt update        # Permission denied
please             # Runs: sudo apt update
```

---

### `docker_nukem`

**Signature:** `docker_nukem`

**Description:** Remove ALL Docker containers, images, volumes, and networks. This is extremely destructive.

**Parameters:** None.

**Side effects:** Stops and removes all Docker objects.

**Warning:** No confirmation prompt. See `docker_nukem_confirm` for a safer alternative.

---

### `docker_nukem_confirm`

**Signature:** `docker_nukem_confirm`

**Description:** Same as `docker_nukem` but requires the user to type `NUKE` to confirm.

**Parameters:** None.

**Example:**
```zsh
docker_nukem_confirm
# Output: This will stop/remove ALL docker containers/images/volumes/networks.
# Type 'NUKE' to proceed: _
```

---

### `echo_ip`

**Signature:** `echo_ip`

**Description:** Print the public IP address using `ipecho.net`.

**Parameters:** None.

**Example:**
```zsh
echo_ip   # Output: 203.0.113.42
```

---

### `dim_monitor_light`

**Signature:** `dim_monitor_light [monitor] [brightness]`

**Description:** Adjust monitor brightness using `xrandr`. Falls back to `HDMI-1-1` if no monitor is specified.

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `$1` | string | No | `HDMI-1-1` | Monitor name |
| `$1` | string | No | — | Brightness value (0.0-1.0) — note: this conflicts with the monitor param |

> Note: There is a bug in the source — `$1` is used for both monitor and brightness, and `$monitor` defaults to `HDMI-1-1` but isn't used with `$1` in the `xrandr` call properly when no argument is given.

**Example:**
```zsh
dim_monitor_light 0.5           # Set HDMI-1-1 brightness to 50%
dim_monitor_light DP-1 0.7     # Set DP-1 brightness to 70%
```

---

### `ls_process_by`

**Signature:** `ls_process_by [process_name]`

**Description:** List processes matching a name, or all user processes if no name given.

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `$1` | string | No | `$USER` | Process name or user to filter by |

**Example:**
```zsh
ls_process_by node       # List node processes
ls_process_by             # List current user processes
```

---

### `fzf_search`

**Signature:** `fzf_search [args...]`

**Description:** Interactive search using `fzf` with predefined options. Falls back to `grep` if `fzf` is not installed.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$@` | string | No | Arguments passed to fzf/grep |

**fzf options:** `--height=50% --ansi --tac --color=16 --border`

**Example:**
```zsh
fzf_search "pattern"
```

---

### `projects`

**Signature:** `projects`

**Description:** Interactive directory picker from `~/code/` using `fzf_search`. Changes into the selected directory.

**Parameters:** None.

**Prerequisites:** `~/code/` directory must exist.

---

### `gotodir`

**Signature:** `gotodir`

**Description:** Interactive directory stack navigation using `dirs -l` piped through `fzf_search`. Changes to the selected directory using `pushd`.

**Parameters:** None.

**Prerequisites:** `dirs` command must be available.

---

### `goto`

**Signature:** `goto`

**Description:** Interactive navigation menu offering `projects` or `gotodir` options through `fzf_search`.

**Parameters:** None.

**Example:**
```zsh
goto
# Shows fzf menu with: projects | gotodir
```

---

## core/aliases.sh

All shell aliases organized by category.

### Navigation

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `..` | `cd ..` | Up one directory |
| `...` | `cd ../..` | Up two directories |
| `....` | `cd ../../..` | Up three directories |
| `~` | `cd ~` | Home directory (Zsh only) |
| `-` | `cd -` | Previous directory (Zsh only) |

### Listing

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `l` | `ls -lah` | Detailed listing (all + human) |
| `la` | `ls -lAh` | Detailed listing (almost all) |
| `ll` | `ls -lh` | Long listing (human sizes) |
| `ls` | `ls -G` | Colored listing |
| `lsd` | `ls -lahF` | Detailed listing with type indicators |

### Git

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `g` | `git` | Git shorthand |
| `gs` | `git status` | Status |
| `gc` | `git commit` | Commit |
| `gca` | `git commit -a` | Commit all |
| `gcm` | `git commit -m` | Commit with message |
| `gp` | `git push` | Push |
| `gpl` | `git pull` | Pull |
| `gb` | `git branch` | Branch |
| `gco` | `git checkout` | Checkout |
| `gd` | `git diff` | Diff |
| `gl` | `git log --oneline --graph --decorate` | Short log |
| `gla` | `git log --oneline --graph --decorate --all` | Short log (all branches) |

### npm/Node.js

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `ni` | `npm install` | Install dependencies |
| `nid` | `npm install --save-dev` | Install dev dependency |
| `nig` | `npm install -g` | Install globally |
| `nr` | `npm run` | Run script |
| `nrd` | `npm run dev` | Run dev script |
| `nrb` | `npm run build` | Run build script |
| `nrt` | `npm run test` | Run tests |
| `nrs` | `npm run start` | Run start script |
| `nrw` | `npm run watch` | Run watch script |

### TypeScript

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `tsc` | `npx tsc` | TypeScript compiler |
| `tsx` | `npx tsx` | Run TypeScript |
| `tsw` | `npx tsc --watch` | Watch TypeScript |
| `tsinit` | `npx tsc --init` | Init TypeScript project |

### Development

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `dev` | `npm run dev` | Start dev server |
| `build` | `npm run build` | Build project |
| `test` | `npm run test` | Run tests |
| `lint` | `npm run lint` | Run linter |
| `format` | `npm run format` | Format code |
| `start` | `npm run start` | Start project |
| `watch` | `npm run watch` | Watch for changes |

### Yoga

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `yogi` | `yoga` | Yoga shorthand |
| `flow` | `yoga_flow` | Flow state message |
| `breathe` | `yoga_breath` | Breathing pause |
| `pose` | `yoga_pose` | Pose message |
| `namaste` | `echo "🧘 Namastê, yogi!"` | Greeting |
| `cheatsheet` | `bat/cat CHEATSHEET.md` | View cheatsheet |

### AI

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `ai` | `yoga-ai` | AI terminal |
| `yai` | `yoga-ai` | AI terminal (alt) |
| `ai-code` | `yoga-ai code` | AI code generation |
| `ai-help` | `yoga-ai help` | AI command help |
| `ai-fix` | `yoga-ai fix` | AI command fix |
| `ai-explain` | `yoga-ai explain` | AI explain |
| `ai-debug` | `yoga-ai debug` | AI debug |

### Editor

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `v` | `nvim` | Neovim shorthand |
| `vi` | `nvim` | Neovim shorthand |
| `vim` | `nvim` | Neovim shorthand |
| `nv` | `nvim` | Neovim shorthand |
| `code` | `nvim` | Neovim as "code" |

### ASDF

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `asdf-list` | `asdf list` | List versions |
| `asdf-current` | `asdf current` | Current versions |
| `asdf-global` | `asdf global` | Set global version |
| `asdf-local` | `asdf local` | Set local version |
| `asdf-install` | `asdf install` | Install version |
| `asdf-uninstall` | `asdf uninstall` | Uninstall version |
| `asdf-plugin` | `asdf plugin` | Manage plugins |
| `asdf-update` | `asdf update && asdf plugin update --all` | Update everything |

### System

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `reload` | `source ~/.zshrc` | Reload shell config |
| `zshrc` | `nvim ~/.zshrc` | Edit Zsh config |
| `yogarc` | `nvim ~/.yoga/config.yaml` | Edit Yoga config |
| `path` | `echo $PATH \| tr ":" "\n"` | Show PATH entries |
| `ports` | (function) | Show listening TCP ports |
| `top` | `htop` | Use htop instead of top |
| `df` | `df -h` | Human-readable disk free |
| `du` | `du -h` | Human-readable disk usage |
| `free` | `free -h` | Human-readable memory |

### Docker

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `d` | `docker` | Docker shorthand |
| `dc` | `docker-compose` | Compose shorthand |
| `dps` | `docker ps` | List running containers |
| `dpsa` | `docker ps -a` | List all containers |
| `di` | `docker images` | List images |
| `dex` | `docker exec -it` | Execute in container |
| `dlog` | `docker logs -f` | Follow container logs |
| `dstop` | `docker stop $(docker ps -q)` | Stop all containers |
| `drm` | `docker rm $(docker ps -aq)` | Remove all containers |
| `drmi` | `docker rmi $(docker images -q)` | Remove all images |

### Utilities

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `weather` | `curl wttr.in` | Weather report |
| `myip` | `curl ipecho.net/plain` | Public IP |
| `json` | `python -m json.tool` | Format JSON |
| `mkcd` | (function) | mkdir + cd |
| `extract` | (function) | tar extract |
| `search` | (function) | Recursive grep |
| `find-file` | (function) | find by name |
| `find-text` | (function) | grep by extension |
| `projects` | `cd ~/code` | Go to projects |
| `downloads` | `cd ~/Downloads` | Go to downloads |
| `desktop` | `cd ~/Desktop` | Go to desktop |
| `yoga-home` | `cd ~/.yoga` | Go to yoga home |

### Safety

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `rm` | `rm -i` | Interactive delete |
| `cp` | `cp -i` | Interactive copy |
| `mv` | `mv -i` | Interactive move |

### Clipboard (Linux)

On Linux, `pbcopy`/`pbpaste` are aliased to `xclip` or `xsel` if available:

| macOS | Linux (xclip) | Linux (xsel) |
|-------|--------------|--------------|
| `pbcopy` | `xclip -selection clipboard` | `xsel --clipboard --input` |
| `pbpaste` | `xclip -selection clipboard -o` | `xsel --clipboard --output` |

---

## core/shell/.custom.functions.sh

Shell functions for process management, RAG, and Command Center.

### `pid_port`

**Signature:** `pid_port <port>`

**Description:** Find PIDs listening on a port. Simpler version than `core/functions.sh` — no input validation.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | integer | Yes | Port number |

**Return value:** PIDs on stdout, or empty if none found.

---

### `kill_port`

**Signature:** `kill_port <port>`

**Description:** Kill the process on a port. Uses `pid_port` to find the PID.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | integer | Yes | Port number |

---

### `sshc`

**Signature:** `sshc [session]`

**Description:** Connect to a remote SSH server and attach/create a tmux session. Defaults to session name `work`.

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `$1` | string | No | `work` | tmux session name |

**Example:**
```zsh
sshc             # ssh ssh-casa "tmux new -As work"
sshc dev         # ssh ssh-casa "tmux new -As dev"
```

---

### `rag`

**Signature:** `rag [path]`

**Description:** Start the RAG server with a project path. Uses `~/rag-server/start.sh`.

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `$1` | string | No | `$(pwd)` | Path to project directory |

**Example:**
```zsh
rag                # Start RAG with current directory
rag /path/to/proj  # Start RAG with specific path
```

---

### `rag-reindex`

**Signature:** `rag-reindex`

**Description:** Trigger RAG re-indexing by sending a POST request to `http://localhost:8000/reindex`.

**Parameters:** None.

**Example:**
```zsh
rag-reindex
# Output: 🔄 Reindexando código... ✅ Reindexação concluída!
```

---

### `rag-stop`

**Signature:** `rag-stop`

**Description:** Stop the RAG server by killing the `python rag_server.py` process.

**Parameters:** None.

---

### `rag-check`

**Signature:** `rag-check`

**Description:** Check if the RAG server is running by querying `http://localhost:8000/info`.

**Parameters:** None.

---

### `aliases`

**Signature:** `aliases`

**Description:** Interactive alias and function browser using `fzf`. Lists all aliases and functions, allows selection and execution.

**Parameters:** None.

**Safety:** Validates the selection is a known function or alias before executing. Shows warning for potentially unsafe commands.

---

### `cc`

**Signature:** `cc`

**Description:** Interactive Command Center. Displays aliases, functions, git branches, docker containers, scripts, and history. Supports copy-to-clipboard (Ctrl+Y), edit in nvim (Ctrl+E), and execute (Enter/Ctrl+X).

**Parameters:** None.

**Key bindings:**

| Key | Action |
|-----|--------|
| Enter | Execute (with safety check) |
| Ctrl+Y | Copy command to clipboard |
| Ctrl+E | Open in nvim |
| Ctrl+X | Execute via `cc_action` |

---

### `cc_data`

**Signature:** `cc_data`

**Description:** Generate Command Center data from various sources: favorites file, shell aliases, Zsh functions, git branches, docker containers, executable scripts, and command history.

**Parameters:** None.

**Output format:** `TYPE|LABEL|COMMAND` (pipe-delimited).

---

### `cc_preview`

**Signature:** `cc_preview <selection>`

**Description:** Generate a preview for a Command Center entry based on its type.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Pipe-delimited entry: `type\|label\|cmd` |

---

### `cc_action`

**Signature:** `cc_action <type> <command>`

**Description:** Execute a Command Center action based on entry type.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Entry type: `BRANCH`, `DOCKER`, `SCRIPT`, other |
| `$2` | string | Yes | Command/identifier |

**Actions by type:**
- `BRANCH` → `git checkout <cmd>`
- `DOCKER` → `docker exec -it <cmd> sh`
- `SCRIPT` → `chmod +x <cmd> && <cmd>`
- Other → Safe execution check, then run

---

### `ccp`

**Signature:** `ccp`

**Description:** Project picker using `fd` and `fzf`. Selects a project from `~/code`, creates/attaches a tmux session named after the project.

**Parameters:** None.

**Prerequisites:** `fd`, `fzf`, `tmux`, `eza` (optional for preview).

---

## core/shell/.custom.export.sh

Exported environment variables.

| Variable | Value | Description |
|----------|-------|-------------|
| `PYENV_ROOT` | `$HOME/.pyenv` | pyenv root directory |
| `PATH` (prepend) | `$PYENV_ROOT/bin:$PATH` | pyenv binary path |
| `FZF_DEFAULT_OPTS` | (color theme) | fzf styling configuration |
| `PATH` (prepend) | `/Users/rodrigo.nascimento/.opencode/bin:$PATH` | OpenCode binary path |
| `GEMINI_API_KEY` | (set) | Google Gemini API key |
| `OLLAMA_HOST` | `0.0.0.0` | Ollama server bind address |
| `OLLAMA_API_KEY` | (empty) | Ollama API key |
| `PATH` (prepend) | `/opt/homebrew/opt/mysql-client/bin:$PATH` | MySQL client path |
| `NVM_DIR` | `$HOME/.nvm` | nvm directory |
| `LC_ALL` | `C` then `en_US.UTF-8` | Locale settings |
| `GIT_TERMINAL_PROMPT` | `0` | Disable git terminal prompts |
| `LANG` | `en_US.UTF-8` | Language setting |

---

## core/state/api.sh

See [state-management.md](state-management.md) for complete documentation of all 20+ functions including:

- `_yoga_state_init`, `_yoga_state_escape`, `_yoga_state_query`
- `yoga_state_set`, `yoga_state_get`, `yoga_state_del`, `yoga_state_list`, `yoga_state_clear`
- `yoga_workspace_create`, `yoga_workspace_activate`, `yoga_workspace_current`, `yoga_workspace_list`, `yoga_workspace_kill`
- `yoga_ai_context_add`, `yoga_ai_context_search`
- `yoga_plugin_register`, `yoga_plugin_enable`, `yoga_plugin_disable`, `yoga_plugin_list`
- `yoga_log_db`, `yoga_log_cleanup`

---

## core/daemon/client.sh

Unix socket client for the Yoga daemon.

### Configuration Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `YOGA_SOCKET` | `${YOGA_HOME}/daemon.sock` | Unix socket path |
| `DELIMITER` | `\x1E` (ASCII Record Separator) | Message delimiter |
| `TIMEOUT` | `5` | Connection timeout in seconds |

---

### `_yoga_client_send`

**Signature:** `_yoga_client_send <module> <command> [args_json]`

**Description:** Low-level socket communication function. Sends a pipe-delimited request to the daemon via `socat` or `nc`.

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `$1` | string | Yes | — | Module name |
| `$2` | string | Yes | — | Command name |
| `$3` | string | No | `{}` | Arguments as JSON |

**Request format:** `module|command|args_json|request_id`

**Response format:** `status|data|response_id`

**Return value:** Outputs the `data` field on success. Returns 1 if connection fails or daemon returns an error.

**Connection order:** Tries `socat` first, falls back to `nc` (netcat).

---

### `yoga_client_state_get`

**Signature:** `yoga_client_state_get <key> [scope]`

**Description:** Get a state value via the daemon.

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `$1` | string | Yes | — | State key |
| `$2` | string | No | `global` | Scope |

---

### `yoga_client_state_set`

**Signature:** `yoga_client_state_set <key> <value> [scope]`

**Description:** Set a state value via the daemon.

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `$1` | string | Yes | — | State key |
| `$2` | string | Yes | — | State value |
| `$3` | string | No | `global` | Scope |

---

### `yoga_client_workspace_list`

**Signature:** `yoga_client_workspace_list`

**Description:** List workspaces via the daemon.

**Parameters:** None.

---

### `yoga_client_workspace_create`

**Signature:** `yoga_client_workspace_create <name> <path>`

**Description:** Create a workspace via the daemon.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Workspace name |
| `$2` | string | Yes | Workspace path |

---

### `yoga_client_workspace_activate`

**Signature:** `yoga_client_workspace_activate <id>`

**Description:** Activate a workspace via the daemon.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Workspace ID |

---

### `yoga_client_cc_data`

**Signature:** `yoga_client_cc_data`

**Description:** Get Command Center data via the daemon.

**Parameters:** None.

---

### `yoga_client_ai_ask`

**Signature:** `yoga_client_ai_ask <question>`

**Description:** Ask the AI a question via the daemon.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Question text |

---

### `yoga_client_log_write`

**Signature:** `yoga_client_log_write <level> <module> <message>`

**Description:** Write a log entry via the daemon.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `$1` | string | Yes | Log level |
| `$2` | string | Yes | Module name |
| `$3` | string | Yes | Log message |

---

### `yoga_client_plugin_list`

**Signature:** `yoga_client_plugin_list`

**Description:** List plugins via the daemon.

**Parameters:** None.

---

### `yoga_client_daemon_ping`

**Signature:** `yoga_client_daemon_ping`

**Description:** Ping the daemon to check if it's running.

**Parameters:** None.

---

### `yoga_client_daemon_stop`

**Signature:** `yoga_client_daemon_stop`

**Description:** Request the daemon to stop.

**Parameters:** None.