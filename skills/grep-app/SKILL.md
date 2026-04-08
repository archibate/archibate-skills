---
name: grep-app
description: Search real-world code examples from over a million public GitHub repositories via grep.app MCP. TRIGGER when need to find code usage patterns, see how developers use a library/API in practice, find production examples of a specific function or syntax, or search GitHub code at scale.
allowed-tools:
  - Bash(uv run --script*mcpcall.py grep.*:*)
---

# grep.app

Search real-world code examples from over a million public GitHub repositories. Powered by [grep.app](https://grep.app) MCP.

## Setup

If mcpcall reports `server 'grep' not found`, add it (no API key required):

```bash
$MCPCALL --add grep --url https://mcp.grep.app
```

**Command shorthand** used throughout this doc:

```bash
MCPCALL="uv run --script ${CLAUDE_PLUGIN_ROOT}/../mcpcall/scripts/mcpcall.py"
```

## searchGitHub

Find real-world code examples by searching for **literal code patterns** (like grep), not keywords.

- `query` (required): literal code pattern (e.g. `useState(`, `import React from`, `async function`)
- `language`: array of language filters (e.g. `Python`, `TypeScript`, `TSX`, `Java`, `Go`, `Rust`, `C#`, `YAML`, `Markdown`)
- `repo`: filter by repository (e.g. `facebook/react`, `vercel/`) — partial names match
- `path`: filter by file path (e.g. `src/components/Button.tsx`, `/route.ts`) — partial paths match
- `useRegexp`: interpret query as regex (default: `false`). Prefix with `(?s)` for multiline
- `matchCase`: case-sensitive search (default: `false`)
- `matchWholeWords`: match whole words only (default: `false`)

### Basic usage

```bash
$MCPCALL grep.searchGitHub query:"useState("
$MCPCALL grep.searchGitHub query:"getServerSession" --args '{"language": ["TypeScript", "TSX"]}'
$MCPCALL grep.searchGitHub query:"CORS(" matchCase:true --args '{"language": ["Python"]}'
```

### Filter by repo or path

```bash
$MCPCALL grep.searchGitHub query:"createContext" repo:"facebook/react"
$MCPCALL grep.searchGitHub query:"export default" path:"/route.ts" --args '{"language": ["TypeScript"]}'
```

### Regex patterns

```bash
$MCPCALL grep.searchGitHub query:"(?s)useEffect\\(\\(\\) => \\{.*removeEventListener" useRegexp:true
$MCPCALL grep.searchGitHub query:"(?s)try \\{.*await" useRegexp:true --args '{"language": ["TypeScript"]}'
```

## Tips

- Search for **actual code** that appears in files, not keywords or questions
  - Good: `useState(`, `import React from`, `async function`
  - Bad: `react tutorial`, `best practices`, `how to use`
- Use `(?s)` prefix in regex to match across multiple lines
- Filter by `language` to narrow results to relevant file types
- Filter by `repo` with org prefix (e.g. `vercel/`) to search within an organization
- Combine `matchCase:true` with specific function names for precise matches
