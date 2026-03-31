#!/usr/bin/bash
set -euo pipefail

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // ""')

# Skip if no python/uv pattern found
if ! echo "$command" | grep -qE '\bpython3?\b|\buv\s+run\b'; then
    exit 0
fi

# Skip if ALL python/uv occurrences already have PYTHONUNBUFFERED before them
total_matches=$(echo "$command" | grep -oE '\bpython3?\b|\buv\s+run\b' | wc -l | tr -d ' ')
buffered_matches=$(echo "$command" | grep -oE 'PYTHONUNBUFFERED=1\s+(python3?|uv\s+run)' | wc -l | tr -d ' ' || echo 0)

if [ "$total_matches" = "$buffered_matches" ]; then
    exit 0
fi

# Inject PYTHONUNBUFFERED=1 before each python3? or uv run that doesn't already have it
# Use perl for negative lookbehind support
new_command=$(echo "$command" | perl -pe '
    s/(?<!PYTHONUNBUFFERED=1\s)(\bpython3?\b)/PYTHONUNBUFFERED=1 $1/g;
    s/(?<!PYTHONUNBUFFERED=1\s)(\buv run\b)/PYTHONUNBUFFERED=1 $1/g;
')

# Output updatedInput to modify the tool call
echo "$input" | jq --arg cmd "$new_command" '. + {hookSpecificOutput: {permissionDecision: "allow", updatedInput: {command: $cmd}}}'
