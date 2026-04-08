# Converting an MCP Server into a Skill with mcpcall

Guide for wrapping any MCP server as a Claude Code skill backed by the `mcpcall` CLI.

## Prerequisites

1. The MCP server is registered in `~/.config/mcpcall/servers.json` (or `~/.claude.json` mcpServers as fallback):

```json
{
  "myserver": {
    "type": "http",
    "url": "https://mcp.example.com/v1",
    "headers": { "Authorization": "Bearer <key>" }
  }
}
```

2. The `mcpcall` skill exists as a sibling skill (provides `scripts/mcpcall.py`).

## Step 1: Discover Tools

List all tools the server exposes:

```bash
uv run --script path/to/mcpcall/scripts/mcpcall.py --list myserver
```

This prints each tool name and a short description. Use this to decide which tools to document.

## Step 2: Create the Skill Directory

```
skills/my-mcp-skill/
└── SKILL.md
```

## Step 3: Write SKILL.md

### Frontmatter

````yaml
---
name: my-mcp-skill
description: <what it does>. TRIGGER when <when to activate>.
allowed-tools:
  - Bash(uv run --script*mcpcall.py myserver.*:*)
---
````

Key points:
- `name` — kebab-case, matches directory name.
- `description` — concise sentence on capability + explicit TRIGGER clause so Claude loads the skill at the right time.
- `allowed-tools` — glob pattern that auto-approves `mcpcall` invocations scoped to this server. The `*` between `--script` and `mcpcall.py` absorbs the path prefix.

### Body

Define a `MCPCALL` shorthand at the top, then document each tool with parameters and a bash example.

````markdown
# My MCP Skill

Call MyServer MCP tools via `mcpcall` for <purpose>.

**Command shorthand** used throughout this doc:

```bash
MCPCALL="uv run --script ${CLAUDE_PLUGIN_ROOT}/../mcpcall/scripts/mcpcall.py"
```

## tool_name
<one-line description>
- `param1` (required): <description>
- `param2`: <description> (default: `value`)

```bash
$MCPCALL myserver.tool_name param1:"value" param2:10
```
````

### Argument Styles

mcpcall supports two argument styles:

**Key-value** — for flat parameters (strings, numbers, booleans):

```bash
$MCPCALL myserver.search query:"search terms" num:10 verbose:true
```

Type coercion: `true`/`false` → bool, integers → int, floats → float, else string.

**JSON** — for nested objects or arrays:

```bash
$MCPCALL myserver.classify --args '{"texts": ["a", "b"], "labels": ["x", "y"]}'
```

Use `--args` whenever a parameter is an array or object.

## Step 4: Add a Tool Selection Guide (optional)

For servers with many tools, add a table mapping scenarios to tool names:

````markdown
## Tool Selection Guide

| Scenario | Tool |
|---|---|
| Single page read | `read_url` |
| Batch page read | `parallel_read_url` |
| General search | `search_web` |
````

## Step 5: Add Tips Section (optional)

Include domain-specific tips for effective usage:

````markdown
## Tips

- Use `expand_query` before `parallel_search` for thorough research.
- Set `tbs:qdr:w` to restrict results to the past week.
````

## Complete Minimal Example

A minimal skill wrapping a hypothetical `weather` MCP server:

````yaml
---
name: weather
description: Get weather forecasts and conditions via MCP. TRIGGER when user asks about weather, forecasts, or climate data.
allowed-tools:
  - Bash(uv run --script*mcpcall.py weather.*:*)
---
````

````markdown
# Weather

**Command shorthand:**

```bash
MCPCALL="uv run --script ${CLAUDE_PLUGIN_ROOT}/../mcpcall/scripts/mcpcall.py"
```

## current
Get current weather for a location.
- `location` (required): city name or coordinates

```bash
$MCPCALL weather.current location:"Tokyo"
```

## forecast
Get multi-day forecast.
- `location` (required): city name or coordinates
- `days`: number of days (default: 5)

```bash
$MCPCALL weather.forecast location:"Shanghai" days:7
```
````

## Reference: jina-ai Skill

The `jina-ai` skill (`skills/jina-ai/SKILL.md`) is a full production example covering 20+ tools across web reading, search, academic research, NLP, and screenshots. Use it as the canonical template.
