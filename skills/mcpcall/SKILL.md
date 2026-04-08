---
name: mcp-to-skill
description: Guide and template for converting MCP servers into self-contained Claude Code skills with a Python wrapper script. TRIGGER when creating a new MCP skill, wrapping an MCP server as a skill, or need the mcpcall script template.
---

# MCP-to-Skill Template

Guide for converting any MCP server into a self-contained Claude Code skill with a Python wrapper in `scripts/mcpcall.py`.

Each MCP skill bundles its own `scripts/mcpcall.py` with the server URL baked in. No shared dependency, no cross-skill references — fully portable.

## Architecture

```
skills/my-mcp-skill/
├── SKILL.md              # frontmatter + tool docs
└── scripts/
    └── mcpcall.py        # self-contained PEP 723 script with server URL
```

The script uses `httpx` (respects `http_proxy`/`https_proxy`) and MCP Streamable HTTP transport. Dependencies are resolved by `uv` on first run via PEP 723 inline metadata — zero pre-installation.

## Quick Start

1. Copy the appropriate template from `references/` into `skills/my-skill/scripts/mcpcall.py`
2. Edit `SERVER_URL` (and `SERVER_NAME`, `NEEDS_AUTH` if applicable)
3. Write `SKILL.md` with tool docs (see `references/mcp-to-skill.md`)

## Templates

Two variants in `references/`:

- **`template-noauth.py`** — for servers without authentication (grep.app, DeepWiki)
- **`template-auth.py`** — for servers requiring API keys (Jina AI), includes `--setup` and config reading

## Live Examples

| Skill | Server | Auth | Script |
|---|---|---|---|
| `jina-ai` | mcp.jina.ai | API key | `template-auth.py` variant |
| `grep-app` | mcp.grep.app | None | `template-noauth.py` variant |
| `deepwiki` | mcp.deepwiki.com | None | `template-noauth.py` variant |
