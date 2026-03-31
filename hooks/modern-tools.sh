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
    [python]="uv run python"
    [python3]="uv run python3"
)

input=$(cat)
bash_cmd=$(echo "$input" | jq -r '.tool_input.command // ""')

# Skip if empty
if [ -z "$bash_cmd" ]; then
    exit 0
fi

# Bypass: check for BYPASS_MODERN_TOOLS_CHECK comment
if echo "$bash_cmd" | grep -qF 'BYPASS_MODERN_TOOLS_CHECK'; then
    exit 0
fi

# Split command by shell operators (&& || ; | &) and check each part
parts=$(echo "$bash_cmd" | sed -E 's/(&&|\|\||;|\||&)/\n/g')

found_legacy=""
found_modern=""
found_rest=""

while IFS= read -r part; do
    # Trim whitespace
    part=$(echo "$part" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    # Skip empty parts
    [ -z "$part" ] && continue

    # Extract first word
    first_word=$(echo "$part" | awk '{print $1}')

    # Skip if using `command <legacy>` bypass
    [ "$first_word" = "command" ] && continue

    # Check if first word is a legacy command
    modern="${MODERN_MAP[$first_word]:-}"

    [ -z "$modern" ] && continue

    # Extract tool name for existence check
    modern_tool="$modern"
    [[ "$modern" == "uv run"* ]] && modern_tool="uv"

    # Check if modern tool exists
    if ! command -v "$modern_tool" >/dev/null 2>&1; then
        continue
    fi

    # Found a legacy command!
    found_legacy="$first_word"
    found_modern="$modern"
    found_rest=$(echo "$part" | cut -d' ' -f2-)
    break

done <<< "$parts"

# No legacy command found
[ -z "$found_legacy" ] && exit 0

# Build suggestion
suggestion="$found_modern $found_rest"

# Block with helpful message
printf 'Use %s instead of %s.\n' "$found_modern" "$found_legacy" >&2
printf '  Suggested: %s\n' "$suggestion" >&2
printf 'If you belive this is a false positive, add a comment `# BYPASS_MODERN_TOOLS_CHECK` in your command\n' "$found_legacy" >&2

exit 2
