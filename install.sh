#!/usr/bin/bash

cd $(dirname $0)

if test -d ~/.claude/; then
    echo -- Installing for Claude Code
    ln -sf $PWD/skills ~/.claude/
    ln -sf $PWD/CLAUDE.md ~/.claude/
fi

if test -d ~/.codex/; then
    echo -- Installing for Codex
    ln -sf $PWD/skills ~/.codex/
    ln -sf $PWD/CLAUDE.md ~/.codex/AGENTS.md
fi
