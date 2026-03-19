---
name: urgent-notify
description: TRIGGER when urgent event happened during long waiting or routine checks. TRIGGER when user says "notify me on X", "call me on emergence", "notify me when complete", "AFK".
---

# Urgent Notify

## Overview

When user is AFK (Away-From-Keyboard), not watching Claude. We need to send a notification on urgent events to call user back.

### AFK Indicators

- User is not responding for more than 10 minutes
- Claude asked an critical question, but user didn't response in 10 minutes
- All recent messages are system messages (e.g. `<task-notification>`)
- Claude is waiting for a background task
- Claude is periodically waiting and checking things

## When to Use

- User is AFK and:
    - Urgent exception that Claude should not solve on its own
    - Critical decision that require human interception
    - User requested to notify them when some condition met or task complete
    - User requested to send progress report every X minutes
    - Any unexpected emergence blocking progress

## When NOT to Use

- User is obviously not AFK (chatting with Claude interactively)
- Not very urgent exception that Claude can easily recover from

## Notification Methods

Determine which to use by checking environment:

```bash
# Check for Linux desktop session
echo $DISPLAY

# Check for ntfy.sh topic
echo $NTFY_SH_PRIVATE_TOPIC

# Check for macOS
uname -s
```

**Decision logic:**

| Condition | Method |
|-----------|--------|
| `$DISPLAY` non-empty | Linux desktop (`notify-send`) |
| `uname -s` = `Darwin` | macOS (`terminal-notifier`) |
| `$NTFY_SH_PRIVATE_TOPIC` non-empty | Remote via ntfy.sh |
| None of the above | Fallback: write to `/tmp/claude-urgent-notify` |

### Linux Desktop

```bash
notify-send -a "claude" -u critical "Claude" "<message>"
```

### macOS

```bash
terminal-notifier -title "Claude" -message "<message>"
```

### Remote/SSH via ntfy.sh

Ask the user to set up a private topic in environment:

```bash
export NTFY_SH_PRIVATE_TOPIC="your-secret-topic-name"
```

Send notification:

```bash
curl -s -d "<message>" "https://ntfy.sh/$NTFY_SH_PRIVATE_TOPIC"
```

**⚠️ Privacy Warning:** ntfy.sh topics are public. Anyone who knows your topic name can subscribe. Never include sensitive content like API keys, passwords, or confidential data in notifications.

## Related Skills

- **pueue**: Background task management — use urgent-notify when pueue task fails unexpectedly
- **long-waits**: Extended waiting periods — use urgent-notify when condition is met or progress report is due

## Example Scenarios

### Training Job Failed

User started a 4-hour training job via pueue and went AFK. Task failed after 2 hours:

```
pueue status shows task #5 status: Failed, exit code: 1
→ Send urgent notification: "Training job #5 failed with exit code 1. Check logs."
```

### Deploy Condition Met

User said "notify me when the deploy is live". Long-waits polling detected success:

```
curl check shows deploy status: success
→ Send urgent notification: "Deploy is live on staging!"
```

### Critical Decision Needed

Background task encountered ambiguous situation requiring human input:

```
Found 3 conflicting config files. Cannot auto-resolve.
→ Send urgent notification: "Need decision: multiple config files found, which to use?"
```
