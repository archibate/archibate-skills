#!/usr/bin/bash
set -euo pipefail

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // ""')

# Only trigger if heredoc is present (<<, not <<<)
if ! echo "$command" | grep -qE '<<[^<]'; then
    exit 0
fi

# Bypass for git commit (heredoc used for commit message)
if echo "$command" | grep -qE '\bgit\s+commit\b'; then
    exit 0
fi

# Explicit bypass: agent uses EOF_BYPASS_HEREDOC_RESTRICTION as the heredoc marker
if echo "$command" | grep -qF 'EOF_BYPASS_HEREDOC_RESTRICTION'; then
    exit 0
fi

# Detect interpreter — order matters: uv run before python
if echo "$command" | grep -qE '\buv\s+run\b'; then
    interpreter="uv run"
    ext="py"
elif echo "$command" | grep -qE '\bpython3?\b'; then
    interpreter="python3"
    ext="py"
elif echo "$command" | grep -qE '\b(bash|sh)\b'; then
    interpreter="bash"
    ext="sh"
else
    # No relevant interpreter (e.g. git commit -m "$(cat <<EOF...)") — allow
    exit 0
fi

# Determine temp dir
if [ -d "${CLAUDE_PROJECT_DIR:-}/temp" ]; then
    tmp_dir="temp"
else
    tmp_dir="/tmp"
fi

tmp_file="${tmp_dir}/script_$$.${ext}"

case "$interpreter" in
    "uv run")
        example="Write(\"${tmp_file}\", <script>)  →  Bash(\"uv run ${tmp_file}\")"
        ;;
    "python3")
        example="Write(\"${tmp_file}\", <script>)  →  Bash(\"python3 ${tmp_file}\")"
        ;;
    "bash")
        example="Write(\"${tmp_file}\", <script>)  →  Bash(\"bash ${tmp_file}\")"
        ;;
esac

printf 'Heredoc detected for %s. Use Write tool + temp file instead:\n  %s\nIf you must use heredoc, replace EOF with EOF_BYPASS_HEREDOC_RESTRICTION.\n' \
    "$interpreter" "$example" >&2

exit 2
