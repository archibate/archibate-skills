# User Preferences

## Modern Alternatives

- `rg` not `grep`
- `fd` not `find`
- `exa` not `ls`
- `sd` not `sed`
- `xh` not `curl`
- `just` not `make`
- `uv` not `pip`
- `uv run` not `python3`
- `pnpm` not `npm`

Fallback to the legacy tools when not available.

---

## Agent CLI Tools

- `ast-grep` (`sg`)
- `duckdb`
- `mlr` (miller)
- `jc`
- `gron`
- `pueue`
- `gh`
- `pdftotext`
- `sqlite3`
- `hyperfine`

---

## Python Preferences

- Indentation: 4 spaces
- Package Manager: `uv`
- Formatting & Linting: `ruff` and `basedpyright`

---

## Rules

- When starting long-running Python tasks run for >2 minutes (e.g. data pipeline, training): Load the `pueue` skill

---

## Writing Style

When receiving modification/update requests:

- Execute normally without emphasizing "this is a change" or "this is new"
- No excessive bold, "NEW", "IMPORTANT", or repeated emphasis
- Maintain consistent tone with existing content
- Changes should blend naturally, not stand out
