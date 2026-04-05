#!/usr/bin/bash
set -euo pipefail

input=$(cat)
command=$(jq -r '.tool_input.command // ""' <<< "$input")

# Detect cat with heredoc AND file redirection
# Pattern: cat << EOF > file, cat > file << EOF, cat << EOF | tee file
if ! echo "$command" | grep -qE '\bcat\b.*<<'; then
    exit 0
fi

# Check for file output redirection (>, >>, or | tee)
if ! echo "$command" | grep -qE '(>\s*\S|>>\s*\S|\|\s*tee\b)'; then
    exit 0  # No file output, allow
fi

# Bypass for git commit
if echo "$command" | grep -qE '\bgit\s+commit\b'; then
    exit 0
fi

# Explicit bypass marker
if echo "$command" | grep -qF 'EOF_BYPASS_CAT_WRITE'; then
    exit 0
fi

# Extract target file path for helpful error message
# Stop at first space, <, |, or newline to avoid capturing heredoc marker
file_path=$(echo "$command" | grep -oE '>\s*[^<>|& ]+' | head -1 | sed 's/^>\s*//' | tr -d "'" || true)

# Block and suggest Write tool
printf 'Use Write tool instead of cat heredoc for file writes.\n' >&2
if [ -n "$file_path" ]; then
    printf '  Write("%s", <content>)\n' "$file_path" >&2
fi
printf 'If you must use cat heredoc, add EOF_BYPASS_CAT_WRITE to the command.\n' >&2

exit 2
