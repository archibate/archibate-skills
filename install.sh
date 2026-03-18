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

    # Register no-heredoc hook into settings.json
    hook_script="bash $PWD/hooks/no-heredoc.sh"
    settings=~/.claude/settings.json
    if test -f "$settings"; then
        # Remove any existing no-heredoc entry, then append fresh
        # Note: settings.json uses hooks wrapper format (hooks under "hooks" key)
        jq --arg cmd "$hook_script" '
            .hooks.PreToolUse //= [] |
            .hooks.PreToolUse = (.hooks.PreToolUse | map(select(.hooks[0].command != $cmd))) +
            [{"matcher": "Bash", "hooks": [{"type": "command", "command": $cmd, "timeout": 5}]}]
        ' "$settings" > /tmp/claude-settings.tmp && mv /tmp/claude-settings.tmp "$settings"
        echo "[claude] Registered no-heredoc hook (PreToolUse/Bash) in $settings"

        # Register question-readonly-hint hook into settings.json
        hook_script="bash $PWD/hooks/question-readonly-hint.sh"
        jq --arg cmd "$hook_script" '
            .hooks.UserPromptSubmit //= [] |
            .hooks.UserPromptSubmit = (.hooks.UserPromptSubmit | map(select(.hooks[0].command != $cmd))) +
            [{"matcher": "*", "hooks": [{"type": "command", "command": $cmd, "timeout": 5}]}]
        ' "$settings" > /tmp/claude-settings.tmp && mv /tmp/claude-settings.tmp "$settings"
        echo "[claude] Registered question-readonly-hint hook (UserPromptSubmit) in $settings"
    else
        echo "[claude] Skipping hook registration: $settings not found"
    fi
fi

if test -d ~/.codex; then
    echo "[codex] Installing skills -> ~/.codex/skills/archibate"
    test -L ~/.codex/skills && rm ~/.codex/skills
    mkdir -p ~/.codex/skills
    rm -f ~/.codex/skills/archibate
    ln -sf $PWD/skills ~/.codex/skills/archibate
    echo "[codex] Linking CLAUDE.md -> ~/.codex/AGENTS.md"
    rm -f ~/.codex/AGENTS.md
    ln -sf $PWD/CLAUDE.md ~/.codex/AGENTS.md
fi
