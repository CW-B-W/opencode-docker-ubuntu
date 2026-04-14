# OpenCode Docker

Self-hosted [OpenCode](https://opencode.ai) running on Ubuntu 24.04 with Docker and persistent storage.

## Features

- Ubuntu 24.04 base with official OpenCode installer
- Persistent storage for system directories and configs
- MCP server support (Brave Search, Tavily, etc.)
- Easy setup with Makefile
- Restart skill for container management

## Quick Start

```bash
# Clone this repo
git clone https://github.com/CW-B-W/opencode-docker-ubuntu.git
cd opencode-docker-ubuntu

# Build and initialize
docker build -t opencode-ubuntu .
./scripts/init-persistent.sh

# Configure
cp .env.example .env
# Edit .env with your API keys

# Start
docker compose up -d
```

Access at `http://localhost:4096` (or your configured `OPENCODE_IP:PORT`).

## Configuration

### Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
OPENCODE_IP=127.0.0.1      # IP to bind to (use 0.0.0.0 for external access)
OPENCODE_PORT=4096         # Port to expose

# API keys for MCPs
BRAVE_API_KEY=             # Brave Search API key
TAVILY_API_KEY=            # Tavily API key
```

### MCP Servers

MCP servers are configured in `opencode.json` using the `{env:VAR_NAME}` syntax to reference environment variables:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "brave-search": {
      "type": "local",
      "command": ["npx", "-y", "@brave/brave-search-mcp-server", "--transport", "stdio"],
      "environment": {
        "BRAVE_API_KEY": "{env:BRAVE_API_KEY}"
      }
    }
  }
}
```

## Usage

```bash
docker compose up -d       # Start
docker compose down        # Stop
docker compose restart     # Restart
docker compose logs -f     # View logs
docker compose exec opencode bash  # Shell
```

## Persistent Storage

Docker containers are ephemeral - any changes inside the container are lost when it restarts. This repo uses `persistent_root/` to persist data across restarts.

**Why?** OpenCode can install things for you:
- Install npm packages, Python packages, or tools
- Add MCP servers (Brave Search, Tavily, etc.)
- Install or update skills
- Configure settings

Without persistence, all of these would be lost on every container restart.

The `persistent_root/` directory stores:
- `/root` - User home, configs, skills, installed tools
- `/etc` - System config
- `/usr` - Application binaries
- `/var` - Runtime data

Config files are symlinked for easy access:
- `opencode.json` → `persistent_root/root/.config/opencode/opencode.json`
- `auth.json` → `persistent_root/root/.local/share/opencode/auth.json`

## Restart Skill

A skill is included to restart OpenCode from within:

```
~/.config/opencode/skills/restart-opencode/restart-opencode.sh
```

Simply use `/restart-opencode` in OpenCode.

This kills the opencode process, triggering container restart.

## Network Security

- Default binds to `127.0.0.1` for local-only access
- For external access, set `OPENCODE_IP=0.0.0.0` in `.env`
- Use nginx + auth for public deployments

