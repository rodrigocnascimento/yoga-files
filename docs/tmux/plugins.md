# Tmux Plugins — Complete Reference

> Every plugin in the Yoga 3.0 Tmux A++ configuration, documented with bindings, options, and URLs.

---

## t-smart-tmux-session-manager

**What it does:** Provides a fuzzy session switcher with directory preview. When you invoke it, tmux opens a popup listing all sessions with a fuzzy search interface, allowing you to quickly switch between projects.

**Key binding:**
- `prefix+s` — Opens the `tms switch` popup (80%x80%)

**Configuration in tmux.conf:**
```tmux
set -g @tms-key 's'
```

This tells t-smart-tmux-session-manager to use `s` as its trigger key, which is bound to a `display-popup` command.

**URL:** <https://github.com/joshmedeski/t-smart-tmux-session-manager>

---

## tmux-resurrect

**What it does:** Persists tmux sessions across restarts. Saves pane layout, window structure, and running programs so you can restore your exact workspace after tmux is killed or the machine reboots.

**Key bindings (defaults):**
- `prefix+Ctrl+s` — Save session
- `prefix+Ctrl+r` — Restore session

**Configuration in tmux.conf:**
```tmux
# No custom configuration beyond plugin declaration
set -g @plugin 'tmux-plugins/tmux-resurrect'
```

**Tips:**
- Saved sessions are stored in `~/.tmux/resurrect/`
- By default, restores pane contents and programs like vim, node, python
- Works in tandem with `tmux-continuum` for automatic saves

**URL:** <https://github.com/tmux-plugins/tmux-resurrect>

---

## tmux-continuum

**What it does:** Provides automatic session saving and restoring. Works on top of `tmux-resurrect` to save your environment every N minutes and auto-restore on tmux start.

**Configuration in tmux.conf:**
```tmux
set -g @continuum-save-interval '10'
set -g @continuum-restore 'on'
```

**Options:**
| Option | Value | Description |
|--------|-------|-------------|
| `@continuum-save-interval` | `10` | Auto-save every 10 minutes |
| `@continuum-restore` | `on` | Auto-restore last session on tmux start |

**Key bindings (defaults):**
- `prefix+Ctrl+s` — Manual save (via resurrect)
- `prefix+Ctrl+r` — Manual restore (via resurrect)

**URL:** <https://github.com/tmux-plugins/tmux-continuum>

---

## vim-tmux-navigator

**What it does:** Enables seamless navigation between tmux panes and Vim/Neovim splits using the same keybindings. When you hit `Ctrl+h/j/k/l`, it moves between tmux panes or Vim splits depending on context — no prefix required.

**Key bindings (no prefix required):**
| Key | Action |
|-----|--------|
| `Ctrl+h` | Move left (pane or Vim split) |
| `Ctrl+j` | Move down (pane or Vim split) |
| `Ctrl+k` | Move up (pane or Vim split) |
| `Ctrl+l` | Move right (pane or Vim split) |

**Configuration in tmux.conf:**
```tmux
set -g @plugin 'christoomey/vim-tmux-navigator'
```

No additional tmux-side configuration needed. The Vim side requires the corresponding plugin (`vim-tmux-navigator.nvim` for LazyVim) to work.

**URL:** <https://github.com/christoomey/vim-tmux-navigator>

---

## tmux-cpu-mem-monitor

**What it does:** Displays real-time CPU and memory usage in the tmux status bar. Updates automatically based on `status-interval` (set to 3 seconds in this config).

**Configuration in tmux.conf:**
```tmux
set -g @plugin 'hendrikmi/tmux-cpu-mem-monitor'
```

The plugin integrates into the status line and shows CPU/memory percentages. It uses the `status-interval` setting (3s) to refresh.

**URL:** <https://github.com/hendrikmi/tmux-cpu-mem-monitor>

---

## tmux-yank

**What it does:** Copies tmux selection to the system clipboard. In copy mode, when you make a selection and copy it, `tmux-yank` automatically pushes it to your OS clipboard (Wayland or X11).

**Key bindings (inside copy-mode-vi):**
| Key | Action |
|-----|--------|
| `y` | Copy selection to clipboard and exit copy mode |

The `y` binding in tmux.conf (`bind -T copy-mode-vi y send -X copy-selection-and-cancel`) works together with tmux-yank to deliver content to the system clipboard.

**Configuration in tmux.conf:**
```tmux
set -g @plugin 'tmux-plugins/tmux-yank'
```

**Requirements:**
- Linux: requires `xclip` or `xsel` (X11) or `wl-copy` (Wayland)
- macOS: works natively via `pbcopy`

**URL:** <https://github.com/tmux-plugins/tmux-yank>

---

## tmux-prefix-highlight

**What it does:** Adds a visual indicator in the status bar showing whether the tmux prefix key is currently active. When you press `Ctrl+Space`, the status bar updates to show that prefix mode is on.

**Configuration in tmux.conf:**
```tmux
set -g @plugin 'tmux-plugins/tmux-prefix-highlight'
```

This plugin integrates into the status line. The indicator appears in the status-right or status-left segment, depending on your theme configuration.

**URL:** <https://github.com/tmux-plugins/tmux-prefix-highlight>

---

## tmux-fzf

**What it does:** Provides fzf-based search interfaces inside tmux. The Yoga 3.0 config defines custom keybindings that use `fzf-tmux` to fuzzy-find windows, sessions, and panes.

**Key bindings:**
| Key | Action |
|-----|--------|
| `prefix+f` | Fuzzy find windows |
| `prefix+F` | Fuzzy find sessions |
| `prefix+P` | Fuzzy find panes |

**Configuration in tmux.conf:**
```tmux
set -g @plugin 'sainnhe/tmux-fzf'

bind f run-shell "tmux list-windows -F '#{window_index}: #{window_name}' | fzf-tmux -p 50% | cut -d: -f1 | xargs -I {} tmux select-window -t {}"
bind F run-shell "tmux list-sessions -F '#{session_name}' | fzf-tmux -p 50% | xargs -I {} tmux switch-client -t {}"
bind P run-shell "tmux list-panes -F '#{pane_index}: #{pane_current_command}' | fzf-tmux -p 50% | cut -d: -f1 | xargs -I {} tmux select-pane -t {}"
```

**Requirements:**
- `fzf` must be installed
- `fzf-tmux` must be available (comes with fzf)

**URL:** <https://github.com/sainnhe/tmux-fzf>

---

## floax

**Note:** floax is not currently configured in the Yoga 3.0 tmux.conf. The popup functionality uses native `display-popup` commands instead. This entry is kept for reference — if floax is added in the future, it would provide a floating terminal manager with animations.

**What it does:** floax is a tmux plugin for managing floating terminals with smooth animations and configurable size/position.

**Potential future integration:**
```tmux
set -g @plugin 'omerxx/tmux-floax'
```

**URL:** <https://github.com/omerxx/tmux-floax>

---

## catppuccin/tmux

**Note:** catppuccin/tmux is not currently configured in the Yoga 3.0 tmux.conf. The theme setup uses custom status-left and status-right segments with ANSI colors. This entry is kept for reference.

**What it does:** Applies the Catppuccin Mocha color palette to tmux — status bar, panes, windows, and all UI elements.

**Potential future integration:**
```tmux
set -g @plugin 'catppuccin/tmux'
set -g @catppuccin_flavor 'mocha'
```

**URL:** <https://github.com/catppuccin/tmux>

---

## TPM (Tmux Plugin Manager)

**What it does:** Manages all tmux plugins — installation, updates, and cleanups.

**Key bindings:**
| Key | Action |
|-----|--------|
| `prefix+I` | Install plugins |
| `prefix+U` | Update plugins |
| `prefix+alt+u` | Uninstall plugins not in config |

**URL:** <https://github.com/tmux-plugins/tpm>

---

## Plugin List Summary

| # | Plugin | Purpose | Key Binding |
|---|--------|---------|-------------|
| 1 | `t-smart-tmux-session-manager` | Fuzzy session switcher | `prefix+s` |
| 2 | `tmux-resurrect` | Session persistence | `prefix+Ctrl+s/r` |
| 3 | `tmux-continuum` | Auto-save/restore | Auto (10min interval) |
| 4 | `vim-tmux-navigator` | Seamless Vim navigation | `Ctrl+h/j/k/l` |
| 5 | `tmux-cpu-mem-monitor` | CPU/RAM in status bar | Auto (3s refresh) |
| 6 | `tmux-yank` | System clipboard | `y` in copy mode |
| 7 | `tmux-prefix-highlight` | Prefix state indicator | Auto (status bar) |
| 8 | `tmux-fzf` | FZF search in tmux | `prefix+f/F/P` |
| 9 | `TPM` | Plugin manager | `prefix+I/U/alt+u` |