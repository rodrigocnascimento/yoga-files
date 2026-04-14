# Tunnel Usage — Complete Reference

> All `yoga tunnel` commands with options, arguments, and examples

---

## yoga tunnel list

List all configured tunnels.

```bash
yoga tunnel list
```

**Output:** A table of tunnel names, hostnames, types, target services, and status.

---

## yoga tunnel add

Add a new tunnel configuration.

```bash
yoga tunnel add --hostname <host> --type <protocol> --service <addr> [options]
```

**Required Arguments:**

| Argument | Description | Example |
|----------|-------------|---------|
| `--hostname` | Public hostname for the tunnel | `api.example.com` |
| `--type` | Protocol type | `http`, `https`, `tcp`, `ssh` |
| `--service` | Local service address to tunnel to | `localhost:3000` |

**Optional Arguments:**

| Argument | Description | Default |
|----------|-------------|---------|
| `--path` | Path prefix for HTTP tunnels | `/` |

**Examples:**

```bash
# Expose a local HTTP API
yoga tunnel add --hostname api.dev.example.com --type http --service localhost:3000

# Expose a local HTTPS service
yoga tunnel add --hostname secure.dev.example.com --type https --service localhost:8443

# Tunnel SSH access
yoga tunnel add --hostname ssh.example.com --type ssh --service localhost:22

# Tunnel with path prefix
yoga tunnel add --hostname app.example.com --type http --service localhost:8080 --path /api
```

---

## yoga tunnel remove

Remove a tunnel configuration.

```bash
yoga tunnel remove <hostname>
```

**Arguments:**

| Argument | Description |
|----------|-------------|
| `<hostname>` | The hostname of the tunnel to remove |

**Example:**

```bash
yoga tunnel remove api.dev.example.com
```

---

## yoga tunnel start

Start a tunnel.

```bash
yoga tunnel start <hostname>
```

**Arguments:**

| Argument | Description |
|----------|-------------|
| `<hostname>` | The hostname of the tunnel to start |

**Example:**

```bash
yoga tunnel start api.dev.example.com
```

This starts `cloudflared` in the background, routing traffic from the public hostname to the local service.

---

## yoga tunnel stop

Stop a running tunnel.

```bash
yoga tunnel stop <hostname>
```

**Arguments:**

| Argument | Description |
|----------|-------------|
| `<hostname>` | The hostname of the tunnel to stop |

**Example:**

```bash
yoga tunnel stop api.dev.example.com
```

Stops the `cloudflared` process associated with this tunnel.

---

## yoga tunnel status

Check the status of tunnels.

```bash
yoga tunnel status [hostname]
```

**Arguments:**

| Argument | Description |
|----------|-------------|
| `[hostname]` | Optional. If provided, shows status for a specific tunnel. If omitted, shows all tunnels. |

**Examples:**

```bash
# Status of all tunnels
yoga tunnel status

# Status of a specific tunnel
yoga tunnel status api.dev.example.com
```

---

## yoga tunnel logs

View tunnel logs.

```bash
yoga tunnel logs [hostname] [options]
```

**Arguments:**

| Argument | Description |
|----------|-------------|
| `[hostname]` | Optional. Filter logs for a specific tunnel |

**Options:**

| Flag | Description | Default |
|------|-------------|---------|
| `--tail` | Follow logs in real-time | `false` |
| `--n <count>` | Number of log lines to show | `50` |

**Examples:**

```bash
# Recent logs
yoga tunnel logs

# Follow logs in real-time
yoga tunnel logs --tail

# Logs for a specific tunnel
yoga tunnel logs api.dev.example.com

# Last 100 lines
yoga tunnel logs --n 100
```

---

## yoga tunnel hud

Display the tunnel dashboard TUI.

```bash
yoga tunnel hud
```

The hud provides an interactive terminal dashboard showing:
- All configured tunnels and their status
- Real-time traffic statistics
- Quick actions (start, stop, view logs)

Press `q` to exit the dashboard.

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `YOGA_HOME` | `~/.yoga` | Root directory for Yoga data, logs, and config |
| `CF_TUNNEL_PATH` | `~/cf-tunnels` | Path to the cf-tunnels installation |

Setting `CF_TUNNEL_PATH` allows you to override the default location:

```bash
# Use a custom cf-tunnels location
export CF_TUNNEL_PATH=/opt/cf-tunnels
yoga tunnel list
```

---

## Configuration File Location

Tunnel configurations are managed by `cf-tunnels` and stored in:

```
~/cf-tunnels/
```

Yoga-specific logs are written to:

```
~/.yoga/logs/yoga.jsonl
```

Each log entry includes:
- `timestamp` — ISO 8601 timestamp
- `level` — Log level (INFO, ERROR)
- `module` — Always `"tunnel"`
- `command` — Always `"tunnel"`
- `args` — The arguments passed to the command

---

## Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Error (cf-tunnels not found, run.sh missing, or command failed) |

---

## Prerequisites

Before using `yoga tunnel`, ensure:

1. **cloudflared** is installed and authenticated:
   ```bash
   cloudflared tunnel login
   ```

2. **cf-tunnels** is installed:
   ```bash
   git clone <cf-tunnels-repo> ~/cf-tunnels
   cd ~/cf-tunnels && ./install.sh
   ```

3. **DNS** is configured for your hostname (cloudflared can do this automatically during setup)