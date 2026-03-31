#!/usr/bin/bash
set -euo pipefail

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // ""')

# Skip if no python/uv pattern found
if ! echo "$command" | grep -qE '\bpython3?\b|\buv\s+run\b'; then
    exit 0
fi

# Skip if already has PYTHONUNBUFFERED
if echo "$command" | grep -qE '\bPYTHONUNBUFFERED='; then
    exit 0
fi

# Prepend PYTHONUNBUFFERED=1
new_command="PYTHONUNBUFFERED=1 $command"

# Output updatedInput to modify the tool call
echo "$input" | jq --arg cmd "$new_command" '. + {hookSpecificOutput: {permissionDecision: "allow", updatedInput: {command: $cmd}}}'
