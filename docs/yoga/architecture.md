# Arquitetura — Yoga 3.0

## Visão Geral

O Yoga 3.0 adota arquitetura **CLI-first, daemon-required, standalone**. Cada módulo opera de forma independente, comunicando-se via Unix socket através de um daemon central que gerencia estado em SQLite.

## Diagrama de Arquitetura

```mermaid
flowchart TB
    subgraph CLI["bin/yoga (CLI Router)"]
        CMD_CC["yoga cc"]
        CMD_WS["yoga workspace"]
        CMD_AI["yoga ai"]
        CMD_DAEMON["yoga daemon"]
        CMD_STATE["yoga state"]
        CMD_PLUGIN["yoga plugin"]
        CMD_LOGS["yoga logs"]
    end

    subgraph INIT["init.sh (Shell Bootstrap)"]
        SRC_UTILS["source core/utils.sh"]
        SRC_ALIAS["source core/aliases.sh"]
        SRC_FUNCS["source core/functions.sh"]
        EXPORT_HOME["export YOGA_HOME"]
        EXPORT_PATH["export PATH"]
        EXPORT_WELCOMED["export YOGA_WELCOMED"]
    end

    INIT --> CLI

    subgraph DAEMON_CORE["Daemon (Unix Socket Server)"]
        SERVER["core/daemon/server.sh"]
        LIFECYCLE["core/daemon/lifecycle.sh"]
        CLIENT["core/daemon/client.sh"]
    end

    CLI -->|daemon commands| LIFECYCLE
    CLI -->|state/ws/ai/log/plugin| CLIENT
    CLIENT -->|socket request| SERVER

    subgraph STATE_LAYER["State Manager (SQLite)"]
        API["core/state/api.sh"]
        SCHEMA["core/state/schema.sql"]
        DB[("state.db")]
    end

    SERVER --> API
    API --> DB
    SCHEMA -->|init| DB

    subgraph MODULES["Modules (Standalone)"]
        CC["core/modules/cc/"]
        WS["core/modules/workspace/"]
        AI_MOD["core/modules/ai/"]
        LOG_MOD["core/modules/logging/"]
    end

    CMD_CC --> CC
    CMD_WS --> WS
    SERVER --> AI_MOD
    SERVER --> LOG_MOD
    CC --> API
    WS --> API

    subgraph AI_TERM["AI Terminal (Standalone)"]
        AI_TERM_SH["core/ai/yoga-ai-terminal.sh"]
        BIN_AI["bin/yoga-ai"]
    end

    BIN_AI --> AI_TERM_SH
```

## Diagrama de Fluxo de Dados

```mermaid
sequenceDiagram
    participant User
    participant CLI as bin/yoga
    participant Client as daemon/client.sh
    participant Daemon as daemon/server.sh
    participant State as state/api.sh
    participant DB as state.db

    Note over User,DB: Fluxo: yoga cc (standalone, sem daemon)
    User->>CLI: yoga cc
    CLI->>CC: source standalone.sh
    CC->>State: cc_standalone_run()
    State->>DB: SQLite queries
    DB-->>State: Resultados
    State-->>CC: Dados coletados
    CC-->>User: Interface fzf

    Note over User,DB: Fluxo: yoga ai ask (via daemon)
    User->>CLI: yoga ai ask "pergunta"
    CLI->>Client: yoga_client_ai_ask()
    Client->>Daemon: ai|ask|{"question":"pergunta"}|req_id
    Daemon->>State: ai_engine_ask()
    State-->>Daemon: resposta
    Daemon-->>Client: OK|{"response":"..."}|req_id
    Client-->>CLI: JSON resposta
    CLI-->>User: Resposta formatada
```

## Diagrama: yoga workspace switch

```mermaid
sequenceDiagram
    participant User
    participant CLI as bin/yoga
    participant Standalone as workspace/standalone.sh
    participant Tmux as tmux
    participant State as state/api.sh
    participant DB as state.db

    User->>CLI: yoga workspace switch my-project
    CLI->>Standalone: workspace_standalone_action_switch("my-project", path)
    Standalone->>Standalone: Valida diretório existe
    Standalone->>Tmux: tmux has-session -t my-project
    alt Sessão não existe
        Standalone->>Tmux: tmux new-session -ds my-project
        Standalone->>Tmux: tmux new-window (editor, terminal)
    end
    Standalone->>Tmux: tmux switch-client/attach
    Standalone->>State: workspace_standalone_update_state()
    State->>DB: INSERT/UPDATE workspaces
    State->>DB: INSERT workspace_history (activated)
    Standalone->>Standalone: workspace_standalone_log()
    Standalone-->>User: "Workspace ativado: my-project"
```

## Componentes

### init.sh

Arquivo de bootstrap, sourced no `.zshrc`. Responsabilidades:
- Define `YOGA_HOME` (default: `~/.yoga`)
- Sources `core/utils.sh`, `core/aliases.sh`, `core/functions.sh`
- Exporta `YOGA_HOME`, `PATH`, `YOGA_WELCOMED`
- **NÃO** carrega dashboard, **NÃO** instala alias trap

### bin/yoga (CLI Router)

Entry point principal da CLI. Sources:
- `core/utils/ui.sh`
- `core/daemon/lifecycle.sh`
- `core/daemon/client.sh`

Rotas de comando:

| Comando | Alias | Destino |
|---------|-------|---------|
| `daemon` | — | `yoga_daemon_command` |
| `cc` | — | `core/modules/cc/standalone.sh` |
| `workspace` | `ws` | `core/modules/workspace/standalone.sh` |
| `tunnel` | — | `bin/yoga-tunnel` |
| `ai` | `ask` | `yoga_client_ai_ask` (requer daemon) |
| `plugin` | `plugins` | `yoga_client_plugin_list` (requer daemon) |
| `state` | — | `yoga_client_state_get/set` (requer daemon) |
| `status` | — | `yoga_daemon_status` |
| `update` | — | git pull + restart daemon |
| `logs` | `log` | tail/show JSONL |
| `version` | `-v`, `--version` | Banner + info |
| `help` | `-h`, `--help` | Lista de comandos |

### Daemon

Arquivos: `core/daemon/{server.sh, client.sh, lifecycle.sh}`

#### server.sh — Servidor Unix Socket

Variáveis:
- `YOGA_SOCKET` → `${YOGA_HOME}/daemon.sock`
- `YOGA_PIDFILE` → `${YOGA_HOME}/daemon.pid`
- `YOGA_LOG` → `${YOGA_HOME}/logs/daemon.log`
- `PROTOCOL_VERSION` → `"1.0"`
- `DELIMITER` → `$'\x1E'` (ASCII Record Separator)

Funções:
- `yoga_daemon_server_start()` — Inicia servidor em background, aguarda socket
- `yoga_daemon_server_stop()` — Para servidor (graceful + force kill)
- `yoga_daemon_is_running()` — Verifica PID + socket
- `yoga_daemon_server_loop()` — Loop principal com socat
- `_yoga_daemon_handle_request()` — Parser de requests `MODULE|COMMAND|ARGS|REQ_ID`
- `_yoga_daemon_handle_state()` — Handler para módulo `state`
- `_yoga_daemon_handle_workspace()` — Handler para módulo `workspace`
- `_yoga_daemon_handle_cc()` — Handler para módulo `cc`
- `_yoga_daemon_handle_ai()` — Handler para módulo `ai`
- `_yoga_daemon_handle_log()` — Handler para módulo `log`
- `_yoga_daemon_handle_plugin()` — Handler para módulo `plugin`
- `_yoga_daemon_handle_daemon()` — Handler para módulo `daemon` (ping/stop/status)

#### client.sh — Cliente Unix Socket

Variáveis:
- `YOGA_SOCKET` → `${YOGA_HOME}/daemon.sock`
- `DELIMITER` → `$'\x1E'`
- `TIMEOUT` → `5`

Funções públicas:
- `_yoga_client_send(module, command, args_json)` — Envia request, recebe response
- `yoga_client_state_get(key, scope)` — Lê estado
- `yoga_client_state_set(key, value, scope)` — Escreve estado
- `yoga_client_workspace_list()` — Lista workspaces
- `yoga_client_workspace_create(name, path)` — Cria workspace
- `yoga_client_workspace_activate(id)` — Ativa workspace
- `yoga_client_cc_data()` — Dados do Command Center
- `yoga_client_ai_ask(question)` — Consulta IA
- `yoga_client_log_write(level, module, message)` — Escreve log
- `yoga_client_plugin_list()` — Lista plugins
- `yoga_client_daemon_ping()` — Ping no daemon
- `yoga_client_daemon_stop()` — Para daemon

#### lifecycle.sh — Gerenciamento de Ciclo de Vida

Funções:
- `yoga_daemon_start([--foreground])` — Inicia com check de dependências
- `yoga_daemon_stop([--force])` — Para com graceful/force
- `yoga_daemon_status()` — Status completo com estatísticas
- `yoga_daemon_restart()` — Stop + sleep + start
- `yoga_daemon_cleanup()` — Remove socket/pidfiles stale
- `yoga_daemon_command(action)` — CLI router para `yoga daemon <action>`

### State Manager

Arquivos: `core/state/{api.sh, schema.sql}`

API completa em `state-management.md`. Schema com 15 tabelas em `schema.sql`.

### Modules

Cada módulo tem versão standalone (sem daemon) e engine (via daemon):

| Módulo | Standalone | Engine |
|--------|-----------|--------|
| CC | `cc/standalone.sh` → `cc_standalone_run()` | `cc/engine.sh` (via daemon) |
| Workspace | `workspace/standalone.sh` → `workspace_standalone_list_interactive()` | `workspace/engine.sh` (via daemon) |
| AI | `ai/yoga-ai-terminal.sh` → `yoga_ai_terminal()` | `ai/engine.sh` → `ai_engine_ask()` |
| Logging | `logging/logger.sh` → `yoga_log()` | Integrado no daemon |

## Protocolo de Comunicação

### Formato de Mensagem

Mensagens são delimitadas por `<<<END>>>` no stream do socket.

Formato do request:
```
MODULE|COMMAND|ARGS_JSON|REQUEST_ID
```

Formato do response:
```
STATUS|RESPONSE_JSON|REQUEST_ID
```

### Categorias e Ações

| Categoria | Ações | Descrição |
|-----------|-------|-----------|
| `ping` | (nenhuma) | Health check, retorna `{"pong":true}` |
| `state` | `get`, `set`, `del`, `list` | Operações key-value |
| `workspace` | `list`, `create`, `activate`, `current`, `kill` | Gerenciamento de workspaces |
| `cc` | `data`, `execute` | Dados e execução do Command Center |
| `ai` | `ask`, `context_add`, `context_search` | Consultas IA e RAG |
| `log` | `write`, `query` | Logging estruturado |
| `plugin` | `list`, `enable`, `disable` | Gerenciamento de plugins |
| `daemon` | `ping`, `stop`, `status` | Controle do próprio daemon |

### Exemplo Request/Response

Request (state get):
```
state|get|{"key":"last_workspace","scope":"global"}|1681500000000
```

Response:
```
OK|{"key":"last_workspace","value":"my-project","scope":"global"}|1681500000000
```

## Sequência de Startup

```mermaid
sequenceDiagram
    participant User
    participant Lifecycle as lifecycle.sh
    participant Server as server.sh
    participant State as state/api.sh
    participant DB as state.db

    User->>Lifecycle: yoga daemon start
    Lifecycle->>Lifecycle: Verifica dependências (sqlite3, socat/nc, jq)
    Lifecycle->>Server: yoga_daemon_server_start()
    Server->>Server: Verifica se já rodando (PID + socket)
    Server->>Server: Limpa socket antigo
    Server->>Server: Fork em background
    Server->>State: _yoga_state_init()
    State->>DB: Cria DB se não existe
    DB-->>State: DB pronto
    State-->>Server: State API disponível
    Server->>Server: Aguarda socket ficar disponível (10 tentativas)
    Server-->>Lifecycle: PID + socket prontos
    Lifecycle-->>User: "Daemon iniciado! PID: X | Socket: Y"
```

## Sequência de Shutdown

```mermaid
sequenceDiagram
    participant User
    participant Lifecycle as lifecycle.sh
    participant Server as server.sh

    User->>Lifecycle: yoga daemon stop
    Lifecycle->>Server: yoga_daemon_server_stop()
    Server->>Server: Verifica se rodando
    Server->>Server: Kill -TERM (graceful)
    Server->>Server: Aguarda (2 segundos, 20 tentativas)
    alt Ainda rodando
        Server->>Server: Kill -9 (forçado)
    end
    Server->>Server: Remove socket e pidfile
    Server-->>Lifecycle: "Daemon parado"
    Lifecycle-->>User: Confirmado
```

## Dependências Detalhadas

| Dependência | Uso | Módulo |
|-------------|-----|--------|
| `zsh` | Shell principal | Todos |
| `fzf` | Interface interativa | CC, Workspace |
| `tmux` | Sessões de workspace | Workspace |
| `jq` | Parse/formatação JSON | Daemon, State, AI, Logging |
| `sqlite3` | Banco de dados | State, CC, AI |
| `socat` | Comunicação socket Unix | Daemon (preferível) |
| `nc` | Comunicação socket (fallback) | Daemon |
| `git` | Versão controle, auto-update | bin/yoga, Update |
| `asdf` | Gerenciamento de versões | init.sh, bin/yoga-asdf |
| `nvim` | Editor integrado | CC (Ctrl-E), aliases |
| `curl` | HTTP requests | AI (Ollama, OpenAI) |