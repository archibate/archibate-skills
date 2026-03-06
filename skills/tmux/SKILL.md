---
name: tmux
description: Use when running tasks >5 minutes, tasks that must persist after conversation ends, or interacting with TUI applications and running processes that Bash tool cannot handle
---

# Tmux

## Overview

Claude controls tmux via CLI commands. Use for tasks that persist, run in background, or require interaction with running processes.

## When to Use

Use tmux if ANY condition is met:

1. Task takes >5 minutes
2. Task must persist after conversation ends
3. Need to interact with running process (TUI apps, prompts, stdin)
4. User requests to split pane (when inside tmux)

Otherwise: Use Bash tool (or `run_in_background` for simple background tasks)

## Safety Constraints (CRITICAL)

- **NEVER** kill or send-keys to sessions not created in current conversation
- **NEVER** run `tmux kill-server` or `tmux attach`
- **Be careful** with interactive apps (htop, btop) - avoid keys that may kill processes (F9, k)
- **Do not** start interactive editors (vim, nvim) - use Edit tools instead
- **Do not** start a new `claude` instance unless explicitly instructed
- Use `claude-` prefix for all session names
- Remember which sessions you created
- If unsure about ownership, leave it and inform user

## Session Naming

Prefix all sessions with `claude-` to identify ownership:

```bash
tmux new-session -d -s claude-build
tmux new-session -d -s claude-dev-server
```

## Detecting if Inside tmux

```bash
echo $TMUX      # Set if inside tmux
echo $TMUX_PANE # Set if inside tmux
```

If set, Claude can split panes when user requests.

## Split Pane (when inside tmux)

Only use when `$TMUX` is set. **Warning:** Be careful with interactive apps (htop, btop) - only run if user explicitly requests.

```bash
# Split horizontally (side by side)
tmux split-window -h -c /home/user/project "npm run dev"

# Split vertically (top/bottom), 30% height
tmux split-window -v -p 30 -c /home/user/project "npm run dev"
```

## Session Management

```bash
# Check if session exists (do this first!)
tmux has-session -t claude-task-name 2>/dev/null && echo "exists" || echo "not found"

# Create detached session
tmux new-session -d -s claude-task-name

# List all sessions
tmux list-sessions

# Kill session (ONLY if created in this conversation)
tmux kill-session -t claude-task-name
```

## Capturing Output

```bash
# Capture output (must use -p to print to stdout)
tmux capture-pane -t claude-task-name -p -S -50

# Capture entire scrollback
tmux capture-pane -t claude-task-name -p -S -
```

**Key flags:** `-p` (print to stdout), `-t` (target), `-S` (lines back), `-E` (end line)

## Sending Commands

**Before send-keys:** Check what's running with `capture-pane` first.

```bash
# Run shell command (quoted, with Enter)
tmux send-keys -t claude-build 'npm run dev' Enter

# Answer prompt
tmux send-keys -t claude-task 'y' Enter

# Interrupt process (no quotes for special keys)
tmux send-keys -t claude-build C-c

# Close shell
tmux send-keys -t claude-task C-d
```

**Special keys:** `Enter`, `C-c`, `C-d`, `C-z`, `Escape`, `Tab`, `Up`, `Down`, `Space`

**Shell commands:** Quoted with `Enter`
**Special keys:** Unquoted (e.g., `C-c`)

## Common Patterns

### Start Background Task
```bash
tmux new-session -d -s claude-build
tmux send-keys -t claude-build 'cd /home/user/project && npm run build' Enter
```

**Alternative:** For simple background tasks, use Bash tool's `run_in_background` parameter.

### Check Progress
```bash
tmux capture-pane -t claude-build -p -S -50
```

### User Attaches Interactively
Tell user:
```
The server is running in a tmux session. To view interactively:
  tmux attach -t claude-dev-server
```

## Common Mistakes

- Forgetting `cd` before running commands in new sessions
- Forgetting `-p` flag in capture-pane
- Forgetting `Enter` after shell commands in send-keys
- Sending dangerous keys to htop (F9, k, etc.)
- Splitting panes when not inside tmux (check `$TMUX` first)
- Creating duplicate session (check `has-session` first)
