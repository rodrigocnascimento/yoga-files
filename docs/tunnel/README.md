# Cloudflare Tunnel — Yoga 3.0

> Yoga wrapper for `cf-tunnels` with UI integration, logging, and dashboard

---

## What is yoga tunnel

`yoga tunnel` is a Yoga 3.0 CLI command that wraps `~/cf-tunnels/run.sh` — an independent Cloudflare Tunnel manager — with the Yoga UI layer (colors, emojis, structured logging). It provides a unified interface for creating, managing, and monitoring Cloudflare tunnels without leaving the Yoga ecosystem.

The wrapper adds:
- **Yoga UI** — Colorized output using `yoga_fogo`, `yoga_agua`, `yoga_terra` functions
- **Structured logging** — All tunnel commands are logged to `${YOGA_HOME}/logs/yoga.jsonl`
- **Error handling** — Validates that `cf-tunnels` is installed before attempting any operation
- **Dashboard** — `yoga tunnel hud` provides a TUI dashboard for tunnel status

## Requirements

The tunnel command requires `~/cf-tunnels/` to be installed and configured:

```bash
# Install cf-tunnels
git clone <cf-tunnels-repo> ~/cf-tunnels
cd ~/cf-tunnels && ./install.sh
```

The directory `~/cf-tunnels/` must contain a `run.sh` script. If it's missing, `yoga tunnel` will show an error with installation instructions.

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `YOGA_HOME` | `~/.yoga` | Yoga configuration and data directory |
| `CF_TUNNEL_PATH` | `~/cf-tunnels` | Path to cf-tunnels installation (used internally) |

## Quick Start

```bash
# List existing tunnels
yoga tunnel list

# Add a new tunnel
yoga tunnel add --hostname api.example.com --type http --service localhost:3000

# Start a tunnel
yoga tunnel start api.example.com

# View the dashboard
yoga tunnel hud

# Check tunnel status
yoga tunnel status

# View logs
yoga tunnel logs

# Stop a tunnel
yoga tunnel stop api.example.com

# Remove a tunnel configuration
yoga tunnel remove api.example.com
```

## Commands Overview

| Command | Description |
|---------|-------------|
| `yoga tunnel list` | List all configured tunnels |
| `yoga tunnel add` | Add a new tunnel configuration |
| `yoga tunnel remove` | Remove a tunnel |
| `yoga tunnel start` | Start a tunnel |
| `yoga tunnel stop` | Stop a running tunnel |
| `yoga tunnel status` | Check tunnel status |
| `yoga tunnel logs` | View tunnel logs |
| `yoga tunnel hud` | Dashboard TUI |

## Documentation

| Document | Description |
|----------|-------------|
| [usage.md](usage.md) | Complete command reference with all options |
| [examples.md](examples.md) | Practical tunnel examples for common scenarios |
| [integration.md](integration.md) | How yoga tunnel integrates with the Yoga system |

## How It Works

```
yoga tunnel <args>
     │
     ▼
┌─────────────────────┐
│   bin/yoga-tunnel    │  ← Yoga wrapper (UI + logging)
│                     │
│  1. Validate cf-tunnels exists
│  2. Display Yoga UI header
│  3. Delegate to ~/cf-tunnels/run.sh <args>
│  4. Log command to yoga.jsonl
└─────────────────────┘
         │
         ▼
┌─────────────────────┐
│ ~/cf-tunnels/run.sh  │  ← Independent tunnel manager
│                     │
│  - Manages cloudflared tunnels
│  - Reads/writes tunnel configs
│  - Starts/stops tunnel processes
└─────────────────────┘
```

The Yoga wrapper does not modify tunnel behavior — it adds UI, validation, and logging on top of the existing `cf-tunnels` tool.

## File Location

The tunnel command is implemented in:

```
bin/yoga-tunnel
```

Configuration is stored by `cf-tunnels` in:

```
~/cf-tunnels/
```

Yoga logs are written to:

```
~/.yoga/logs/yoga.jsonl
```