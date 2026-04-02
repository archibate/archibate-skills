---
name: pueue
description: This skill should be used before running non-interactive long-running tasks, computation intensive tasks, background tasks, or needs guidance on the pueue CLI tool usage. TRIGGER when user says "use pueue", "run in background", or when about to queue any long-running (>2 min) task.
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "bash ./hooks/no-sleep-pueue.sh"
          timeout: 5
compatibility: Claude Code
---

# Pueue - Background Task Manager

## When to Use

- Non-interactive long-running tasks expected to run for >2 minutes
- Computation intensive tasks with parallel job scheduling (prevent resource exhaustion)

## When NOT to Use

- Short tasks (<2 minutes): run in Bash directly
- Interactive commands: `tmux` instead for TUI access

## Workflow

Start tasks with `scripts/run_in_pueue.sh '...'` in background (`run_in_background: true`) — do not poll after this, just stop and wait.

When task completes, you will receive `<task-notification>` from it.

## Conversation Example

User:
Start training in the background.

Assistant:
```
Bash(command: "scripts/run_in_pueue.sh 'uv run python -u train.py'", run_in_background: true)
```
I've started training in background, will notify you once complete.
[STOP AND WAIT]

[~10 minutes passed]

System:
<task-notification>Background command "..." completed (exit code 0)</task-notification>

Assistant:
[analysis the log and training metric]
Training complete, here are the metrics:
...

## Skill Files

- `scripts/run_in_pueue.sh` — wraps pueue add with auto daemon start, per-project grouping, and follow
- `scripts/list_pueue_tasks.sh` — list existing pueue tasks and their status
- `references/pueue.md` — comprehensive pueue CLI usage documentation
