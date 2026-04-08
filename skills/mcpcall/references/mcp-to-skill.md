# Converting an MCP Server into a Skill

Guide for wrapping any MCP server as a self-contained Claude Code skill.

## Step 1: Create Skill Directory

```
skills/my-mcp-skill/
├── SKILL.md
└── scripts/
    └── mcpcall.py    # copy from template
```

## Step 2: Copy the Script Template

Pick the right template from this directory:

- **No auth needed** → copy `template-noauth.py`
- **API key required** → copy `template-auth.py`

Edit the constants at the top:

```python
# template-noauth.py
SERVER_URL = "https://mcp.example.com/v1"

# template-auth.py
SERVER_NAME = "myserver"
SERVER_URL = "https://mcp.example.com/v1"
SETUP_PROMPT = "Enter API key"
SETUP_URL = "https://example.com/api-keys"
```

Make it executable: `chmod +x scripts/mcpcall.py`

## Step 3: Discover Tools

```bash
uv run --script scripts/mcpcall.py --list
```

## Step 4: Write SKILL.md

### Frontmatter

````yaml
---
name: my-mcp-skill
description: <what it does>. TRIGGER when <when to activate>.
allowed-tools:
  - Bash(uv run --script*mcpcall.py *:*)
---
````

### Body

````markdown
# My MCP Skill

<one-line description>. No API key required.

**Command shorthand:**

```bash
MCPCALL="uv run --script ${CLAUDE_PLUGIN_ROOT}/scripts/mcpcall.py"
```

## Setup (auth variant only)

If mcpcall reports authentication error, run:

```bash
$MCPCALL --setup
```

## tool_name
<description>
- `param` (required): <what it is>

```bash
$MCPCALL tool_name param:"value"
```
````

### Argument Styles

**Key-value** — flat parameters:

```bash
$MCPCALL search query:"search terms" num:10 verbose:true
```

**JSON** — arrays or objects:

```bash
$MCPCALL classify --args '{"texts": ["a", "b"], "labels": ["x", "y"]}'
```

Both can be combined — kv_args as base, `--args` JSON merged on top.

## Live Examples

| Skill | Template | Server |
|---|---|---|
| `jina-ai` | auth | `https://mcp.jina.ai/v1` |
| `grep-app` | noauth | `https://mcp.grep.app` |
| `deepwiki` | noauth | `https://mcp.deepwiki.com/mcp` |
