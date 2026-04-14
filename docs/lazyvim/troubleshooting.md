# LazyVim Troubleshooting Guide

Common issues and solutions for the Yoga Files LazyVim configuration.

---

## Table of Contents

- [Quick Diagnostics](#quick-diagnostics)
- [Mason Issues](#mason-issues)
- [LSP Issues](#lsp-issues)
- [Debug Adapter (DAP)](#debug-adapter-dap)
- [Performance Issues](#performance-issues)
- [Plugin Conflicts](#plugin-conflicts)
- [Keymap Conflicts](#keymap-conflicts)
- [AI Plugin Issues](#ai-plugin-issues)
- [Kulala Issues](#kulala-issues)
- [Database (Dadbod) Issues](#database-dadbod-issues)
- [Formatting Issues](#formatting-issues)
- [Colorscheme Issues](#colorscheme-issues)
- [Session Issues](#session-issues)
- [Complete Reset](#complete-reset)
- [Common Error Messages](#common-error-messages)

---

## Quick Diagnostics

### Health Check

Run all health checks at once:

```vim
:checkhealth
```

Individual health checks:

```vim
:checkhealth lazy
:checkhealth mason
:checkhealth dap
:checkhealth lsp
:checkhealth treesitter
```

### Plugin Status

```vim
:Lazy                    " Open Lazy dashboard
:Lazy sync               " Sync all plugins (install/update/clean)
:Lazy health             " Check Lazy.nvim health
:Lazy log                " View operation log
:Lazy check              " Check for updates
```

### General Debug Info

```vim
:version                 " Neovim version
:echo $VIM               " Vim runtime path
:echo stdpath('data')    " Data directory
:echo stdpath('config')  " Config directory
:messages                " View recent messages/errors
```

---

## Mason Issues

### Mason Can't Install Servers

**Symptoms**: `Mason install failed`, `Server not found`, timeouts during install.

**Solutions**:

1. **Check Node.js is available**:
   ```bash
   node --version    # Should be v18+ or v20+
   npm --version     # Should be available
   ```

2. **Check PATH includes Mason bin**:
   ```vim
   :!echo $PATH | grep mason
   ```
   Mason bin should be at `~/.local/share/nvim/mason/bin`.

3. **Manually install the package**:
   ```vim
   :MasonInstall typescript-language-server
   :MasonInstall biome
   :MasonInstall js-debug-adapter
   ```

4. **Check internet/firewall**: Mason downloads packages from GitHub. Ensure your network allows HTTPS connections to `github.com`.

5. **Clear Mason cache and retry**:
   ```bash
   rm -rf ~/.local/share/nvim/mason/packages/<package-name>
   ```
   Then restart Neovim and run `:MasonInstall <package-name>` again.

6. **Check Mason logs**:
   ```vim
   :MasonLog
   ```

### Mason Not Auto-Installing

The `yoga-js.lua` plugin adds packages via `ensure_installed`. If they're not installing:

1. Check the config is loaded: `:lua print(vim.inspect(require("mason").get_settings()))`
2. Verify `typescript-language-server` and `biome` are in the list
3. Run `:Lazy sync` to ensure all plugins are installed
4. Restart Neovim — `ensure_installed` runs on startup

### js-debug-adapter Not Found

The `js-debug-adapter` is referenced by `dap-vscode.lua` but is NOT in the `ensure_installed` list.

**Solution**: Install it manually:

```vim
:MasonInstall js-debug-adapter
```

Verify the installation:

```bash
ls ~/.local/share/nvim/mason/packages/js-debug-adapter/
```

---

## LSP Issues

### LSP Not Starting

**Symptoms**: No autocomplete, no diagnostics, no hover documentation.

**Solutions**:

1. **Check LSP status**:
   ```vim
   :LspInfo
   ```
   This shows attached clients and their status.

2. **Check LSP logs**:
   ```vim
   :LspLog
   ```
   Look for errors or connection failures.

3. **Verify the server is installed**:
   ```vim
   :Mason
   ```
   Check that `typescript-language-server` and `biome` are installed.

4. **Restart the LSP server**:
   ```vim
   :LspRestart
   ```

5. **Manually start the server**:
   ```vim
   :LspStart tsserver
   ```

6. **Check filetype**:
   ```vim
   :set filetype?
   ```
   Must be `typescript`, `javascript`, `typescriptreact`, or `javascriptreact` for TS/JS LSP.

### "No Client Attached" in LspInfo

This means no LSP server has attached to the current buffer.

1. Check the filetype matches a configured server
2. Verify the server binary exists: `!which typescript-language-server`
3. Check the project root has a `tsconfig.json` or `jsconfig.json`
4. Try `:LspStart` manually

### TypeScript LSP Slow or High CPU

The TypeScript LSP can be resource-intensive on large projects.

1. **Check project size**: Large `node_modules` or many `.d.ts` files slow it down
2. **Exclude directories**: Add to `tsconfig.json`:
   ```json
   {
     "exclude": ["node_modules", "dist", ".git"]
   }
   ```
3. **Increase memory**: Not configurable directly, but closing other heavy processes helps
4. **Restart**: `:LspRestart`

### LSP Diagnostics Not Showing

1. Check diagnostics configuration: `:lua print(vim.diagnostic.config())`
2. Verify the LSP server is running: `:LspInfo`
3. Try `:lua vim.diagnostic.reset()` to clear stale diagnostics
4. Check if SonarLint is conflicting: `:LspInfo` should show both servers

---

## Debug Adapter (DAP)

### DAP Not Working

**Symptoms**: Breakpoints not hit, debugging doesn't start, "no adapter found".

**Solutions**:

1. **Check js-debug-adapter is installed**:
   ```vim
   :MasonInstall js-debug-adapter
   ```
   Then verify:
   ```bash
   ls ~/.local/share/nvim/mason/packages/js-debug-adapter/
   ```

2. **Check the adapter is loaded**:
   ```lua
   :lua print(vim.inspect(require('dap').adapters))
   ```
   Should show `pwa-node` adapter.

3. **Verify the filetype**:
   ```vim
   :set filetype?
   ```
   Must be one of: `javascript`, `typescript`, `javascriptreact`, `typescriptreact`.

4. **Check DAP configuration**:
   ```lua
   :lua print(vim.inspect(require('dap').configurations))
   ```

### "Connection Refused" on Port 9229

This typically happens with the legacy `node2` adapter.

**Solutions**:

1. Don't use `node2` — use `pwa-node` instead (the default in `dap-vscode.lua`)
2. Kill any process on port 9229:
   ```bash
   lsof -i :9229
   kill <PID>
   ```
3. If using the node2 adapter (legacy), start Node with `--inspect=9229`

### launch.json Not Found

**Solutions**:

1. Verify the file exists:
   ```bash
   ls .vscode/launch.json
   # or for monorepos:
   ls src/.vscode/launch.json
   ```

2. Use the explicit path:
   ```vim
   :LoadVSCodeLaunch .vscode/launch.json
   ```

3. Check JSON validity:
   ```bash
   jq . .vscode/launch.json
   ```

4. Ensure `"type"` is one of: `pwa-node`, `node`, or `node-terminal`

### DAP UI Not Opening

**Solutions**:

1. Check nvim-dap-ui is installed: `:Lazy check nvim-dap-ui`
2. Manually open: `:lua require('dapui').open()`
3. Check the DAP listeners are configured in `lua/plugins/dap-vscode.lua`

### Breakpoints Not Hit

1. **Source maps**: Ensure `"sourceMaps": true` in your launch config
2. **Wrong working directory**: Set `"cwd": "${workspaceFolder}"`
3. **Compiled code**: If using TypeScript, ensure the compiled JS is up to date
4. **File type**: DAP only activates for `javascript`, `typescript`, `javascriptreact`, `typescriptreact`

---

## Performance Issues

### Neovim Startup Slow

1. **Check startup time**:
   ```bash
   nvim --startuptime /tmp/nvim-startup.log
   cat /tmp/nvim-startup.log | sort -k2 -n | tail -20
   ```

2. **Disable heavy plugins** temporarily:
   ```lua
   -- In any plugin file:
   { "some-plugin", enabled = false }
   ```

3. **Check if treesitter is compiling**: First run compiles parsers, subsequent runs should be fast

### Slow Editing in Large Files

1. **Disable treesitter** for the buffer: `:TSDisable highlight`
2. **Check LSP document symbols**: Disable aerial for large files: `<leader>cs` to toggle
3. **Increase synmaxcol**: `vim.opt.synmaxcol = 500` (default is 300)

### High Memory Usage

1. Check which plugins are loaded: `:Lazy health`
2. Check running LSP servers: `:LspInfo`
3. Disable unnecessary plugins with `enabled = false`

---

## Plugin Conflicts

### Two Plugins Fighting Over the Same Feature

**Common conflicts**:

| Conflict | Plugins | Solution |
|----------|----------|----------|
| Code actions | LSP `<leader>ca` vs CodeCompanion | CodeCompanion wins; disable it in CodeCompanion config if needed |
| Formatting | biome vs prettier | conform.nvim runs biome first, falls back to prettier |
| Completion | Supermaven vs LSP | They coexist; Supermaven suggests, LSP completes |

### Resolving Conflicts

1. **Check which plugin owns a keymap**:
   ```vim
   :verbose map <leader>ca
   ```

2. **Disable a conflicting plugin**:
   ```lua
   { "olimorris/codecompanion.nvim", enabled = false }
   ```

3. **Override a keymap** in `lua/config/keymaps.lua`:
   ```lua
   -- Override CodeCompanion's <leader>ca
   vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
   ```

### Lazy Health Check

```vim
:LazyHealth
```

This checks for common issues like conflicting plugins, missing dependencies, and configuration errors.

---

## Keymap Conflicts

### Finding Keymap Conflicts

```vim
:Telescope keymaps
```

Or search for a specific key:

```vim
:verbose map <leader>R
:verbose map <leader>d
```

### Known Keymap Overlaps

| Key | LazyVim Default | Custom Override | Notes |
|-----|----------------|----------------|-------|
| `<leader>ca` | LSP code_action | CodeCompanion Actions | CodeCompanion takes priority when loaded |
| `<leader>cs` | Telescope lsp_document_symbols | Aerial code outline | Aerial overrides |
| `<leader>cg` | None (available) | CodeCompanion Gemini | No conflict |
| `<leader>co` | None (available) | CodeCompanion Ollama | No conflict |
| `<leader>B` | None (available) | Git branch display | No conflict |

### Clearing a Keymap

```lua
-- Clear a keymap
vim.keymap.del("n", "<leader>ca")

-- Or redefine it
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
```

---

## AI Plugin Issues

### CodeCompanion: "Adapter not found"

1. Check the adapter name is correct: `"gemini"` or `"ollama"`
2. Verify adapter config in `lua/plugins/codecompanion.lua`
3. Run `:Lazy sync` to update plugins

### CodeCompanion: "GEMINI_API_KEY not set"

```bash
# Set the environment variable
export GEMINI_API_KEY="your-key-here"

# Add to shell config
echo 'export GEMINI_API_KEY="your-key"' >> ~/.bashrc
```

Restart Neovim after setting the variable.

### CodeCompanion: Ollama not responding

1. Check Ollama is running: `curl http://localhost:11434/api/tags`
2. Check the model is pulled: `ollama list`
3. Pull the model: `ollama pull qwen2.5-coder:7b-instruct-q5_K_M`
4. Start Ollama: `ollama serve`

### Supermaven: Suggestions not appearing

1. Check the plugin is loaded: `:Lazy check supermaven-nvim`
2. Verify keymaps: `:Telescope keymaps` and search "supermaven"
3. Check Supermaven status: `:SupermavenStatus`
4. Restart Neovim

### Yoga AI: "yoga-ai: command not found"

1. Check `yoga-ai` is in PATH: `which yoga-ai`
2. Run the Yoga doctor: `yoga doctor`
3. If missing, check the Yoga Files installation: `./bin/yoga install`

---

## Kulala Issues

### Keymaps not working

1. `global_keymaps = true` must be set in config
2. Verify filetype: `:set filetype?` (should be `http` or `rest`)
3. Check plugin is loaded: `:Lazy check kulala`

### "curl not found"

```bash
which curl
curl --version
```

Install curl if missing (rare on most systems).

### Environment variables not substituted

1. Check `http-client.env.json` is in the project root
2. Validate JSON: `!jq . http-client.env.json`
3. Check default env: should be `"dev"` (set in kulala.lua)
4. Try `:lua require('kulala').env_select()`

### Response not showing

1. Check `infer_content_type = true` is set
2. Try a simple GET: `GET https://httpbin.org/get`
3. Set a timeout if hanging: change `request_timeout = nil` to `request_timeout = 30000` (30s)

---

## Database (Dadbod) Issues

### DB UI not opening

1. Press `<leader>bt` to toggle
2. Try `:DBUI` directly
3. Check plugins are installed: `:Lazy check vim-dadbod`

### Cannot connect to database

1. Test the connection URL in the terminal:
   ```bash
   mysql -u user -p -h host -P port database
   ```
2. Check the database client tool is installed:
   ```bash
   which mysql      # MySQL
   which psql       # PostgreSQL
   which sqlite3     # SQLite
   ```
3. Verify `vim.g.dbs` is set:
   ```lua
   :lua print(vim.inspect(vim.g.dbs))
   ```

### Auto-completion not working

1. Verify vim-dadbod-completion is installed: `:Lazy check vim-dadbod-completion`
2. Check filetype: `:set filetype?` (should be `sql` in query buffer)
3. Try `Ctrl+x Ctrl+o` to manually trigger omni-completion

---

## Formatting Issues

### Format on save not working

1. Check `vim.g.autoformat = true`:
   ```lua
   :lua print(vim.g.autoformat)
   ```
2. Toggle autoformat: `<leader>uf`
3. Try manual format: `<leader>cf`

### Biome not formatting

1. Check biome is installed: `:Mason` (look for `biome`)
2. Check conform.nvim: `:ConformInfo`
3. Ensure a `biome.json` exists in the project (optional but recommended)
4. Try manual format: `<leader>cf`

### Prettier not formatting HTML

1. Check prettier is installed: `:Mason` (look for `prettier`)
2. Run `:ConformInfo` to see which formatters are available
3. Install prettier: `:MasonInstall prettier`

---

## Colorscheme Issues

### Colors Not Loading Correctly

1. Verify `termguicolors` is enabled:
   ```vim
   :set termguicolors?
   ```
   Should show `termguicolors`.

2. Check your terminal supports true color:
   ```bash
   echo $COLORTERM
   ```
   Should be `truecolor` or `24bit`.

3. Restart Neovim — the colorscheme loads early.

4. Check gruvbox-material is installed: `:Lazy check gruvbox-material`

### Wrong Background Color

The configuration sets `hard` background:

```lua
vim.g.gruvbox_material_background = "hard"
```

To change:

```lua
-- lua/plugins/colorscheme.lua
vim.g.gruvbox_material_background = "soft"  -- or "medium"
```

---

## Session Issues

### Session Not Restoring

1. Check vim-obsession is installed: `:Lazy check vim-obsession`
2. Start session recording: `:Obsess`
3. Verify `Session.vim` exists in the project root

### Session File Conflicts

If you have multiple projects opening the same session:

1. Each project directory should have its own `Session.vim`
2. Use `:Obsess` to start recording in the correct directory
3. Use `:Obsess!` to stop recording before switching projects

---

## Complete Reset

If Neovim is completely broken and you need a fresh start:

```bash
# Nuclear option — removes ALL Neovim data
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Then restart Neovim
# LazyVim will re-bootstrap everything
nvim

# After startup, reinstall Mason packages
:MasonInstall typescript-language-server
:MasonInstall biome
:MasonInstall js-debug-adapter
:MasonInstall sonarlint-language-server
```

### Partial Reset

To reset only plugins (keeping config):

```bash
rm -rf ~/.local/share/nvim/lazy
rm -rf ~/.local/share/nvim/mason
rm -rf ~/.cache/nvim

# Restart Neovim
nvim
# LazyVim will reinstall plugins
:Lazy sync
# Reinstall Mason packages manually
```

---

## Common Error Messages

| Error | Cause | Solution |
|-------|-------|----------|
| `E5108: Error executing lua .../codecompanion` | Missing dependency | `:Lazy sync` |
| `Cannot find module 'plenary'` | plenary.nvim not installed | `:Lazy sync` |
| `Mason install failed` | Network or PATH issue | Check internet, Node.js, PATH |
| `No DAP adapter found for javascript` | js-debug-adapter missing | `:MasonInstall js-debug-adapter` |
| `Cannot launch program path` | Wrong program path in config | Check `"program": "${file}"` |
| `Connection refused (port 9229)` | Port in use or stale debug | Kill process: `lsof -i :9229` |
| `E121: Undefined variable:` | Plugin not loaded | `:Lazy sync` and restart |
| `format_on_save timeout` | Formatter not installed or slow | `:ConformInfo`, install formatter |
| `LSP[tsserver] timeout` | Large project | Restart: `:LspRestart` |
| `Request cancelled` | LSP server crashed | `:LspRestart` |
| `E371: Shell error` | yoga-ai CLI not found | Check PATH: `which yoga-ai` |

---

## Getting Help

1. **Check health**: `:checkhealth`
2. **Check logs**: `:messages`, `:LspLog`, `:MasonLog`
3. **Check plugin status**: `:Lazy`
4. **Check keymaps**: `:Telescope keymaps`
5. **Check startup time**: `nvim --startuptime /tmp/startup.log`
6. **Search issues**: GitHub repository for the specific plugin
7. **LazyVim docs**: https://www.lazyvim.org