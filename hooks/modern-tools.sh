#!/usr/bin/bash
set -euo pipefail

# Mapping of legacy commands to modern alternatives
declare -A MODERN_MAP=(
    [npm]=pnpm
    [grep]=rg
    [find]=fd
    [ls]=exa
    [pip]=uv
    [pipx]=uvx
    [python]="uv run"
    [python3]="uv run"
)

input=$(cat)
bash_cmd=$(echo "$input" | jq -r '.tool_input.command // ""')

# Skip if empty
if [ -z "$bash_cmd" ]; then
    exit 0
fi

# Extract first word (the command name)
first_word=$(echo "$bash_cmd" | awk '{print $1}')

# Bypass: if using `command <legacy>` explicitly, allow it
if [ "$first_word" = "command" ]; then
    exit 0
fi

# Check if first word is a legacy command
modern="${MODERN_MAP[$first_word]:-}"

if [ -z "$modern" ]; then
    # Not a legacy command we care about
    exit 0
fi

# Extract just the tool name for existence check (uv run -> uv)
modern_tool="$modern"
if [ "$modern" = "uv run" ]; then
    modern_tool="uv"
fi

# Check if modern tool exists on system
if ! command -v "$modern_tool" >/dev/null 2>&1; then
    # Modern tool not installed, allow legacy
    exit 0
fi

# Build suggestion
rest_of_command=$(echo "$bash_cmd" | cut -d' ' -f2-)

if [ "$modern" = "uv run" ]; then
    # For python -> uv run, remove the python binary from command
    suggestion="$modern $rest_of_command"
else
    # Direct replacement
    suggestion="$modern $rest_of_command"
fi

# Block with helpful message
printf 'Use %s instead of %s.\n' "$modern" "$first_word" >&2
printf '  Suggested: %s\n' "$suggestion" >&2
printf 'If you must use %s, use: command %s\n' "$first_word" "$bash_cmd" >&2

exit 2
