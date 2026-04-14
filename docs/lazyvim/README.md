# Yoga 3.0 — LazyVim Configuration

Welcome to the Yoga Files LazyVim configuration. This is a pre-configured Neovim setup built on top of [LazyVim](https://www.lazyvim.org/) with curated plugins for JavaScript/TypeScript development, AI-assisted coding, debugging, REST clients, database access, and more.

## Table of Contents

- [Overview](#overview)
- [Directory Structure](#directory-structure)
- [Installation](#installation)
- [Key Features](#key-features)
- [How to Customize](#how-to-customize)
- [Documentation Index](#documentation-index)

## Overview

Yoga Files ships a LazyVim starter configuration extended with custom plugins organized in `lua/plugins/*.lua`. The base LazyVim install provides sensible defaults for LSP, completion, formatting, git integration, and general editing. The custom plugins layer adds:

- **JS/TS debugging** via `pwa-node` adapter and VS Code `launch.json` support
- **AI integration** via yoga-ai CLI, Supermaven, CodeCompanion (Gemini/Ollama), and GitHub Copilot
- **REST client** via kulala.nvim for `.http` files
- **Database client** via vim-dadbod with UI
- **Code outline** via aerial.nvim
- **Diff review** via diffview.nvim
- **Linting** via sonarlint.nvim
- **Colorscheme**: gruvbox-material (hard background)
- **Session persistence** via vim-obsession
- **Custom statusline** via lualine with smart branch truncation
- **Telescope** configured for hidden file search (dotfiles)
- **Biome** as the default formatter for JS/TS/JSON

## Directory Structure

```
editor/nvim/
├── init.lua                          # Entry point — bootstraps lazy.nvim
├── lua/
│   ├── config/
│   │   ├── lazy.lua                  # lazy.nvim bootstrap + LazyVim setup
│   │   ├── options.lua               # vim.g.autoformat = true
│   │   ├── keymaps.lua               # Custom keymaps (DAP, kulala, CodeCompanion, etc.)
│   │   └── dap-node.lua              # Legacy node2 DAP adapter (attach mode)
│   └── plugins/
│       ├── aerial.lua                # Code outline/navigation
│       ├── codecompanion.lua         # AI chat (Gemini, Ollama)
│       ├── colorscheme.lua           # gruvbox-material theme
│       ├── dadbod.lua               # Database client
│       ├── dap-vscode.lua            # DAP + VS Code launch.json hybrid
│       ├── diffview.lua              # Git diff viewer
│       ├── example.lua               # Example plugin spec (disabled)
│       ├── formatting.lua            # conform.nvim (prettier)
│       ├── kulala.lua                # HTTP REST client
│       ├── lualine.lua               # Statusline customization
│       ├── obsession.lua             # Session management
│       ├── sonarlint.lua             # SonarLint linter
│       ├── supermaven.lua            # AI code completion
│       ├── telescope.lua             # Telescope customization (hidden files)
│       ├── yoga-ai.lua               # Terminal AI CLI integration
│       └── yoga-js.lua               # Mason + conform for JS/TS (biome)
└── stylua.toml                       # (if present) StyLua config
```

### File Responsibilities

| File | Purpose |
|------|---------|
| `init.lua` | Entry point. Calls `require("config.lazy")` to bootstrap everything. |
| `lua/config/lazy.lua` | Bootstraps lazy.nvim, configures plugin spec (LazyVim + custom), sets defaults, checker, disabled rtp plugins. |
| `lua/config/options.lua` | Sets `vim.g.autoformat = true`. Extends LazyVim defaults. |
| `lua/config/keymaps.lua` | All custom keymaps: CodeCompanion, kulala, DAP, branch display. Loaded on `VeryLazy`. |
| `lua/config/dap-node.lua` | Legacy node2 DAP adapter. Attach mode on port 9229. Superseded by `dap-vscode.lua`. |
| `lua/plugins/*.lua` | Each file is a lazy.nvim plugin spec. Loaded automatically by lazy.nvim's `{ import = "plugins" }`. |

## Installation

The Yoga Files installer handles Neovim setup automatically:

```bash
./bin/yoga install
```

This script:

1. Clones or updates lazy.nvim to `~/.local/share/nvim/lazy/lazy.nvim`
2. Copies the `editor/nvim/` directory to `~/.config/nvim/`
3. Launches Neovim to trigger lazy.nvim's first-run plugin install

### Manual Installation

If you prefer to set up manually:

```bash
# 1. Copy config
cp -r editor/nvim ~/.config/nvim

# 2. Launch neovim (lazy.nvim will bootstrap and install plugins)
nvim

# 3. Install Mason tools
:Mason
# Then install: typescript-language-server, biome, js-debug-adapter, sonarlint-language-server
```

### Post-Install

After first launch, run health checks:

```vim
:checkhealth lazy
:checkhealth mason
:checkhealth dap
```

## Key Features

### JavaScript/TypeScript Development

- **LSP**: typescript-language-server via Mason (auto-installed)
- **Formatting**: Biome for JS/TS/JSON, Prettier for HTML
- **Linting**: SonarLint for TypeScript, JavaScript, Dockerfile
- **Debugging**: Full DAP support with `pwa-node` adapter, VS Code `launch.json` compatibility
- **Treesitter**: JS/TS/TSX parsers included in LazyVim extras

### AI Integration

Four AI tools configured and ready:

| Plugin | Purpose | Trigger |
|--------|---------|---------|
| **yoga-ai** | Terminal AI commands (help, fix, code) | `<leader>ah`, `<leader>af`, `<leader>ac` |
| **Supermaven** | Inline AI code completion | `<Tab>` to accept, `<C-]>` to clear |
| **CodeCompanion** | AI chat with Gemini/Ollama | `<leader>cg`, `<leader>co`, `<leader>cc`, `<leader>ca` |
| **Copilot** | GitHub Copilot suggestions | LazyVim default `<leader>cp` |

### Debugging

- `pwa-node` adapter for modern JS/TS debugging
- VS Code `launch.json` hybrid support: `:LoadVSCodeLaunch` or `<leader>dl`
- Auto-opens DAP UI on debug start
- Full breakpoint, step, and REPL support

### REST Client

- kulala.nvim for `.http` and `.rest` files
- Run, inspect, copy as cURL, paste from cURL
- Environment variables support (dev/prod/staging)
- Keymaps under `<leader>R` prefix

### Database Client

- vim-dadbod with UI and auto-completion
- Pre-configured MySQL connections
- Keymaps under `<leader>b` prefix
- Nerd font icons enabled

### Code Navigation

- aerial.nvim for symbol outline and navigation
- Telescope configured for hidden file search (dotfiles included)
- `[[` / `]]` for previous/next symbol navigation
- `<leader>cs` for outline, `<leader>ca` for floating nav

### Git Integration

- diffview.nvim for full diff UI and file history
- LazyVim default git signs, blame line, lazygit integration
- Custom keymaps: `<leader>gd`, `<leader>gD`, `<leader>gh`

### UI

- **Colorscheme**: gruvbox-material (hard background, material foreground)
- **Statusline**: lualine with smart branch truncation (branches >20 chars are truncated)
- **Session**: vim-obsession for automatic session persistence

## How to Customize

### Adding a New Plugin

Create a new file in `lua/plugins/`. Each file returns a lazy.nvim spec table:

```lua
-- lua/plugins/my-plugin.lua
return {
  {
    "author/plugin-name",
    event = "VeryLazy",
    opts = {
      -- your config here
    },
  },
}
```

Lazy.nvim auto-discovers all files in `lua/plugins/` via the `{ import = "plugins" }` spec in `lua/config/lazy.lua`.

### Overriding an Existing Plugin

Create or edit a file in `lua/plugins/` with the same plugin name. Lazy.nvim merges specs by name:

```lua
-- lua/plugins/telescope.lua (already exists)
return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    -- opts contains LazyVim defaults; extend them
    opts.defaults.layout_strategy = "vertical"
  end,
}
```

### Disabling a Plugin

Set `enabled = false`:

```lua
return {
  { "some-plugin", enabled = false },
}
```

### Adding LSP Servers

Edit `lua/plugins/yoga-js.lua` to add servers to Mason's `ensure_installed`:

```lua
vim.list_extend(opts.ensure_installed, {
  "typescript-language-server",
  "biome",
  "lua-language-server",  -- add new server
})
```

Or create a separate plugin file for the LSP config:

```lua
-- lua/plugins/lsp-extras.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
      },
    },
  },
}
```

### Changing the Colorscheme

Edit `lua/plugins/colorscheme.lua`:

```lua
vim.g.gruvbox_material_background = "soft"  -- 'soft', 'medium', 'hard'
vim.cmd.colorscheme("gruvbox-material")
```

### Changing AI Provider

Edit `lua/plugins/codecompanion.lua`:

```lua
opts = {
  strategies = {
    chat = { adapter = "ollama" },  -- switch default
    inline = { adapter = "ollama" },
  },
}
```

## Documentation Index

| Document | Description |
|----------|-------------|
| [VS Code launch.json](./vscode-launch-json.md) | Hybrid DAP configuration for VS Code launch.json |
| [Keymaps](./keymaps.md) | Complete keymap reference |
| [Plugins](./plugins.md) | Complete plugin reference |
| [LSP](./lsp.md) | LSP server configuration and Mason setup |
| [AI Integration](./ai-integration.md) | AI plugins: yoga-ai, Supermaven, CodeCompanion, Copilot |
| [Dadbod](./dadbod.md) | Database client configuration |
| [Kulala](./kulala.md) | REST client for HTTP files |
| [Debug Setup](./debug-setup.md) | JS/TS debugging configuration |
| [Troubleshooting](./troubleshooting.md) | Common issues and solutions |

## Philosophy

This configuration prioritizes:

1. **Convention over configuration**: LazyVim defaults are kept where they work well
2. **Extensibility**: Each plugin in its own file for easy toggling and override
3. **Hidden files**: Telescope and grep are configured to find dotfiles by default
4. **JS/TS first**: Biome, TypeScript LSP, and pwa-node debugging are auto-installed
5. **AI-assisted**: Multiple AI tools available without requiring a single provider
6. **Hybrid debugging**: VS Code `launch.json` files work natively in Neovim

## Quick Reference

| Action | Command / Key |
|--------|---------------|
| Open LazyVim | `:Lazy` |
| Open Mason | `:Mason` |
| Check health | `:checkhealth` |
| Update plugins | `:Lazy sync` |
| Update Mason tools | `:MasonUpdate` |
| Toggle inline AI completion | `<Tab>` (Supermaven) |
| Open AI chat | `<leader>cg` (Gemini) or `<leader>co` (Ollama) |
| Run HTTP request | `<leader>Rr` (kulala) |
| Toggle database UI | `<leader>bt` (dadbod) |
| Debug current file | `<leader>dc` or `F5` |
| Load VS Code launch | `<leader>dl` or `:LoadVSCodeLaunch` |
| Toggle code outline | `<leader>cs` (aerial) |
| Show git diff | `<leader>gd` (diffview) |
| Find hidden files | `<leader>ff` (telescope, includes dotfiles) |