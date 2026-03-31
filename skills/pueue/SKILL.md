---
name: pueue
description: This skill should be used before running non-interactive long-running tasks, computation intensive tasks, background tasks, or needs guidance on the pueue CLI tool usage. TRIGGER when user says "use pueue", "run in background", or when about to queue any long-running (>2 min) task.
allowed-tools: Bash(scripts/pueue_add.sh:*), Bash(pueue:*)
metadata:
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

Start tasks with `scripts/pueue_add.sh '...'` in background (`run_in_background: true`) — do not poll after this, just stop and wait.

When task completes, you will receive `<task-notification>` from it.

## Conversation Example

User:
Start training in the background.

Assistant:
```
Bash(command: "scripts/pueue_add.sh 'uv run python -u train.py'", run_in_background: true)
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

## Files in this Skill

- Pueue CLI Wrapper for adding a task — `scripts/pueue_add.sh`
- Pueue CLI Usage Documentation — `references/pueue.md`
