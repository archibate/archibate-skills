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

- When starting long-running Python tasks run for >2 minutes (e.g. data pipeline, training):
    - Load the `pueue` skill
    - Start as background tasks using `pueue`

- When the task is analytical or investigative (no implementation or fix instructed):
    - Read-only: do not edit files or change system state
    - Create one-off analysis scripts and artifacts in temporary locations (e.g. `/tmp` or `temp/`)
    - Find concrete clues before jumping to conclusion; refer clues as ground truth of analysis in response
    - Offer user what to do next (e.g. "Next Step") and wait for user confirmation

- When user requested a multi-step task or a list of tasks:
    - If scope or approach is ambiguous, ask before starting a long task; no making assumptions without clarifying
    - Split task down into actionable steps
    - Create a TODO list to track progress
    - Run independent tasks in parallel subagents; run dependent tasks sequentially
    - Create a commit on every milestone achieved

- When a tool call may return large or noisy output (e.g. Context7, WebSearch, broad codebase search):
    - Delegate to a subagent to protect the main context window

- Before using any field name, API parameter, or identifier from an external system (hook input schemas, CLI flags, APIs, etc.):
    - Verify it exists by checking docs (Context7/WebFetch) or searching the codebase (Grep/Read)
    - Do NOT invent or guess names — if you cannot verify, state that explicitly
