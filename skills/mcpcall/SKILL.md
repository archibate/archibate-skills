---
name: mcpcall
description: Guide and template for converting MCP servers into self-contained Claude Code skills with a Python wrapper script. TRIGGER when creating a new MCP skill, wrapping an MCP server as a skill, or need the mcpcall script template.
---

# mcpcall

Convert any MCP server into a self-contained Claude Code skill with a Python wrapper in `scripts/mcpcall.py`.

Each MCP skill bundles its own `scripts/mcpcall.py` with the server URL baked in. No shared dependency, no cross-skill references — fully portable. Uses `httpx` (respects `http_proxy`/`https_proxy`) and MCP Streamable HTTP transport. Dependencies resolved by `uv` on first run via PEP 723 inline metadata.

## Quick Start

1. Create `skills/my-mcp-skill/scripts/`
2. Copy the appropriate template into `scripts/mcpcall.py`:
   - **No auth needed** → `references/template-noauth.py`
   - **API key required** → `references/template-auth.py`
3. Edit the constants at the top of the script
4. Discover tools: `uv run --script scripts/mcpcall.py --list`
5. Write `SKILL.md` with tool docs

## Step 1: Copy and Configure the Script

### No-auth variant

Edit `SERVER_URL`:

```python
SERVER_URL = "https://mcp.example.com/v1"
```

### Auth variant

Edit all four constants:

```python
SERVER_NAME = "myserver"
SERVER_URL = "https://mcp.example.com/v1"
SETUP_PROMPT = "Enter API key"
SETUP_URL = "https://example.com/api-keys"
```

Make it executable: `chmod +x scripts/mcpcall.py`

## Step 2: Write SKILL.md

### Frontmatter

````yaml
---
name: my-mcp-skill
description: <what it does>. TRIGGER when <when to activate>.
allowed-tools:
  - Bash(uv run --script*mcpcall.py *:*)
---
````

- `name` — kebab-case, matches directory name.
- `description` — concise capability + explicit TRIGGER clause.
- `allowed-tools` — glob pattern auto-approving mcpcall invocations.

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

**Key-value** — flat parameters (strings, numbers, booleans):

```bash
$MCPCALL search query:"search terms" num:10 verbose:true
```

Type coercion: `true`/`false` → bool, integers → int, floats → float, else string.

**JSON** — arrays or objects:

```bash
$MCPCALL classify --args '{"texts": ["a", "b"], "labels": ["x", "y"]}'
```

Both can be combined — kv_args as base, `--args` JSON merged on top.

## Skill Directory Layout

```
skills/my-mcp-skill/
├── SKILL.md              # frontmatter + tool docs
└── scripts/
    └── mcpcall.py        # self-contained PEP 723 script
```

## Live Examples

| Skill | Template | Server |
|---|---|---|
| `jina-ai` | auth | `https://mcp.jina.ai/v1` |
| `grep-app` | noauth | `https://mcp.grep.app` |
| `deepwiki` | noauth | `https://mcp.deepwiki.com/mcp` |
