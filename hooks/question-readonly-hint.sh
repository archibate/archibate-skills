#!/bin/bash
set -euo pipefail

input=$(cat)
user_prompt=$(echo "$input" | jq -r '.prompt // ""')

# Strip trailing whitespace before checking for '?'
trimmed=$(echo "$user_prompt" | sed 's/[[:space:]]*$//')

if [[ "$trimmed" == *"?" ]]; then
    cat <<'EOF'
{
  "systemMessage": "The user is asking a question. Operate in READ-ONLY investigative mode:\n- Explore, investigate, and answer the question thoroughly\n- Show findings, recommendations, and options\n- Do NOT edit files, run destructive commands, or change system state\n- Wait for explicit confirmation ('proceed', 'go ahead', 'yes', etc.) before taking any action"
}
EOF
fi
