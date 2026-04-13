-- 🗄️ core/state/schema.sql
-- @name: state-schema
-- @desc: SQLite schema for Yoga 2.0 State Management 💾
-- @version: 1.0.0

-- 🎯 Enable foreign keys and WAL mode
PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;

-- 📋 Schema version tracking
CREATE TABLE IF NOT EXISTS schema_version (
    version INTEGER PRIMARY KEY,
    applied_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    description TEXT
);

-- 🌌 Workspaces
CREATE TABLE IF NOT EXISTS workspaces (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    path TEXT NOT NULL UNIQUE,
    tmux_session TEXT,
    is_active BOOLEAN DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_accessed DATETIME,
    metadata TEXT  -- JSON: {env_vars, aliases, layout, etc.}
);

-- 📊 Workspace state history
CREATE TABLE IF NOT EXISTS workspace_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    workspace_id TEXT NOT NULL,
    event_type TEXT NOT NULL,  -- 'created', 'activated', 'deactivated', 'killed'
    tmux_state TEXT,           -- JSON com estado das janelas/panes
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON DELETE CASCADE
);

-- 🧘 Sessions (daemon tracking)
CREATE TABLE IF NOT EXISTS sessions (
    id TEXT PRIMARY KEY,
    workspace_id TEXT,
    pid INTEGER NOT NULL,
    socket_path TEXT,
    started_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_ping DATETIME,
    FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON DELETE SET NULL
);

-- 💾 Global state (key-value)
CREATE TABLE IF NOT EXISTS state (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    scope TEXT DEFAULT 'global',  -- 'global', 'workspace:{id}', 'session:{id}'
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME,          -- NULL = never expires
    metadata TEXT                 -- JSON blob
);

-- 📝 Logs (for RAG and debugging)
CREATE TABLE IF NOT EXISTS logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    level TEXT NOT NULL CHECK(level IN ('DEBUG', 'INFO', 'WARN', 'ERROR')),
    module TEXT NOT NULL,         -- 'cc', 'workspace', 'ai', 'daemon', etc.
    command TEXT,                 -- comando que gerou o log
    input TEXT,                   -- input do usuário
    output TEXT,                  -- output gerado
    status TEXT,                  -- 'success', 'error', 'pending'
    duration_ms INTEGER,          -- duração em milissegundos
    payload TEXT                  -- JSON com dados extras
);

-- 🔍 FTS5 for RAG (Full Text Search)
CREATE VIRTUAL TABLE IF NOT EXISTS logs_fts USING fts5(
    content,                      -- Conteúdo indexado
    tokenize='porter'             -- Stemming para busca
);

-- Trigger para manter FTS sincronizado
CREATE TRIGGER IF NOT EXISTS logs_fts_insert AFTER INSERT ON logs
BEGIN
    INSERT INTO logs_fts(rowid, content)
    VALUES (NEW.id, 
        COALESCE(NEW.module, '') || ' ' || 
        COALESCE(NEW.command, '') || ' ' || 
        COALESCE(NEW.input, '') || ' ' || 
        COALESCE(NEW.output, '')
    );
END;

CREATE TRIGGER IF NOT EXISTS logs_fts_delete AFTER DELETE ON logs
BEGIN
    DELETE FROM logs_fts WHERE rowid = OLD.id;
END;

-- 🔌 Plugins
CREATE TABLE IF NOT EXISTS plugins (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    version TEXT NOT NULL,
    description TEXT,
    author TEXT,
    source TEXT,                  -- 'git://...', 'npm://...', 'file://...'
    install_path TEXT NOT NULL,
    is_enabled BOOLEAN DEFAULT 1,
    is_loaded BOOLEAN DEFAULT 0,
    installed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    hooks TEXT,                   -- JSON: {pre_command, post_command, on_load}
    metadata TEXT                 -- JSON com manifest completo
);

-- 📊 Plugin state
CREATE TABLE IF NOT EXISTS plugin_state (
    plugin_id TEXT PRIMARY KEY,
    state TEXT,                   -- JSON com estado do plugin
    last_run DATETIME,
    run_count INTEGER DEFAULT 0,
    FOREIGN KEY (plugin_id) REFERENCES plugins(id) ON DELETE CASCADE
);

-- 🤖 AI Context (for RAG)
CREATE TABLE IF NOT EXISTS ai_context (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    source TEXT NOT NULL,         -- 'log', 'command_history', 'workspace', 'manual'
    content TEXT NOT NULL,
    embedding BLOB,               -- Para futura vector search
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    workspace_id TEXT,
    relevance_score REAL,         -- 0.0 - 1.0
    FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON DELETE SET NULL
);

-- 🎯 Commands history (for CC module)
CREATE TABLE IF NOT EXISTS commands (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    type TEXT NOT NULL,           -- 'alias', 'function', 'git', 'docker', 'script', 'history'
    category TEXT,                -- 'git', 'docker', 'file', 'network', etc.
    command TEXT NOT NULL,
    description TEXT,
    usage_count INTEGER DEFAULT 1,
    last_used DATETIME DEFAULT CURRENT_TIMESTAMP,
    workspace_id TEXT,
    is_favorite BOOLEAN DEFAULT 0,
    FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON DELETE SET NULL
);

-- 🏷️ Tags system
CREATE TABLE IF NOT EXISTS tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    color TEXT DEFAULT 'blue'
);

CREATE TABLE IF NOT EXISTS command_tags (
    command_id INTEGER,
    tag_id INTEGER,
    PRIMARY KEY (command_id, tag_id),
    FOREIGN KEY (command_id) REFERENCES commands(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);

-- 📈 Performance metrics
CREATE TABLE IF NOT EXISTS metrics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    metric_type TEXT NOT NULL,    -- 'command_duration', 'daemon_uptime', 'memory_usage'
    value REAL NOT NULL,
    unit TEXT,                    -- 'ms', 'seconds', 'bytes', 'percent'
    metadata TEXT                 -- JSON
);

-- 🗑️ Cleanup policy (auto-expire old data)
CREATE TABLE IF NOT EXISTS cleanup_policy (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT NOT NULL UNIQUE,
    retention_days INTEGER NOT NULL,
    enabled BOOLEAN DEFAULT 1
);

-- Default policies
INSERT OR IGNORE INTO cleanup_policy (table_name, retention_days) VALUES
    ('logs', 30),
    ('commands', 90),
    ('ai_context', 60),
    ('metrics', 7),
    ('workspace_history', 30);

-- 📋 Initial schema version
INSERT OR IGNORE INTO schema_version (version, description) VALUES (1, 'Initial schema for Yoga 2.0 Efigenia Edition 🧘‍♂️');

-- 🎯 Indexes for performance
CREATE INDEX IF NOT EXISTS idx_state_scope ON state(scope);
CREATE INDEX IF NOT EXISTS idx_state_key_scope ON state(key, scope);
CREATE INDEX IF NOT EXISTS idx_logs_timestamp ON logs(timestamp);
CREATE INDEX IF NOT EXISTS idx_logs_module_time ON logs(module, timestamp);
CREATE INDEX IF NOT EXISTS idx_logs_level ON logs(level);
CREATE INDEX IF NOT EXISTS idx_workspaces_path ON workspaces(path);
CREATE INDEX IF NOT EXISTS idx_workspaces_active ON workspaces(is_active);
CREATE INDEX IF NOT EXISTS idx_commands_type ON commands(type);
CREATE INDEX IF NOT EXISTS idx_commands_category ON commands(category);
CREATE INDEX IF NOT EXISTS idx_commands_workspace ON commands(workspace_id);
CREATE INDEX IF NOT EXISTS idx_sessions_pid ON sessions(pid);
CREATE INDEX IF NOT EXISTS idx_plugins_enabled ON plugins(is_enabled);
CREATE INDEX IF NOT EXISTS idx_ai_context_timestamp ON ai_context(timestamp);
CREATE INDEX IF NOT EXISTS idx_metrics_type_time ON metrics(metric_type, timestamp);
