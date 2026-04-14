# Tmux A++ — Yoga 3.0

> Upgraded tmux configuration for the Yoga 3.0 Lôro Barizon Edition

## What is Tmux A++

Tmux A++ is the enhanced tmux configuration bundled with Yoga 3.0. It replaces the default tmux experience with a modern, feature-rich setup that includes smart session management, popup overlays, fzf integration, and a curated set of plugins — all pre-configured and ready to use.

The configuration lives at `~/.config/tmux/tmux.conf` and is managed via TPM (Tmux Plugin Manager).

## Prefix Key

**`Ctrl+Space`**

All keybindings assume you press the prefix first (unless noted otherwise). The traditional `Ctrl+b` prefix has been unbound in favor of `Ctrl+Space`, which avoids conflicts with editor shortcuts and provides a more ergonomic trigger.

## Key Features

- **Smart Session Manager** — `t-smart-tmux-session-manager` provides fuzzy session switching with directory preview (`prefix+s`)
- **Popups** — One-key overlays for lazygit (`prefix+g`), btop/btm (`prefix+b`), and a scratch terminal (`prefix+t`)
- **FZF Integration** — Fuzzy find windows (`prefix+f`), sessions (`prefix+F`), and panes (`prefix+P`)
- **Vim Navigation** — Seamless pane movement between tmux and Neovim via `vim-tmux-navigator` (no prefix needed)
- **Session Persistence** — Automatic session save/restore via `tmux-resurrect` + `tmux-continuum`
- **Clipboard Support** — `tmux-yank` for system clipboard integration
- **CPU/Memory Monitor** — Real-time system stats in the status bar
- **Prefix Highlight** — Visual indicator when prefix is active

## Plugin Count

4 new plugins beyond the legacy setup:

| Plugin | Purpose |
|--------|---------|
| `t-smart-tmux-session-manager` | Fuzzy session switcher |
| `tmux-fzf` | FZF-based pane/window/session finder |
| `tmux-cpu-mem-monitor` | System stats in status bar |
| `tmux-prefix-highlight` | Visual prefix state indicator |

## Documentation

| Document | Description |
|----------|-------------|
| [keybindings.md](keybindings.md) | Complete keybinding reference (all keys documented) |
| [plugins.md](plugins.md) | Plugin-by-plugin reference with config options |
| [themes.md](themes.md) | Theme and status line configuration |
| [workflow.md](workflow.md) | Common workflows and daily usage patterns |
| [troubleshooting.md](troubleshooting.md) | Fixing common tmux issues |

## Installation

```bash
# Clone TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Install all plugins (inside tmux)
# Press: Ctrl+Space + I

# Reload configuration after changes
# Press: Ctrl+Space + r
```

## First Setup

1. Install tmux >= 3.2
2. Copy or symlink `tmux.conf` to `~/.config/tmux/tmux.conf`
3. Clone TPM: `git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm`
4. Start tmux and press `Ctrl+Space + I` to install plugins
5. Press `Ctrl+Space + r` to reload the configuration

## Quick Reference

```
Ctrl+Space  s   → Smart session switcher
Ctrl+Space  g   → lazygit popup
Ctrl+Space  b   → btop popup
Ctrl+Space  t   → Floating terminal
Ctrl+Space  f   → FZF window finder
Ctrl+Space  \   → Split horizontal
Ctrl+Space  -   → Split vertical
Ctrl+h/j/k/l    → Vim-tmux navigation (no prefix)
```