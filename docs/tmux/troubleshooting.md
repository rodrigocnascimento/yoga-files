# Tmux Troubleshooting — Yoga 3.0

> Fixes for common issues with the Tmux A++ configuration

---

## TPM Not Installed

**Symptom:** Plugins are not loaded, status bar looks bare, keybindings don't work.

**Cause:** TPM (Tmux Plugin Manager) is not cloned.

**Fix:**

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Then inside tmux, press `Ctrl+Space + I` to install all plugins.

**Verify:** Check that `~/.config/tmux/plugins/tpm/tpm` exists.

---

## Plugins Not Loading

**Symptom:** Plugin keybindings don't respond, status bar doesn't update.

**Cause:** Plugins haven't been installed via TPM.

**Fix:**

1. Start tmux
2. Press `Ctrl+Space + I` (capital I)
3. Wait for the "TMUX environment reloaded" message
4. Press `Ctrl+Space + r` to reload config

**If that doesn't work:**

```bash
# Remove and reinstall all plugins
rm -rf ~/.config/tmux/plugins/*
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
# Then prefix+I inside tmux
```

---

## Prefix Key Not Working

**Symptom:** `Ctrl+Space` doesn't trigger prefix mode.

**Cause 1:** Another application captures `Ctrl+Space` before tmux receives it.

**Fix:** Check your terminal emulator settings. Some terminals reserve `Ctrl+Space` for input method switching (especially on macOS with CJK languages). Disable that shortcut or switch to a different prefix in `tmux.conf`:

```tmux
# Alternative: use Ctrl+a as prefix
set -g prefix C-a
bind C-a send-prefix
```

**Cause 2:** tmux server is using an old config.

**Fix:**

```bash
# Kill all tmux sessions and restart
tmux kill-server
tmux
```

---

## True Color Not Working

**Symptom:** Colors appear wrong, gradients are banded, theme looks "off".

**Cause:** Terminal or tmux is not configured for 24-bit color.

**Fix 1 — Check tmux config:**

```tmux
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",*256col*:Tc"
```

These are already in the Yoga 3.0 config.

**Fix 2 — Check $COLORTERM:**

```bash
echo $COLORTERM
# Should output: truecolor or 24bit
```

If empty, add to your shell profile:

```bash
export COLORTERM=truecolor
```

**Fix 3 — Check terminal emulator:**
- Use a terminal that supports true color: Kitty, Alacritty, WezTerm, iTerm2, Windows Terminal
- Older terminals (xterm) may not support 24-bit color

**Verify:**

```bash
# Inside tmux, run:
echo $TERM
# Should show: tmux-256color

# Test true color:
awk 'BEGIN{for(i=0;i<256;i++)printf("\033[48;5;%dm ",i);printf("\n")}'
```

---

## Mouse Not Working

**Symptom:** Cannot click panes, scroll, or resize with mouse.

**Cause:** Mouse mode is not enabled or terminal doesn't support it.

**Fix:**

The Yoga 3.0 config already includes `set -g mouse on`. If it's not working:

```bash
# Check current setting (inside tmux):
tmux show -g mouse

# Enable manually:
tmux set -g mouse on

# If scroll enters copy mode unexpectedly, this is normal behavior.
# Press 'q' to exit copy mode.
```

**Note:** If you need to select text with the mouse, hold `Shift` while selecting to bypass tmux's mouse handling.

---

## Vim-Tmux-Navigator Conflicts

**Symptom:** `Ctrl+h/j/k/l` doesn't move between panes, or moves don't cross between tmux and Neovim.

**Cause 1:** Missing Neovim plugin.

**Fix:** Install `vim-tmux-navigator` in Neovim. For LazyVim:

```lua
-- In your LazyVim plugins
{
  "christoomey/vim-tmux-navigator",
  lazy = false,
}
```

**Cause 2:** tmux plugin not installed.

**Fix:** Press `Ctrl+Space + I` to install plugins via TPM.

**Cause 3:** Conflict with another keybinding.

**Fix:** Check for overlapping keybindings in your shell or Neovim config:

```bash
# In tmux, verify the bindings:
tmux list-keys | grep -E "C-h|C-j|C-k|C-l"
```

---

## FZF Inside Tmux Not Working

**Symptom:** `prefix+f`, `prefix+F`, or `prefix+P` shows errors or no results.

**Cause 1:** `fzf` is not installed.

**Fix:**

```bash
# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf ~/.fzf
~/.fzf/install
```

**Cause 2:** `fzf-tmux` not available.

**Fix:** `fzf-tmux` comes bundled with fzf. Verify:

```bash
which fzf-tmux
# Should output a path

# If missing, reinstall fzf:
~/.fzf/install
```

**Cause 3:** Popup size too small.

**Fix:** The fzf bindings use `-p 50%` which requires tmux >= 3.2. Check your version:

```bash
tmux -V
# Should be >= 3.2
```

---

## Copy/Paste Issues on Linux

**Symptom:** Content copied in tmux doesn't appear in the system clipboard.

**Cause:** Missing clipboard integration tool.

**Fix for X11:**

```bash
sudo apt install xclip
# or
sudo apt install xsel
```

**Fix for Wayland:**

```bash
sudo apt install wl-clipboard
```

**Fix for headless/SSH:**

For remote sessions, use X forwarding or set up a clipboard OSC 52 integration:

```tmux
# Add to tmux.conf for OSC 52 support:
set -s set-clipboard on
```

**Verify:** After installing xclip/wl-clipboard, restart tmux and test copy mode:

1. Press `Ctrl+Space + [` to enter copy mode
2. Select text with `v` and copy with `y`
3. Paste in another application with `Ctrl+Shift+v`

---

## Session Not Restoring (tmux-resurrect)

**Symptom:** Sessions don't restore after restarting tmux.

**Cause 1:** `tmux-continuum` auto-restore is off.

**Fix:** Verify the config includes:

```tmux
set -g @continuum-restore 'on'
```

**Cause 2:** No saved sessions exist.

**Fix:** Manually save first:

```
Ctrl+Space + Ctrl+s
```

Then check `~/.tmux/resurrect/` for saved files.

**Cause 3:** tmux-resurrect not restoring programs.

**Fix:** Add custom restore programs to your config:

```tmux
set -g @resurrect-processes ':nvim :node :python'
```

**Cause 4:** `tmux-continuum` is not running.

**Fix:**

```bash
# Check continuum status:
tmux show -g @continuum-status

# Restart tmux to reinitialize:
tmux kill-server
tmux
```

---

## Performance Issues with CPU Monitor

**Symptom:** tmux feels sluggish, high CPU usage, status bar flickers.

**Cause:** `tmux-cpu-mem-monitor` updating too frequently, or external commands in the status bar being slow.

**Fix 1 — Reduce update frequency:**

```tmux
# Increase interval from 3 to 15 seconds:
set -g status-interval 15
```

**Fix 2 — Check for heavy status scripts:**

If you have custom `status-right` or `status-left` scripts that run external commands, they execute at every refresh interval. Keep them lightweight.

**Fix 3 — Disable CPU monitor temporarily:**

```tmux
# Comment out in tmux.conf:
# set -g @plugin 'hendrikmi/tmux-cpu-mem-monitor'
```

Then `prefix+U` to update plugins, `prefix+r` to reload.

---

## Popup Not Displaying

**Symptom:** `prefix+g`, `prefix+b`, or `prefix+t` doesn't open a popup.

**Cause 1:** tmux version < 3.2. The `display-popup` command requires tmux 3.2+.

**Fix:**

```bash
tmux -V
# Must be >= 3.2

# Install newer tmux:
# Ubuntu/Debian:
sudo apt install tmux
# macOS:
brew install tmux
# From source:
git clone https://github.com/tmux/tmux.git
cd tmux && ./autogen.sh && ./configure && make && sudo make install
```

**Cause 2:** The target command (lazygit, btm) is not installed.

**Fix:**

```bash
# Install lazygit:
# https://github.com/jesseduffield/lazygit#installation

# Install btm (bottom):
# https://github.com/ClementTsang/bottom#installation
```

---

## General Debugging Tips

```bash
# Show all tmux options:
tmux show -g

# Show keybindings:
tmux list-keys

# Show running plugins:
ls ~/.config/tmux/plugins/

# Check tmux logs:
tmux start-server \; show-option -gv @plugin

# Reload config from command line:
tmux source-file ~/.config/tmux/tmux.conf

# Reset everything:
tmux kill-server
rm -rf ~/.config/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
tmux
# Then prefix+I
```