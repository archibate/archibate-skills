# Skill Trigger Description Flaws

Review of skills whose trigger descriptions only cover **user-explicit mentions**, missing
proactive cases where the skill should load automatically based on what I'm about to do.

## Root Cause

A description like `TRIGGER when user says "use pueue"` only fires when the user uses that
exact phrase. It misses cases where I should proactively load the skill before writing a
command — even if the user never mentions the tool by name.

---

## Fixed

### `just-cli`
**Before:** `TRIGGER when the user mentioned "run just command", "add to justfile", "update justfile".`

**Flaw:** Missed implicit case where I'm constructing a `just ...` invocation inside
a Bash/pueue command. Caused wrong variable override syntax (`just recipe var=value`
instead of `just var=value recipe`).

**Fix:** Added: *"or when about to write any `just ...` shell invocation in Bash, pueue,
or scripts."*

---

## Remaining Flaws

### `pueue`
**Current:** `TRIGGER when user says "use pueue", "run in background".`

**Flaw:** Only fires on user's explicit words. Per CLAUDE.md, pueue should be loaded
before any Python task expected to run >2 minutes — even when the user just says
"run this training" without mentioning pueue.

**Suggested fix:** Add: *"or when about to queue any long-running (>2 min) task."*

---

### `uv`
**Current:** `Use this skill when using UV (Python package manager)...`

**Flaws:**
1. Wrong person — uses "Use this skill when" instead of "This skill should be used when"
2. Only covers when user explicitly discusses UV. Should also trigger proactively
   before writing any `uv run` / `uv add` / `uv sync` command.

**Suggested fix:** Rewrite to third person and add: *"or when about to write any
`uv run`, `uv add`, or `uv sync` command."*

---

### `show-image`
**Current:** `TRIGGER when show/view images in terminal, display plot results.`

**Flaw:** Too vague and passive. Misses the proactive case: after saving a
matplotlib/seaborn/plotly figure to a file, I should automatically offer to
display it — not wait for the user to ask.

**Suggested fix:** Add: *"or after saving any plot or image file to disk."*

---

### `ast-grep`
**Current:** `Use when users need to search codebases using Abstract Syntax Tree (AST) patterns...`

**Flaws:**
1. Uses "Use when" (not third person)
2. Only covers user-explicit search requests. Should also trigger proactively when
   I'm about to perform a complex structural code search that goes beyond simple grep
   patterns.

**Suggested fix:** Rewrite to third person and add: *"or when a simple grep/glob search
is insufficient for structural code pattern matching."*

---

### `scrapling`
**Current:** `Use when asked to scrape, crawl, or extract data from websites...`

**Flaw:** "When asked" = user-explicit only. The key implicit trigger is missing:
when `WebFetch` returns an error or incomplete content due to anti-bot protection,
scrapling should be considered automatically.

**Suggested fix:** Change "Use when asked to" → "This skill should be used when" and
add: *"or when WebFetch returns an error, incomplete content, or is blocked by
anti-bot protection."*

---

## General Pattern

Skills fall into two trigger categories:

| Category | Description | Example |
|---|---|---|
| **User-explicit** | User says a specific phrase | "run just command" |
| **Action-implicit** | I'm about to take an action requiring the skill | Constructing `just var=value recipe` |

Most current descriptions only cover the first category. The second is equally important
and prevents silent mistakes (wrong syntax, wrong tool, missing safety checks).

When writing skill descriptions, always ask: *"Is there a case where I would use this
tool without the user explicitly naming it?"* If yes, add that as a trigger.
