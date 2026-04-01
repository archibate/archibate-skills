#!/usr/bin/bash
set -euo pipefail

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // ""')

# Explicit bypass marker
if echo "$command" | grep -qF 'BYPASS_BACKGROUND_CHECK'; then
    exit 0
fi

# Check if any line ends with & (possibly with trailing whitespace)
# Match: command& or command & but not && (logical AND)
# Also catches multi-line commands where & appears at end of a line
if echo "$command" | grep -qP '[^&]&\s*(\n|$)'; then
    printf 'Do not use & for background execution. Use the run_in_background parameter instead:\n' >&2
    printf '  Bash(command="...", run_in_background=true)\n' >&2
    printf 'If you must use &, add BYPASS_BACKGROUND_CHECK to the command.\n' >&2
    exit 2
fi

exit 0
