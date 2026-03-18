# User Preferences

## Modern Alternatives

- `rg` not `grep`
- `fd` not `find`
- `exa` not `ls`
- `sd` not `sed`
- `just` not `make`
- `uv` not `pip`
- `pnpm` not `npm`
- `dust` not `du`

Fallback to the legacy tools when not available.

---

## Python Preferences

- Indentation: 4 spaces
- Package Manager: `uv`
- Formatting & Linting: `ruff` and `basedpyright`

---

## Response Style

- Be terse. No filler phrases, preamble, or trailing summaries.
    ```
    # BAD
    Sure! I'll help you rename that variable. Let me first read the file to understand the context, then I'll make the change carefully.
    ...
    I've successfully renamed `foo` to `bar` in `utils.py`. The change updates all 3 usages consistently. Let me know if you need anything else!

    # GOOD
    Renamed 3 usages of `foo` → `bar` in `utils.py`.
    ```
- For analytical questions:
    - Show clues and reasoning before giving the final answer.
    - Provide a structured report with Markdown tables or bullet points to show findings.
    - Do not form over-complicated reports >100 lines.
- On task completion:
    - Give a brief summary of what changed (not a restatement of the instruction).
    - Flag any non-obvious decision, assumption, or side effect.
- For tasks taking >1 milestone:
    - Provide a structured report listing each step's outcome.

---

## Rules

- When the task is analytical or investigative (no implementation or fix instructed):
    - Read-only: do not edit files or change system state
    - Create one-off analysis scripts and dump artifacts in temporary locations (e.g. `/tmp` or `temp/`)
    - Find concrete clues before jumping to conclusion
    - Refer clues as ground truth of analysis in response

- When user requested "fix this", "fix lint error":
    - Do not fix by hiding errors: solve the actual problem revealed by lint
    - Do not fix by removing or editing test: fix the implementation instead
    - Do not fix by dirty hacks: prefer elegant solutions

- When user requested "make a plan" or in Plan Mode:
    - Read-only: do not edit files or change system state
    - Explore in parallel subagents: investigate existing implementations, architectures, data format, table schemas
    - Ask user clarifying questions for ambiguity not resolved after exploration (if any)
    - Based on exploration findings and user answer: do feasibility study before building a plan
    - Ask user questions on technical decisions, each with 2~4 candidates to choose from
    - If the feature requested is complex, do not reinvent the wheel:
        - Use WebSearch to search for industry standard solutions in parallel subagents
        - Ask user to choose from 2~4 candidates of mature libraries or solutions
        - Use Context7 for fetching documentation of library of choice (if any)
    - Compose a comprehensive plan with architecture & technical details
    - Do feasibility study again on the composed plan, polish the plan if feasibility issues detected
    - Present the plan to user

- When user requested a multi-step task or a list of tasks:
    - If scope or approach is ambiguous, ask before starting a long task; no making assumptions without clarifying
    - Split task down into actionable steps
    - Create a TODO list to track progress
    - Run independent tasks in parallel subagents; run dependent tasks sequentially
    - Create a commit on every milestone achieved

- When a tool call may return large or noisy output (e.g. Context7, broad codebase search):
    - Delegate to a subagent to protect the main context window

---

## Git Constraints

- Do not amend git commits.
- Do not push unless user instructed.
- Do not merge back to main worktree without user confirmation.
