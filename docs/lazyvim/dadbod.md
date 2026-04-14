# Dadbod Database Integration Reference

Complete reference for the vim-dadbod database client integration in the Yoga Files LazyVim setup.

---

## Table of Contents

- [Overview](#overview)
- [Plugins](#plugins)
- [Keymaps](#keymaps)
- [Configuration](#configuration)
- [Pre-configured Connections](#pre-configured-connections)
- [Adding New Connections](#adding-new-connections)
- [Usage Guide](#usage-guide)
- [Security Warning](#security-warning)
- [Troubleshooting](#troubleshooting)

---

## Overview

The database integration uses vim-dadbod with a visual UI and auto-completion, providing a full-featured SQL client inside Neovim.

```mermaid
flowchart LR
  A[Neovim] --> B[vim-dadbod]
  B --> C[vim-dadbod-ui]
  B --> D[vim-dadbod-completion]
  C --> E[MySQL]
  C --> F[PostgreSQL]
  C --> G[SQLite]
```

| Feature | Description |
|---------|------------|
| Visual UI | Browse databases, tables, and run queries in a sidebar |
| Auto-completion | SQL keywords, table names, and column names |
| Multiple connections | Switch between databases with keymaps |
| Query history | Last query info accessible via keymap |
| Nerd Fonts | Icons for database types and objects |

---

## Plugins

| Plugin | GitHub | Purpose |
|--------|--------|---------|
| `tpope/vim-dadbod` | https://github.com/tpope/vim-dadbod | Core database client — connect, query, manage |
| `kristijanhusak/vim-dadbod-ui` | https://github.com/kristijanhusak/vim-dadbod-ui | Visual UI for browsing databases and managing connections |
| `kristijanhusak/vim-dadbod-completion` | https://github.com/kristijanhusak/vim-dadbod-completion | Auto-completion for SQL, table names, and column names |

**Config file**: `lua/plugins/dadbod.lua`

---

## Keymaps

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `<leader>bt` | `:DBUIToggle<cr>` | Toggle Database UI on/off |
| n | `<leader>bf` | `:DBUIFindBuffer<cr>` | Find and focus current database buffer |
| n | `<leader>bl` | `:DBUILastQueryInfo<cr>` | Show info about the last executed query |

### DBUI Commands

| Command | Description |
|---------|-------------|
| `:DBUI` | Open Database UI |
| `:DBUIToggle` | Toggle Database UI |
| `:DBUIFindBuffer` | Jump to the active database buffer |
| `:DBUILastQueryInfo` | Show last query information |
| `:DBUIAddConnection` | Interactively add a new database connection |

---

## Configuration

### Global Settings

| Setting | Value | Description |
|---------|-------|-------------|
| `db_ui_use_nerd_fonts` | `1` | Use Nerd Font icons in the UI for better visual appearance |
| `db_ui_show_database_icon` | `1` | Show database type icon (MySQL, PostgreSQL, etc.) |

### How Connections Work

Connections are defined in the `init` function and stored in `vim.g.dbs` as a table mapping connection names to connection URLs:

```lua
vim.g.dbs = {
  HOMOLOG = "mysql://user:pass@host:port/db",
  PROD = "mysql://user:pass@host:port/db",
}
```

The DB UI reads `vim.g.dbs` and makes these connections available in the sidebar.

---

## Pre-configured Connections

> **SECURITY WARNING**: The default configuration contains hardcoded credentials. See [Security Warning](#security-warning) for remediation.

### HOMOLOG (QA Environment)

| Setting | Value |
|---------|-------|
| Name | `HOMOLOG` |
| Type | MySQL |
| Host | `mysql-hml.example.com` (see dadbod.lua for actual) |
| Port | `3306` |
| Database | `pebmedapps` |

### PROD (Production Read-Only)

| Setting | Value |
|---------|-------|
| Name | `PROD` |
| Type | MySQL (Read Replica) |
| Host | `mysql-prd-read.example.com` (see dadbod.lua for actual) |
| Port | `3306` |
| Database | `pebmedapps` |

---

## Adding New Connections

### Method 1: Edit `lua/plugins/dadbod.lua`

Add a new entry to the `connections` table:

```lua
local connections = {
  {
    name = "HOMOLOG",
    user = "user",
    pass = "pass",
    host = "mysql-hml.example.com",
    port = "3306",
    db = "pebmedapps",
  },
  -- Add new connection here:
  {
    name = "LOCAL_DEV",
    user = "root",
    pass = "",
    host = "127.0.0.1",
    port = "3306",
    db = "my_app_dev",
  },
}
```

Restart Neovim after editing the config.

### Method 2: Use `:DBUIAddConnection`

This prompts for a connection URL interactively:

```vim
:DBUIAddConnection
```

Enter the connection URL when prompted:

```
postgresql://user:password@localhost:5432/my_database
```

### Method 3: Environment Variables (Recommended)

Set credentials via environment variables for security:

```bash
# In ~/.bashrc or ~/.zshrc
export DB_HOMOLOG_URL="mysql://user:pass@host:3306/db"
export DB_PROD_URL="mysql://user:pass@host:3306/db"
export DB_LOCAL_URL="postgresql://user:pass@localhost:5432/dev"
```

Then in `dadbod.lua`:

```lua
vim.g.dbs = {
  HOMOLOG = os.getenv("DB_HOMOLOG_URL"),
  PROD = os.getenv("DB_PROD_URL"),
  LOCAL_DEV = os.getenv("DB_LOCAL_URL"),
}
```

### Supported Database Types

vim-dadbod supports the following database drivers via URL scheme:

| Scheme | Database | Example |
|--------|----------|---------|
| `mysql://` | MySQL / MariaDB | `mysql://user:pass@host:3306/db` |
| `postgresql://` or `postgres://` | PostgreSQL | `postgresql://user:pass@host:5432/db` |
| `sqlite://` | SQLite | `sqlite:///path/to/file.db` |
| `mongodb://` | MongoDB | `mongodb://user:pass@host:27017/db` |

> **Note**: You may need to install database client tools (mysql-client, postgresql-client, etc.) for vim-dadbod to connect.

---

## Usage Guide

### Opening the Database UI

1. Press `<leader>bt` to toggle the DB UI
2. The sidebar opens showing available connections
3. Press Enter on a connection name to connect
4. Browse tables, views, and functions

### Running Queries

1. Open a `.sql` file or use the DB UI's query buffer
2. Write your SQL query:

```sql
SELECT * FROM users
WHERE active = 1
LIMIT 10;
```

3. Press `<leader>r` (in DB UI buffer) or select the query and press Enter
4. Results appear in a split buffer

### Viewing Last Query

Press `<leader>bl` to see information about the last executed query, including execution time and row count.

### Navigating Results

- Use standard Vim keymaps (`j/k`, `Ctrl+d/u`, `G`, `gg`) to navigate results
- Press `<leader>bf` to jump to the active database buffer
- Press `<leader>bt` to toggle the sidebar

### Switching Connections

In the DB UI sidebar:

1. Press Enter on a connection name to connect
2. Press `d` on a connection to disconnect
3. Press `R` to rename a connection

### DB UI Sidebar Keymaps

When the DB UI sidebar is open, these keymaps apply:

| Key | Action |
|-----|--------|
| `Enter` | Expand/connect to item |
| `d` | Disconnect |
| `R` | Rename connection |
| `S` | Toggle schema |
| `q` | Close DB UI |

---

## Security Warning

> **IMPORTANT**: The default `lua/plugins/dadbod.lua` file contains hardcoded database credentials (usernames, passwords, and hostnames). This is a security risk if the repository is shared or made public.

### Recommended Remediation

1. **Move credentials to environment variables immediately**:

```bash
# In ~/.bashrc or ~/.zshrc (or use a secrets manager)
export DB_HOMOLOG_URL="mysql://user:pass@host:3306/db"
export DB_PROD_URL="mysql://user:pass@host:3306/db"
```

2. **Update `dadbod.lua` to use environment variables**:

```lua
vim.g.dbs = {
  HOMOLOG = os.getenv("DB_HOMOLOG_URL") or "",
  PROD = os.getenv("DB_PROD_URL") or "",
}
```

3. **Never commit `.env` files or files containing real passwords to version control**.

4. **Use a `.env` file with a secrets manager** (like `dotenv` or `pass`) for team environments.

---

## Troubleshooting

### "DB UI not opening"

1. Check that vim-dadbod and vim-dadbod-ui are installed: `:Lazy check vim-dadbod`
2. Press `<leader>bt` to toggle
3. Try `:DBUI` directly

### "Cannot connect to database"

1. Verify the connection URL is correct
2. Check that the database client tool is installed:
   - MySQL: `!which mysql`
   - PostgreSQL: `!which psql`
   - SQLite: `!which sqlite3`
3. Test the connection from the terminal:
   ```bash
   mysql -u user -p -h host -P port database
   ```
4. Check that the host is reachable: `!ping host`

### "Auto-completion not working"

1. Verify vim-dadbod-completion is installed: `:Lazy check vim-dadbod-completion`
2. Check that the filetype is set to `sql`: `:set filetype?`
3. Try manually triggering completion: `Ctrl+x Ctrl+o`

### "Nerd Font icons not showing"

1. Verify `vim.g.db_ui_use_nerd_fonts = 1` is set
2. Check your terminal supports Nerd Fonts: `:echo &encoding`
3. Install a Nerd Font if needed: https://www.nerdfonts.com

### "Connection not appearing in sidebar"

1. Check `vim.g.dbs` is set correctly: `:lua print(vim.inspect(vim.g.dbs))`
2. Verify the connection URL format matches `scheme://user:pass@host:port/db`
3. Restart Neovim after adding connections to the config

### "Query results are garbled"

1. Check database encoding: ensure `SET NAMES utf8mb4` for MySQL
2. For PostgreSQL, ensure `client_encoding = 'UTF8'`
3. Check Neovim encoding: `:set encoding?` (should be `utf-8`)