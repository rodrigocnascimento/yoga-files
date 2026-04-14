# VS Code launch.json Hybrid Debug Support

The Yoga LazyyVim configuration includes hybrid debugging support that allows you to use VS Code `launch.json` files directly in Neovim. This means teams sharing VS Code debug configurations can use them seamlessly in Neovim without any manual conversion.

## Table of Contents

- [Overview](#overview)
- [Plugin Configuration](#plugin-configuration)
- [How It Works](#how-it-works)
- [Commands](#commands)
- [Keybindings](#keybindings)
- [Creating a launch.json](#creating-a-launchjson)
- [Type Conversion](#type-conversion)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)

## Overview

The `dap-vscode.lua` plugin configures `nvim-dap` with the `nvim-dap-vscode-js` adapter to support VS Code-style debug configurations. This provides:

- **Auto-detection** of `.vscode/launch.json` at the project root
- **Fallback search** in `src/.vscode/` for monorepo-style projects
- **Automatic type conversion** from VS Code debug types to Neovim DAP types
- **DAP UI integration** that auto-opens/closes with debug sessions
- **Interactive selection** when multiple launch configurations are found

## Plugin Configuration

File: `lua/plugins/dap-vscode.lua`

```lua
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",           -- Visual UI for debugging
      "theHamsta/nvim-dap-virtual-text", -- Show variable values inline
      "mxsdev/nvim-dap-vscode-js",       -- VS Code JS debug adapter
    },
    config = function()
      -- See below for full configuration
    end,
  },
}
```

### Key Configuration Details

| Setting | Value | Purpose |
|---------|-------|---------|
| `node_path` | `"node"` | Path to Node.js binary |
| `debugger_path` | `mason/packages/js-debug-adapter` | Mason-installed debugger |
| `adapters` | `pwa-node`, `node-terminal`, `node` | Supported adapter types |
| `log_file_path` | `cache/dap_vscode_js.log` | Debug log location |
| `log_file_level` | `ERROR` | Only log errors to file |
| `log_console_level` | `ERROR` | Only log errors to console |

### Registered File Types

The following file types are registered for DAP configuration:

- `typescript`
- `javascript`
- `typescriptreact`
- `javascriptreact`

### Type-to-Filetype Mapping

```lua
require("dap.ext.vscode").type_to_filetypes = {
  ["pwa-node"] = js_languages,
  ["node"] = js_languages,
}
```

This mapping tells DAP which file types can use which adapter types, enabling VS Code `launch.json` files containing `"type": "pwa-node"` or `"type": "node"` to be recognized for all JS/TS file types.

## How It Works

### Search Strategy

When you trigger `:LoadVSCodeLaunch` (or press `<leader>dl`), the plugin searches for `launch.json` files using this priority:

1. **Project root**: `.vscode/launch.json` in the current working directory
2. **Monorepo src**: `src/.vscode/launch.json` (common in backend monorepos where the actual app lives in `src/`)
3. **User selection**: If multiple `launch.json` files are found, you are prompted to select which one to use

### Adapter Setup

The `nvim-dap-vscode-js` adapter is configured to use Mason's `js-debug-adapter` package located at:

```
~/.local/share/nvim/mason/packages/js-debug-adapter
```

This is the modern `pwa-node` adapter, which replaces the deprecated `node2` adapter. The older `node2` configuration still exists in `lua/config/dap-node.lua` for backward compatibility but is not the primary adapter.

### DAP UI Auto-Open/Close

The debug UI automatically opens when a debug session initializes and closes when the session terminates or the process exits:

```lua
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
```

## Commands

| Command | Description |
|---------|-------------|
| `:LoadVSCodeLaunch` | Search for `launch.json` at root and `src/.vscode/`, prompt if multiple found |
| `:LoadVSCodeLaunch <path>` | Load a specific `launch.json` file at the given path |

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>dl` | Normal | Load VS Code `launch.json` (searches root + `src/.vscode/`) |

This keybinding is registered as part of the DAP configuration. It triggers the `:LoadVSCodeLaunch` command which auto-detects `launch.json` files.

## Creating a launch.json

Create a `.vscode/launch.json` file in your project root:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node-terminal",
      "request": "launch",
      "name": "Launch Server",
      "command": "npm run dev"
    }
  ]
}
```

### For Monorepo Projects

If your application lives inside `src/`, place the file at `src/.vscode/launch.json`:

```
my-project/
├── src/
│   ├── .vscode/
│   │   └── launch.json    ← Will be found by <leader>dl
│   ├── server.ts
│   └── app.ts
└── package.json
```

## Type Conversion

The most important conversion happens automatically:

| VS Code Type | Neovim DAP Type | Notes |
|--------------|-----------------|-------|
| `node-terminal` | `pwa-node` | Used for `npm run` style launches |
| `pwa-node` | `pwa-node` | Direct mapping, no conversion needed |
| `node` | `node` | Direct mapping, no conversion needed |

The `node-terminal` → `pwa-node` conversion is critical because VS Code uses `node-terminal` as a type for configurations that run `npm` scripts, but Neovim's DAP requires `pwa-node` to use the js-debug-adapter.

## Examples

### Example 1: Launch Current File

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "pwa-node",
      "request": "launch",
      "name": "Launch Current File",
      "program": "${file}",
      "cwd": "${workspaceFolder}",
      "sourceMaps": true
    }
  ]
}
```

### Example 2: Attach to Process

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "pwa-node",
      "request": "attach",
      "name": "Attach to Process",
      "processId": "${command:PickProcess}",
      "cwd": "${workspaceFolder}",
      "sourceMaps": true
    }
  ]
}
```

### Example 3: NPM Script (node-terminal)

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node-terminal",
      "request": "launch",
      "name": "Launch Dev Server",
      "command": "npm run dev"
    }
  ]
}
```

This `node-terminal` type will be automatically converted to `pwa-node` by the adapter.

### Example 4: NestJS Application

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "pwa-node",
      "request": "launch",
      "name": "NestJS Debug",
      "runtimeExecutable": "node",
      "runtimeArgs": ["--loader", "ts-node/esm"],
      "args": ["src/main.ts"],
      "cwd": "${workspaceFolder}",
      "sourceMaps": true,
      "skipFiles": ["<node_internals>/**"]
    }
  ]
}
```

### Example 5: Multiple Configurations

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "pwa-node",
      "request": "launch",
      "name": "Debug API",
      "program": "${workspaceFolder}/src/main.ts",
      "sourceMaps": true
    },
    {
      "type": "pwa-node",
      "request": "attach",
      "name": "Attach API",
      "port": 9229,
      "sourceMaps": true
    }
  ]
}
```

When multiple configurations are found, `:LoadVSCodeLaunch` will prompt you to select one.

## Troubleshooting

### "js-debug-adapter not found"

Install it via Mason:

```vim
:MasonInstall js-debug-adapter
```

The `yoga-js.lua` plugin does not auto-install this package. You must install it manually or add it to the `ensure_installed` list.

### launch.json not detected

1. Verify the file exists at `.vscode/launch.json` or `src/.vscode/launch.json`
2. Try the explicit path: `:LoadVSCodeLaunch .vscode/launch.json`
3. Check that the JSON is valid: `:!jq . .vscode/launch.json`

### "Cannot launch program path"

- Ensure `"program": "${file}"` is correct for launch configurations
- For attach configurations, verify the target process is running on the specified port

### "Connection refused" on port 9229

- Check that no other debug session is already using port 9229
- If using `dap-node.lua` (legacy), it also uses port 9229 — avoid running both simultaneously
- Kill stale processes: `:Dispatch lsof -i :9229`

### Type conversion not working

If your VS Code launch.json uses a type that isn't being recognized:

1. Check that the type is in the `type_to_filetypes` mapping
2. Add the type to the mapping in `lua/plugins/dap-vscode.lua`
3. Restart Neovim after changes

### DAP UI not opening

The DAP UI is configured to auto-open on session start. If it doesn't:

```vim
:lua require("dapui").open()
```

Check that `nvim-dap-ui` is installed: `:Lazy check nvim-dap-ui`

### Debug logs

Enable verbose logging to diagnose issues:

```lua
-- Temporarily add to your config
vim.g.dap_log_level = vim.log.levels.DEBUG
```

Or check the log file at `~/.local/cache/nvim/dap_vscode_js.log`.

## Related Files

| File | Purpose |
|------|---------|
| `lua/plugins/dap-vscode.lua` | Main DAP + VS Code launch.json configuration |
| `lua/config/dap-node.lua` | Legacy node2 adapter (attach mode, port 9229) |
| `lua/config/keymaps.lua` | DAP keymaps (`<leader>d*`) |
| `lua/plugins/yoga-js.lua` | Mason ensure_installed (typescript-language-server, biome) |

## See Also

- [Debug Setup](./debug-setup.md) — Full JS/TS debugging guide
- [Keymaps](./keymaps.md) — Complete keymap reference including DAP keys
- [Troubleshooting](./troubleshooting.md) — General troubleshooting guide