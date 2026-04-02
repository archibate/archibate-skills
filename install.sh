#!/usr/bin/bash

set -e

cd $(dirname $0)

if test -d ~/.claude; then
    echo "[claude] Installing skills -> ~/.claude/skills/"
    test -L ~/.claude/skills && rm ~/.claude/skills
    mkdir -p ~/.claude/skills
    for skill in $PWD/skills/*; do
        name=$(basename "$skill")
        rm -rf ~/.claude/skills/"$name"
        ln -sf "$skill" ~/.claude/skills/"$name"
    done
    echo "[claude] Linking CLAUDE.md -> ~/.claude/CLAUDE.md"
    rm -f ~/.claude/CLAUDE.md
    ln -sf $PWD/CLAUDE.md ~/.claude/CLAUDE.md

    echo "[claude] Linking hooks -> ~/.claude/hooks/"
    mkdir -p ~/.claude/hooks
    for hook in $PWD/hooks/*; do
        name=$(basename "$hook")
        rm -f ~/.claude/hooks/"$name"
        ln -sf "$hook" ~/.claude/hooks/"$name"
    done

    settings=~/.claude/settings.json

    register_hook() {
        local event=$1 matcher=$2 timeout=$3 script=$4
        local hook_cmd="bash ~/.claude/hooks/$script"
        jq --arg cmd "$hook_cmd" --arg event "$event" --arg matcher "$matcher" --argjson timeout "$timeout" '
            .hooks[$event] //= [] |
            .hooks[$event] = (.hooks[$event] | map(select(.hooks[0].command != $cmd))) +
            [{"matcher": $matcher, "hooks": [{"type": "command", "command": $cmd, "timeout": $timeout}]}]
        ' "$settings" > /tmp/claude-settings.tmp && mv /tmp/claude-settings.tmp "$settings"
        echo "[claude] Registered $script ($event/$matcher) in $settings"
    }

    if test -f "$settings"; then
        hooks=(
            "PreToolUse|Bash|5|no-heredoc.sh"
            "PreToolUse|Bash|5|no-cat-write.sh"
            "PreToolUse|Bash|5|no-background-ampersand.sh"
            "SessionStart|*|10|link-venv.sh"
            "PostToolUse|Read|5|show-image-on-read.sh"
            "PostToolUse|Write|5|pep723-script.sh"
        )
        for entry in "${hooks[@]}"; do
            IFS='|' read -r event matcher timeout script <<< "$entry"
            register_hook "$event" "$matcher" "$timeout" "$script"
        done
    else
        echo "[claude] Skipping hook registration: $settings not found"
    fi
fi

# Check if skill is compatible with a specific agent
# Returns 0 if compatible (or no compatibility field), 1 if incompatible
check_compatibility() {
    local skill_dir=$1
    local agent=$2  # "claude" or "codex"
    local skill_md="$skill_dir/SKILL.md"

    if [[ ! -f "$skill_md" ]]; then
        return 0  # No SKILL.md, assume compatible
    fi

    # Extract compatibility field from frontmatter
    local compatibility=$(sed -n '/^---$/,/^---$/p' "$skill_md" | grep '^compatibility:' | head -1 | cut -d: -f2- | xargs)

    if [[ -z "$compatibility" ]]; then
        return 0  # No compatibility field, assume universal
    fi

    # Check if the agent name appears in compatibility (case-insensitive)
    if echo "$compatibility" | grep -qi "$agent"; then
        return 0  # Compatible
    fi

    # Check if it's Claude-only but we're installing to another agent
    if echo "$compatibility" | grep -qi "claude" && [[ "$agent" != "claude" ]]; then
        return 1  # Incompatible
    fi

    return 0  # Assume compatible by default
}

if test -d ~/.codex; then
    echo "[codex] Installing skills -> ~/.codex/skills/archibate"
    test -L ~/.codex/skills && rm ~/.codex/skills
    mkdir -p ~/.codex/skills
    rm -rf ~/.codex/skills/archibate
    mkdir -p ~/.codex/skills/archibate
    for skill in $PWD/skills/*; do
        name=$(basename "$skill")
        if ! check_compatibility "$skill" "codex"; then
            echo "[codex] Skipping $name (incompatible: Claude Code only)"
            continue
        fi
        rm -rf ~/.codex/skills/archibate/"$name"
        ln -sf "$skill" ~/.codex/skills/archibate/"$name"
        echo "[codex] Linked $name"
    done
    echo "[codex] Linking CLAUDE.md -> ~/.codex/AGENTS.md"
    rm -f ~/.codex/AGENTS.md
    ln -sf $PWD/CLAUDE.md ~/.codex/AGENTS.md
fi
