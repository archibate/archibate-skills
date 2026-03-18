#!/usr/bin/bash

set -e

cd $(dirname $0)

if test -d ~/.claude; then
    echo -- Installing for Claude Code
    mkdir -p ~/.claude/skills
    ln -sf $PWD/skills/* ~/.claude/skills
    ln -sf $PWD/CLAUDE.md ~/.claude/CLAUDE.md

    # Register no-heredoc hook into settings.json
    hook_script="bash $PWD/hooks/no-heredoc.sh"
    settings=~/.claude/settings.json
    if test -f "$settings"; then
        # Remove any existing no-heredoc entry, then append fresh
        jq --arg cmd "$hook_script" '
            .hooks.PreToolUse //= [] |
            .hooks.PreToolUse = (.hooks.PreToolUse | map(select(.hooks[0].command != $cmd))) +
            [{"matcher": "Bash", "hooks": [{"type": "command", "command": $cmd, "timeout": 5}]}]
        ' "$settings" > /tmp/claude-settings.tmp && mv /tmp/claude-settings.tmp "$settings"
        echo -- Registered no-heredoc hook in settings.json
    fi
fi

if test -d ~/.codex; then
    echo -- Installing for Codex
    mkdir -p ~/.codex/skills
    rm -f ~/.codex/skills/archibate
    ln -sf $PWD/skills ~/.codex/skills/archibate
    ln -sf $PWD/CLAUDE.md ~/.codex/AGENTS.md
fi
