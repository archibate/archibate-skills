#!/usr/bin/bash

set -e

cd $(dirname $0)

if test -d ~/.claude; then
    echo -- Installing for Claude Code
    mkdir -p ~/.claude/skills
    ln -sf $PWD/skills/* ~/.claude/skills
    ln -sf $PWD/CLAUDE.md ~/.claude/CLAUDE.md
fi

if test -d ~/.codex; then
    echo -- Installing for Codex
    mkdir -p ~/.codex/skills
    rm -f ~/.codex/skills/archibate
    ln -sf $PWD/skills ~/.codex/skills/archibate
    ln -sf $PWD/CLAUDE.md ~/.codex/AGENTS.md
fi
