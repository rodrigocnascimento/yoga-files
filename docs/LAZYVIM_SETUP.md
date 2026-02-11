# LazyVim Setup

This guide describes how yoga-files expects Neovim/LazyVim to be installed and configured.

## What You Get

- LazyVim starter-based Neovim config
- Fast startup via lazy-loading
- A good baseline for JavaScript/TypeScript editing
- yoga-files overlays under `~/.yoga/editor/nvim/` (copied into `~/.config/nvim/`)

## Install Notes

The installer may:

- Backup an existing config from `~/.config/nvim`
- Clone the LazyVim starter into `~/.config/nvim`
- Copy overlays from `~/.yoga/editor/nvim/` into `~/.config/nvim/`

Verify:

```bash
nvim --version
```

## Where Config Lives

- Neovim config: `~/.config/nvim`
- User plugins: `~/.config/nvim/lua/plugins/`
- User config: `~/.config/nvim/lua/config/`

## Health Check

```bash
nvim --headless "+checkhealth" +qall
```

If health checks fail, confirm you have:

- A recent Neovim
- `git` available in PATH

## JS/TS Baseline

Recommended global tools (optional, but helpful):

```bash
npm install -g typescript tsx @biomejs/biome
```

Then open a project and ensure:

- LSP attaches for TS/JS files
- formatting works (Biome or your configured formatter)

## AI Keymaps (Optional)

If `yoga-ai` is installed and in PATH, yoga-files adds a few keymaps:

- `<leader>ah`: AI help
- `<leader>af`: AI fix
- `<leader>ac`: AI code
