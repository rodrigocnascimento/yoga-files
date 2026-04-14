# LazyVim Plugin Reference

Complete reference for all plugins configured in the Yoga Files LazyVim setup. Each plugin is documented with its source, purpose, configuration, keymaps, and dependencies.

---

## Table of Contents

- [Core](#core)
- [LSP / Completion](#lsp--completion)
- [Debug](#debug)
- [Git](#git)
- [AI](#ai)
- [UI](#ui)
- [HTTP / Database](#http--database)
- [Code Navigation](#code-navigation)
- [Formatting / Linting](#formatting--linting)
- [Session](#session)
- [File / Search](#file--search)

---

## Core

### LazyVim

| Field | Value |
|-------|-------|
| **Plugin** | `LazyVim/LazyVim` |
| **Source** | LazyVim extra (built-in) |
| **GitHub** | https://github.com/LazyVim/LazyVim |
| **Purpose** | Base Neovim distribution providing sensible defaults for LSP, completion, formatting, git, and editing |
| **Config** | `lua/config/lazy.lua` |

**Configuration** (`lua/config/lazy.lua`):

| Setting | Value | Description |
|---------|-------|-------------|
| `lazy` | `false` | Custom plugins load during startup |
| `version` | `false` | Always use latest git commit (no versioning) |
| `checker.enabled` | `true` | Check for plugin updates periodically |
| `checker.notify` | `false` | Don't notify on updates |
| `disabled_plugins` | `gzip, tarPlugin, tohtml, tutor, zipPlugin` | Disabled RTP plugins for performance |

**Dependencies**: None (is the base)

---

### lazy.nvim

| Field | Value |
|-------|-------|
| **Plugin** | `folke/lazy.nvim` |
| **Source** | Bootstrap (managed separately) |
| **GitHub** | https://github.com/folke/lazy.nvim |
| **Purpose** | Plugin manager for Neovim, handles install, update, and lazy-loading of all plugins |
| **Config** | `lua/config/lazy.lua` (bootstrap) |

**Commands**:

| Command | Description |
|---------|-------------|
| `:Lazy` | Open Lazy dashboard |
| `:Lazy sync` | Sync (install/update/clean) plugins |
| `:Lazy health` | Check plugin health |
| `:Lazy log` | View plugin operation log |

---

## LSP / Completion

### Mason

| Field | Value |
|-------|-------|
| **Plugin** | `mason-org/mason.nvim` |
| **Source** | Custom (`lua/plugins/yoga-js.lua`) |
| **GitHub** | https://github.com/mason-org/mason.nvim |
| **Purpose** | Portable package manager for LSP servers, DAP adapters, linters, and formatters |
| **Config** | `lua/plugins/yoga-js.lua` |

**ensure_installed list**:

| Package | Type | Purpose |
|---------|------|---------|
| `typescript-language-server` | LSP | TypeScript/JavaScript language server |
| `biome` | Formatter/Linter | JS/TS/JSON formatter and linter |

> **Note**: The `js-debug-adapter` Mason package is installed by `dap-vscode.lua` (via debugger_path), not via Mason's ensure_installed. However, it's also listed in the README as a recommended manual install.

---

### nvim-lspconfig

| Field | Value |
|-------|-------|
| **Plugin** | `neovim/nvim-lspconfig` |
| **Source** | LazyVim extra (built-in) |
| **GitHub** | https://github.com/neovim/nvim-lspconfig |
| **Purpose** | Quickstart configurations for the Neovim LSP client |
| **Config** | LazyVim defaults + Mason integration |

**Configured LSP servers** (via Mason auto-install):

| Server | Filetypes | Purpose |
|--------|-----------|---------|
| `ts_ls` (typescript-language-server) | JS, TS, JSX, TSX | TypeScript/JavaScript language support |
| `biome` | JS, TS, JSX, TSX, JSON | Formatting and linting |

---

### nvim-cmp

| Field | Value |
|-------|-------|
| **Plugin** | `hrsh7th/nvim-cmp` |
| **Source** | LazyVim extra (built-in) |
| **GitHub** | https://github.com/hrsh7th/nvim-cmp |
| **Purpose** | Auto-completion engine for Neovim |
| **Config** | LazyVim defaults |

**Completion sources** (LazyVim default): luasnip, nvim-lsp, buffer, path, nvim-cmp.

---

### nvim-treesitter

| Field | Value |
|-------|-------|
| **Plugin** | `nvim-treesitter/nvim-treesitter` |
| **Source** | LazyVim extra (built-in) |
| **GitHub** | https://github.com/nvim-treesitter/nvim-treesitter |
| **Purpose** | Syntax highlighting, incremental selection, and text objects based on tree-sitter |
| **Config** | LazyVim defaults (auto-installs parsers for common languages) |

---

## Debug

### nvim-dap

| Field | Value |
|-------|-------|
| **Plugin** | `mfussenegger/nvim-dap` |
| **Source** | Custom (`lua/plugins/dap-vscode.lua`) |
| **GitHub** | https://github.com/mfussenegger/nvim-dap |
| **Purpose** | Debug Adapter Protocol client for Neovim, enabling step-through debugging |
| **Config** | `lua/plugins/dap-vscode.lua` |

**Keymaps**: See [Keymaps - Debug](./keymaps.md#debug-dap)

**Dependencies**:

| Plugin | Purpose |
|--------|---------|
| `rcarriga/nvim-dap-ui` | Visual UI for debugging (scopes, watch, stack trace, breakpoints) |
| `theHamsta/nvim-dap-virtual-text` | Show variable values inline during debug |
| `mxsdev/nvim-dap-vscode-js` | VS Code JS debug adapter (pwa-node) |

**Configuration** (`lua/plugins/dap-vscode.lua`):

| Setting | Value | Description |
|---------|-------|-------------|
| `node_path` | `"node"` | Path to Node.js binary |
| `debugger_path` | `mason/packages/js-debug-adapter` | Mason-installed debugger path |
| `adapters` | `pwa-node, node-terminal, node` | Supported adapter types |
| `log_file_path` | `cache/dap_vscode_js.log` | Debug log file location |
| `log_file_level` | `ERROR` | Only errors logged to file |
| `log_console_level` | `ERROR` | Only errors logged to console |

**Registered file types**: `typescript`, `javascript`, `typescriptreact`, `javascriptreact`

---

### nvim-dap-ui

| Field | Value |
|-------|-------|
| **Plugin** | `rcarriga/nvim-dap-ui` |
| **Source** | Dependency of nvim-dap |
| **GitHub** | https://github.com/rcarriga/nvim-dap-ui |
| **Purpose** | Visual debug UI that auto-opens on debug session start and auto-closes on termination |

**Auto-behavior**:

| Event | Action |
|-------|--------|
| `event_initialized` | `dapui.open()` |
| `event_terminated` | `dapui.close()` |
| `event_exited` | `dapui.close()` |

---

### nvim-dap-vscode-js

| Field | Value |
|-------|-------|
| **Plugin** | `mxsdev/nvim-dap-vscode-js` |
| **Source** | Dependency of nvim-dap |
| **GitHub** | https://github.com/mxsdev/nvim-dap-vscode-js |
| **Purpose** | Provides `pwa-node` DAP adapter for modern JS/TS debugging and VS Code `launch.json` compatibility |

**Type-to-filetype mapping**:

```lua
require("dap.ext.vscode").type_to_filetypes = {
  ["pwa-node"] = js_languages,
  ["node"] = js_languages,
}
```

---

### nvim-dap-virtual-text

| Field | Value |
|-------|-------|
| **Plugin** | `theHamsta/nvim-dap-virtual-text` |
| **Source** | Dependency of nvim-dap |
| **GitHub** | https://github.com/theHamsta/nvim-dap-virtual-text |
| **Purpose** | Displays variable values as virtual text inline during debug sessions |

---

### dadbod node2 adapter (legacy)

| Field | Value |
|-------|-------|
| **Plugin** | Config in `lua/config/dap-node.lua` |
| **Source** | Custom (legacy) |
| **Purpose** | Deprecated node2 DAP adapter using attach mode on port 9229 |
| **Status** | Superseded by `dap-vscode.lua` (pwa-node adapter) |

**Config**: Attach mode, port 9229, inspector protocol, skipFiles `<node_internals>/**`.

---

## Git

### diffview.nvim

| Field | Value |
|-------|-------|
| **Plugin** | `sindrets/diffview.nvim` |
| **Source** | Custom (`lua/plugins/diffview.lua`) |
| **GitHub** | https://github.com/sindrets/diffview.nvim |
| **Purpose** | Full-featured git diff viewer with file list and hunk navigation, similar to a PR review UI |
| **Config** | `lua/plugins/diffview.lua` |
| **Load** | Lazy-loaded on commands: `DiffviewOpen`, `DiffviewClose`, `DiffviewFileHistory` |

**Keymaps**:

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>gd` | `:DiffviewOpen` | Open diff view |
| `<leader>gD` | `:DiffviewClose` | Close diff view |
| `<leader>gh` | `:DiffviewFileHistory %` | File history for current file |

**Dependencies**: `nvim-lua/plenary.nvim`

---

### LazyVim Git (built-in)

| Feature | Description |
|---------|-------------|
| `gitsigns.nvim` | Git signs in sign column, hunk navigation, blame line |
| `lazygit` | Terminal git UI (`<leader>gg`) |
| `neogit` | Magit-like git interface |
| `fugitive` | Git commands in Vim |

---

## AI

### CodeCompanion

| Field | Value |
|-------|-------|
| **Plugin** | `olimorris/codecompanion.nvim` |
| **Source** | Custom (`lua/plugins/codecompanion.lua`) |
| **GitHub** | https://github.com/olimorris/codecompanion.nvim |
| **Purpose** | Multi-provider AI chat and inline actions for Neovim, supporting Gemini and Ollama backends |
| **Config** | `lua/plugins/codecompanion.lua` |

**Configuration**:

| Setting | Value | Description |
|---------|-------|-------------|
| `strategies.chat.adapter` | `"gemini"` | Default chat adapter |
| `strategies.inline.adapter` | `"gemini"` | Default inline adapter |
| `adapters.ollama.model` | `qwen2.5-coder:7b-instruct-q5_K_M` | Ollama model |
| `adapters.gemini.model` | `gemini-3-pro` | Gemini model |

**Keymaps**:

| Key | Mode | Action |
|-----|------|--------|
| `<leader>cg` | n, v | Open chat with Gemini |
| `<leader>co` | n, v | Open chat with Ollama |
| `<leader>cc` | n, v | Toggle last chat |
| `<leader>ca` | n, v | Open actions menu |

**Dependencies**: `nvim-lua/plenary.nvim`, `nvim-treesitter/nvim-treesitter`, `nvim-telescope/telescope.nvim`

---

### Supermaven

| Field | Value |
|-------|-------|
| **Plugin** | `supermaven-inc/supermaven-nvim` |
| **Source** | Custom (`lua/plugins/supermaven.lua`) |
| **GitHub** | https://github.com/supermaven-inc/supermaven-nvim |
| **Purpose** | AI-powered inline code completion with low latency, similar to GitHub Copilot but using Supermaven's models |

**Keymaps**:

| Key | Mode | Action |
|-----|------|--------|
| `<Tab>` | Insert | Accept full suggestion |
| `<C-]>` | Insert | Clear current suggestion |
| `<C-j>` | Insert | Accept one word |

**Dependencies**: None

---

### yoga-ai

| Field | Value |
|-------|-------|
| **Plugin** | `LazyVim/LazyVim` (key maps only) |
| **Source** | Custom (`lua/plugins/yoga-ai.lua`) |
| **Purpose** | Terminal-based AI integration using `yoga-ai` CLI for help, fix, and code generation commands |
| **Config** | `lua/plugins/yoga-ai.lua` |

**Keymaps**:

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ah` | n | `yoga-ai help <input>` — prompts for input, opens in terminal |
| `<leader>af` | n | `yoga-ai fix <input>` — prompts for input, opens in terminal |
| `<leader>ac` | n | `yoga-ai code <input>` — prompts for input, opens in terminal |

**How it works**: Each keymap calls `vim.fn.input()` for user input, then runs `vim.fn.termopen({"yoga-ai", mode, input})` to execute in a terminal buffer.

**Dependencies**: `yoga-ai` CLI must be available in `$PATH`

---

## UI

### gruvbox-material

| Field | Value |
|-------|-------|
| **Plugin** | `sainnhe/gruvbox-material` |
| **Source** | Custom (`lua/plugins/colorscheme.lua`) |
| **GitHub** | https://github.com/sainnhe/gruvbox-material |
| **Purpose** | Gruvbox Material colorscheme with hard background and material foreground |
| **Config** | `lua/plugins/colorscheme.lua` |

**Configuration**:

| Setting | Value | Description |
|---------|-------|-------------|
| `background` | `"hard"` | Background contrast (soft/medium/hard) |
| `foreground` | `"material"` | Foreground palette (material/mix/original) |
| `better_performance` | `1` | Enable performance optimization |
| `priority` | `1000` | Load colorscheme early |

---

### lualine.nvim

| Field | Value |
|-------|-------|
| **Plugin** | `nvim-lualine/lualine.nvim` |
| **Source** | Custom (`lua/plugins/lualine.lua`) |
| **GitHub** | https://github.com/nvim-lualine/lualine.nvim |
| **Purpose** | Fast and extensible status line with smart git branch truncation |
| **Config** | `lua/plugins/lualine.lua` |

**Configuration**:

| Section | Component | Behavior |
|---------|-----------|----------|
| `lualine_b` | `branch` | Shows git branch, truncated to 20 chars with `..` suffix if longer |

**Branch truncation logic**: If branch name > 20 characters, show first 20 chars + `..`.

---

### render-markdown (LazyVim extra)

| Field | Value |
|-------|-------|
| **Plugin** | LazyVim markdown extra |
| **Source** | LazyVim extra (`lua/config/render-markdown.lua`) |
| **Purpose** | Better markdown rendering in Neovim, imported via `lazyvim.plugins.extras.lang.markdown` |

**Config**: `lua/config/render-markdown.lua` (imports the LazyVim markdown extra)

---

## HTTP / Database

### kulala.nvim

| Field | Value |
|-------|-------|
| **Plugin** | `mistweaverco/kulala.nvim` |
| **Source** | Custom (`lua/plugins/kulala.lua`) |
| **GitHub** | https://github.com/mistweaverco/kulala.nvim |
| **Purpose** | HTTP REST client for Neovim, supporting `.http` and `.rest` files with environments, cURL conversion, and request inspection |
| **Config** | `lua/plugins/kulala.lua` |
| **File types** | `http`, `rest` |

**Configuration**:

| Setting | Value | Description |
|---------|-------|-------------|
| `global_keymaps` | `true` | Enable global keymaps |
| `global_keymaps_prefix` | `<leader>R` | Keymap prefix |
| `default_env` | `"dev"` | Default environment |
| `vscode_rest_client_environmentvars` | `true` | Import VS Code rest-client env vars |
| `request_timeout` | `nil` | No timeout |
| `infer_content_type` | `true` | Auto-detect content type |

**Keymaps**: See [Keymaps - HTTP](./keymaps.md#http-kulala)

**Cheatsheet**: `<leader>Kh` opens an interactive cheatsheet (`lua/kulala_cheatsheet.lua`)

**Dependencies**: `nvim-lua/plenary.nvim`

---

### vim-dadbod

| Field | Value |
|-------|-------|
| **Plugin** | `tpope/vim-dadbod` |
| **Source** | Custom (`lua/plugins/dadbod.lua`) |
| **GitHub** | https://github.com/tpope/vim-dadbod |
| **Purpose** | Database client for Neovim, supporting MySQL, PostgreSQL, SQLite, and more |
| **Config** | `lua/plugins/dadbod.lua` |

**Keymaps**: See [Keymaps - Database](./keymaps.md#database-dadbod)

**Configuration**:

| Setting | Value | Description |
|---------|-------|-------------|
| `db_ui_use_nerd_fonts` | `1` | Use Nerd Font icons in UI |
| `db_ui_show_database_icon` | `1` | Show database type icon |

**Dependencies**:

| Plugin | Purpose |
|--------|---------|
| `kristijanhusak/vim-dadbod-ui` | Visual UI for dadbod |
| `kristijanhusak/vim-dadbod-completion` | Auto-completion for SQL queries |

**Pre-configured connections**: HOMOLOG (MySQL) and PROD (MySQL Read Replica). See Security Warning in keymaps doc.

---

## Code Navigation

### aerial.nvim

| Field | Value |
|-------|-------|
| **Plugin** | `stevearc/aerial.nvim` |
| **Source** | Custom (`lua/plugins/aerial.lua`) |
| **GitHub** | https://github.com/stevearc/aerial.nvim |
| **Purpose** | Code outline and symbol navigation with sidebar and floating window modes |
| **Config** | `lua/plugins/aerial.lua` |
| **Load** | `LazyFile` event |

**Configuration**:

| Setting | Value | Description |
|---------|-------|-------------|
| `backends` | `treesitter, lsp, markdown, man` | Backend priority |
| `layout.min_width` | `28` | Minimum sidebar width |
| `layout.default_direction` | `"right"` | Open sidebar to right |
| `layout.placement` | `"window"` | Place in window |
| `show_guides` | `true` | Show guide markers |
| `filter_kind` | `false` | Show all symbol kinds |

**Keymaps**:

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>cs` | `:AerialToggle!` | Toggle sidebar outline |
| `<leader>ca` | `:AerialNavToggle` | Toggle floating navigation |
| `[[` | `:AerialPrev` | Previous symbol |
| `]]` | `:AerialNext` | Next symbol |

---

## Formatting / Linting

### conform.nvim

| Field | Value |
|-------|-------|
| **Plugin** | `stevearc/conform.nvim` |
| **Source** | Custom (`lua/plugins/yoga-js.lua` + `lua/plugins/formatting.lua`) |
| **GitHub** | https://github.com/stevearc/conform.nvim |
| **Purpose** | Format-on-save and manual formatting with multiple formatters per filetype |
| **Config** | `lua/plugins/yoga-js.lua` (biome) + `lua/plugins/formatting.lua` (prettier) |

**Formatters by filetype** (merged from both files):

| Filetype | Formatter(s) | Source |
|----------|-------------|--------|
| `javascript` | `biome`, `prettier` | yoga-js.lua + formatting.lua |
| `typescript` | `biome`, `prettier` | yoga-js.lua + formatting.lua |
| `javascriptreact` | `biome`, `prettier` | yoga-js.lua + formatting.lua |
| `typescriptreact` | `biome`, `prettier` | yoga-js.lua + formatting.lua |
| `json` | `biome`, `prettier` | yoga-js.lua + formatting.lua |
| `html` | `prettier` | formatting.lua |

> **Note**: When multiple formatters are listed, conform.nvim runs them in order. The first available formatter takes priority.

---

### SonarLint

| Field | Value |
|-------|-------|
| **Plugin** | `sonarlint.nvim` |
| **Source** | Custom (`lua/plugins/sonarlint.lua`) |
| **GitHub** | https://gitlab.com/schrieveslaach/sonarlint.nvim |
| **Purpose** | SonarLint linter integration for TypeScript, JavaScript, and Dockerfile |
| **Config** | `lua/plugins/sonarlint.lua` |
| **File types** | `typescript`, `javascript`, `dockerfile` |

**Configuration**:

| Setting | Value | Description |
|---------|-------|-------------|
| `server.cmd` | `sonarlint-language-server -stdio` | Server command |
| `analyzers` | `sonarts.jar`, `sonarjs.jar`, `sonariac.jar` | SonarLint analyzer JARs from Mason |

**Dependencies**: `neovim/nvim-lspconfig`

---

## Session

### vim-obsession

| Field | Value |
|-------|-------|
| **Plugin** | `tpope/vim-obsession` |
| **Source** | Custom (`lua/plugins/obsession.lua`) |
| **GitHub** | https://github.com/tpope/vim-obsession |
| **Purpose** | Automatic session persistence — saves your open buffers, windows, and layout |
| **Config** | Default (no custom config) |
| **Load** | `VeryLazy` |

**Commands**:

| Command | Description |
|---------|-------------|
| `:Obsess` | Start session recording |
| `:Obsess!` | Stop session recording |
| `:SaveSession` | Save current session |

---

## File / Search

### telescope.nvim

| Field | Value |
|-------|-------|
| **Plugin** | `nvim-telescope/telescope.nvim` |
| **Source** | LazyVim extra (extended in `lua/plugins/telescope.lua`) |
| **GitHub** | https://github.com/nvim-telescope/telescope.nvim |
| **Purpose** | Fuzzy finder for files, text, buffers, git, LSP, and more |
| **Config** | `lua/plugins/telescope.lua` |

**Yoga Files customizations**:

| Setting | Value | Description |
|---------|-------|-------------|
| `find_files.hidden` | `true` | Include hidden/dot files in search |
| `find_files.file_ignore_patterns` | `{".git/"}` | Exclude `.git/` directory |
| `vimgrep_arguments` | includes `--hidden`, `--glob !**/.git/*` | Search hidden files but exclude .git |

**Keymaps**: See [Keymaps - Search](./keymaps.md#search-telescope)

**Dependencies**: `nvim-lua/plenary.nvim`, `nvim-telescope/telescope-fzf-native.nvim` (via LazyVim)

---

## Plugin Load Order Reference

| Plugin | Load Event | Config File |
|--------|-----------|-------------|
| `LazyVim` | Startup | `lua/config/lazy.lua` |
| `gruvbox-material` | Startup (`lazy=false`, `priority=1000`) | `lua/plugins/colorscheme.lua` |
| `telescope` | LazyVim default | `lua/plugins/telescope.lua` |
| `aerial` | `LazyFile` | `lua/plugins/aerial.lua` |
| `codecompanion` | Lazy (default) | `lua/plugins/codecompanion.lua` |
| `dadbod` | Lazy (key-triggered) | `lua/plugins/dadbod.lua` |
| `dap-vscode` | Lazy (default) | `lua/plugins/dap-vscode.lua` |
| `diffview` | `cmd` (command-triggered) | `lua/plugins/diffview.lua` |
| `kulala` | `ft` (filetype-triggered) | `lua/plugins/kulala.lua` |
| `lualine` | `VeryLazy` | `lua/plugins/lualine.lua` |
| `obsession` | `VeryLazy` | `lua/plugins/obsession.lua` |
| `sonarlint` | `ft` (filetype-triggered) | `lua/plugins/sonarlint.lua` |
| `supermaven` | Lazy (default) | `lua/plugins/supermaven.lua` |
| `yoga-ai` | Lazy (key-triggered) | `lua/plugins/yoga-ai.lua` |
| `yoga-js` | Lazy (via Mason) | `lua/plugins/yoga-js.lua` |
| `formatting` | Lazy (via conform.nvim) | `lua/plugins/formatting.lua` |

---

## Plugin File to Category Mapping

| Config File | Category | Plugins |
|-------------|----------|---------|
| `aerial.lua` | Code Navigation | aerial.nvim |
| `codecompanion.lua` | AI | codecompanion.nvim |
| `colorscheme.lua` | UI | gruvbox-material |
| `dadbod.lua` | HTTP/Database | vim-dadbod, vim-dadbod-ui, vim-dadbod-completion |
| `dap-vscode.lua` | Debug | nvim-dap, nvim-dap-ui, nvim-dap-virtual-text, nvim-dap-vscode-js |
| `diffview.lua` | Git | diffview.nvim |
| `formatting.lua` | Formatting | conform.nvim (prettier additions) |
| `kulala.lua` | HTTP/Database | kulala.nvim |
| `lualine.lua` | UI | lualine.nvim |
| `obsession.lua` | Session | vim-obsession |
| `sonarlint.lua` | Linting | sonarlint.nvim |
| `supermaven.lua` | AI | supermaven-nvim |
| `telescope.lua` | Search | telescope.nvim |
| `yoga-ai.lua` | AI | LazyVim (keymaps for yoga-ai CLI) |
| `yoga-js.lua` | LSP/Formatting | mason.nvim, conform.nvim (biome) |