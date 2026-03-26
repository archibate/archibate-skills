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

    # Register no-heredoc hook into settings.json
    hook_script="bash ~/.claude/hooks/no-heredoc.sh"
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

        # Register no-cat-write hook into settings.json
        hook_script="bash ~/.claude/hooks/no-cat-write.sh"
        jq --arg cmd "$hook_script" '
            .hooks.PreToolUse //= [] |
            .hooks.PreToolUse = (.hooks.PreToolUse | map(select(.hooks[0].command != $cmd))) +
            [{"matcher": "Bash", "hooks": [{"type": "command", "command": $cmd, "timeout": 5}]}]
        ' "$settings" > /tmp/claude-settings.tmp && mv /tmp/claude-settings.tmp "$settings"
        echo "[claude] Registered no-cat-write hook (PreToolUse/Bash) in $settings"

        # Register question-readonly-hint hook into settings.json
        hook_script="bash ~/.claude/hooks/question-readonly-hint.sh"
        jq --arg cmd "$hook_script" '
            .hooks.UserPromptSubmit //= [] |
            .hooks.UserPromptSubmit = (.hooks.UserPromptSubmit | map(select(.hooks[0].command != $cmd))) +
            [{"matcher": "*", "hooks": [{"type": "command", "command": $cmd, "timeout": 5}]}]
        ' "$settings" > /tmp/claude-settings.tmp && mv /tmp/claude-settings.tmp "$settings"
        echo "[claude] Registered question-readonly-hint hook (UserPromptSubmit) in $settings"

        # Register link-venv hook into settings.json
        hook_script="bash ~/.claude/hooks/link-venv.sh"
        jq --arg cmd "$hook_script" '
            .hooks.SessionStart //= [] |
            .hooks.SessionStart = (.hooks.SessionStart | map(select(.hooks[0].command != $cmd))) +
            [{"matcher": "*", "hooks": [{"type": "command", "command": $cmd, "timeout": 10}]}]
        ' "$settings" > /tmp/claude-settings.tmp && mv /tmp/claude-settings.tmp "$settings"
        echo "[claude] Registered link-venv hook (SessionStart) in $settings"

        # Register show-image-on-read hook into settings.json
        hook_script="bash ~/.claude/hooks/show-image-on-read.sh"
        jq --arg cmd "$hook_script" '
            .hooks.PostToolUse //= [] |
            .hooks.PostToolUse = (.hooks.PostToolUse | map(select(.hooks[0].command != $cmd))) +
            [{"matcher": "Read", "hooks": [{"type": "command", "command": $cmd, "timeout": 5}]}]
        ' "$settings" > /tmp/claude-settings.tmp && mv /tmp/claude-settings.tmp "$settings"
        echo "[claude] Registered show-image-on-read hook (PostToolUse/Read) in $settings"
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
