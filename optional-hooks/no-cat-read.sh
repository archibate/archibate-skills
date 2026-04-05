#!/usr/bin/bash
set -euo pipefail

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // ""')

# Detect cat with file arguments (reading files)
# Pattern: cat filename (where cat has a filename arg and is not receiving pipe input)
if ! echo "$command" | grep -qP '(?<!\|)\s*\bcat\b\s+\S'; then
    exit 0
fi

# Allow if cat is receiving piped input (e.g., echo foo | cat)
if echo "$command" | grep -qE '\|\s*cat\b'; then
    exit 0
fi

# Bypass for git commands
if echo "$command" | grep -qE '\bgit\s+'; then
    exit 0
fi

# Explicit bypass marker
if echo "$command" | grep -qF 'BYPASS_CAT_READ'; then
    exit 0
fi

# Extract file path for helpful error message
file_path=$(echo "$command" | grep -oP '\bcat\b\s+\K[^\s"}]+' | head -1 | tr -d "'" || true)

# Block and suggest Read tool
printf 'Use Read tool instead of cat for reading files.\n' >&2
if [ -n "$file_path" ]; then
    printf '  Read("%s")\n' "$file_path" >&2
fi
printf 'If you must use cat, add comment `BYPASS_CAT_READ` to the first line of command.\n' >&2

exit 2
