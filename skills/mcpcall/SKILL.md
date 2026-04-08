---
name: mcpcall
description: Call MCP server tools from the command line via Python. TRIGGER when need to call MCP tools via Bash, or when mcporter fails due to proxy/network issues. Provides a proxy-aware alternative to mcporter using httpx + Streamable HTTP transport.
allowed-tools:
  - Bash(uv run --script ${CLAUDE_PLUGIN_ROOT}/scripts/mcpcall.py*:*)
---

# mcpcall

Call MCP server tools from the CLI. A proxy-aware Python alternative to `npx mcporter call`.

Uses `httpx` (respects `http_proxy`/`https_proxy`) and MCP Streamable HTTP transport. Zero pre-installation via PEP 723 inline metadata — `uv` resolves dependencies on first run.

## Usage

```bash
# Call a tool with key:value args
uv run --script ${CLAUDE_PLUGIN_ROOT}/scripts/mcpcall.py jina.primer
uv run --script ${CLAUDE_PLUGIN_ROOT}/scripts/mcpcall.py jina.search_web query:"search terms" num:10

# Call a tool with JSON args (for arrays/objects)
uv run --script ${CLAUDE_PLUGIN_ROOT}/scripts/mcpcall.py jina.classify_text --args '{"texts": ["a", "b"], "labels": ["x", "y"]}'

# List all tools on a server
uv run --script ${CLAUDE_PLUGIN_ROOT}/scripts/mcpcall.py --list jina
```

## Server Config

Reads from `~/.config/mcpcall/servers.json` (primary), falls back to `~/.claude.json` mcpServers.

If a server is not configured, mcpcall prints the missing server name and a hint to add it. Each MCP skill's Setup section documents the exact entry to add.

To add a new server:

```bash
mkdir -p ~/.config/mcpcall
# Edit ~/.config/mcpcall/servers.json and add:
{
  "myserver": {
    "url": "https://mcp.example.com/v1",
    "headers": { "Authorization": "Bearer <key>" }
  }
}
```

`headers` is optional — omit it for servers that don't require authentication.

## Why not mcporter?

- Node.js `fetch`/`eventsource` ignores `http_proxy`/`https_proxy` env vars
- mcporter uses legacy SSE transport; many MCP servers now use Streamable HTTP
- `httpx` in Python respects proxy settings out of the box
