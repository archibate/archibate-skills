# Archibate's Claude - Setup Guide

Claude Code configuration for archibate personal use.

> Be careful that below setup guide is aimed for Claude Code, may not work universally for all agents. See [dotfiles-opencode](https://github.com/) if you are looking for OpenCode configuration, which is an open-source alternative for Claude Code.

## What's in there?

### Skills

**Agent & Plugin Development:**
- `agent-development` - Creating autonomous agents for Claude Code plugins
- `hook-development` - Creating event-driven hooks (PreToolUse, PostToolUse, etc.)
- `skill-development` - Creating skills for Claude Code plugins

**Automation & Orchestration:**
- `agent-crew` - Multi-specialist agent orchestration for complex tasks
- `agent-browser` - Browser automation CLI (navigate, click, screenshot, scrape)
- `pueue` - Background task management for long-running tasks
- `long-waits` - Chain sequential sleeps for extended waits (>10 min)

**Code Search & Analysis:**
- `ast-grep` - AST-based structural code search
- `code-quality-metrics` - Cyclomatic/cognitive complexity metrics

**Web & Data:**
- `scrapling` - Web scraping with anti-bot bypass (Cloudflare, etc.)
- `cc-connect` - Send images/files via messaging platforms (Discord, Telegram)

**Utilities:**
- `just-cli` - Just command runner documentation
- `show-image` - Display images in Kitty terminal
- `grill-me` - Interview user about plans before implementation
- `skillful` - Force agent to load skills before conversation

### Hooks

- `no-heredoc.sh` - Prevents heredoc anti-patterns
- `no-cat-write.sh` - Enforces using Write tool instead of `cat >`
- `no-cat-read.sh` - Enforces using Read tool instead of `cat`
- `modern-tools.sh` - Recommends modern CLI tools (rg, fd, exa, sd, etc.)
- `link-venv.sh` - Links venv on session start
- `show-image-on-read.sh` - Displays images when read

## Installation Steps

### Clone this Repo
```bash
git clone https://github.com/archibate/archibate-skills ~/archibate-skills
```

### Install Archibate Skills and Hooks
Run my one-shot installation script:
```bash
./install.sh
```

This will install:
- Skills symlinked to `~/.claude/skills/` (agent-browser, agent-crew, pueue, etc.)
- CLAUDE.md symlinked to `~/.claude/CLAUDE.md`
- Hooks symlinked to `~/.claude/hooks/` and registered in `settings.json`
- Codex integration (if `~/.codex` exists)

### Configure Archibate Claude Router
```bash
cp router.example.json router.json
```
Then edit `router.json` to fill your model providers and API keys.

### Install Archibate Fish Intergration
Add this to your `~/.config/fish/config.fish` or whatever:
```fish
source /path/to/archibate-skills/intergration.fish
```
Where `/path/to/archibate-skills` is path to this project.

## Configure MCP Servers

### Install Context7 MCP
Type in Claude Code:
```
/plugin install context7
```

### Install gh-grep MCP
Type in Bash:
```bash
claude mcp add --transport http grep https://mcp.grep.app --scope user
```
The `--scope user` option means to configure globally instead of configure in current project.

### Install Jina MCP
```bash
claude mcp add -s user --transport http jina https://mcp.jina.ai/v1 --header "Authorization: Bearer $JINA_API_KEY"
```

Jina.ai API key can be obtained from https://jina.ai/, with 10M tokens free tier.

See [`jina-ai/MCP`](https://github.com/jina-ai/MCP) for more details.

### Install DeepWiki MCP
```bash
claude mcp add -s user -t http deepwiki https://mcp.deepwiki.com/mcp
```

Jina MCP capabilities:
- Search web results, replaces WebSearch.
- Fetch web pages, replaces WebFetch.
- Return in LLM-friendly Markdown format.
- Able to scrape Arxiv, SSRN for papers.

## Configure Plugins

### Configure Status Line (claude-hud)
This will guide you to configure [claude-hud](https://github.com/jarrodwatts/claude-hud), a status line plugin.

Type in Claude Code, one by one:
```
/plugin marketplace add jarrodwatts/claude-hud
/plugin install claude-hud
/reload-plugins
/claude-hud:setup
```
You can further configure more by ask.

After complete, you can disable that plugin to save context:
```
/plugin disable claude-hud
```
The plugin is just a bootstrapping tool. Once configured, claude-hud status line will continue to work without this plugin.

If you don't like claude-hud, you can also customize your own using Claude built-in `/statusline` command.

### Configure Codex Interop (Optional)
This will guide you to install [codex-plugin-cc](https://github.com/openai/codex-plugin-cc), a plugin to allow Claude Code invoke Codex.

Make sure you have `codex` installed and login. If you are not using `codex`, skip this step - this plugin is not for you.

Type in Claude Code, one by one:
```
/plugin marketplace add openai/codex-plugin-cc
/plugin install codex@openai-codex
/reload-plugins
/codex:setup
```

### Official Plugins Recommendation
These are the other plugins I installed from Claude official marketplace.
```
/plugin install clangd-lsp
/plugin install claude-md-management
/plugin install code-simplifier
/plugin install context7
/plugin install pyright-lsp
/reload-plugins
```

## Mobile Remote Control (Optional)

### Official Remote Control
Enabling remote control in Claude mobile app:
```bash
claude remote-control
```

Or typing in an existing Claude Code session:
```
/remote-control
```

Cons:
- Requires Claude Pro paid subscription.
- Poor optimization at this moment.

### Third-party Remote Control
[happy](https://github.com/slopus/happy) is a mobile and web client for Claude Code & Codex.
```bash
npm install -g happy-coder
happy
```

### Installing cc-connect
cc-connect is a tool bridges AI coding agents (Claude Code, Codex, OpenCode, etc.) to your instant messaging platforms (Discord, Feishu, Weixin, Telegram, etc.).

Replaces OpenFlaw.

```bash
npm install -g cc-connect@beta
```

You can configure various messaging platforms following the [official document](https://github.com/chenhg5/cc-connect) guide.

All our configuration (plugins, skills, hooks) in Claude Code will be available in cc-connect once Claude Code configured as backend.

## Troubleshooting

### Statusline Error
Problem: Starting `claude` in home shows warning `statusline skipped - restart to fix`
Fix: Edit `~/.claude/settings.json`, find `"/home/bate"` (where bate is your user name), change:
```diff
-"hasTrustDialogAccepted": false,
+"hasTrustDialogAccepted": true,
```

### Settings Broken?
If settings doesn't work, you may also copy my example settings:
```bash
cp ~/.claude/settings.json ~/.claude/settings.json.bak
cp settings.example.json ~/.claude/settings.json
nvim ~/.claude/settings.json  # edit the settings for your own needs
```

## Tooling

### AI Coding Agent

Living in terminal:
- Claude Code (as this repo is for)
- OpenCode
- Crush
- Codex
- Gemini CLI
- Kimi CLI

Graphical IDEs:
- Cursor
- Kilo/Kiro Code
- Cline

Poops:
- OpenFlaw

### AI Models

Here are the models I ever used, personal subjective ranking. Not used models are not listed.

Top tier:
- Claude Opus 4.6

Tier 1:
- DeepSeek V3.2
- GLM-5.1
- Claude Sonnet 4.6

Tier 2:
- GLM-5
- GLM-5-Turbo
- GPT-5.2-Codex
- Claude Haiku 4.5

Tier 3:
- GLM-4.7
- GPT-5.3-Codex

Here are the subjective ranking of models concluded from my friends and collegues review:

Tier 0:
- Gemini 3.1 Preview
- Claude Opus 4.6

Tier 1:
- GPT-5.4

Tier 2:
- Kimi K2.5
- Composer 2 (in Cursor)
- GLM-5
- Claude Sonnet 4.6

Tier 3:
- GLM-4.7
- GPT-5.3-Codex

Tier 4:
- Minimax M2.5
- QWen Coder xxx whatever

### Modern Terminals

Use a modern terminal to avoid clogging Claude Code.

- Ghostty (recommended by Claude Code official team)
- Kitty (my favorite)
- Smux, Cmux, Warp, WezTerm, Alacritty...

All above terminals have built-in multiplexing functionality, which is important to agentic developers.

For terminal with no or poor built-in multiplexing, use a terminal multiplexing tool.

- Tmux (my favorite)
- Zellij (claimed to be intuitive but I hate this: too much key bindings, conflict with NeoVim and Claude Code)
- OpenMux (powered by OpenTUI, same technique in OpenCode)

Reason of my choice:
- Tmux additionally provides persistency to multiplexing, crucial for SSH (remote server) users
- Kitty is beautiful (in my aesthetic) and fast, keyboard-first design, fits neatly into my i3wm enviroment

### Shell

Setting default shell to other than `bash` is okay for Claude Code, as Claude Code always uses `bash -c '<command>'` for their `Bash` tool, no compatibility issues.

> Thus, please make sure your bash has reasonable configuration in `~/.bashrc`, otherwise may slowdown `Bash` tool execution in Claude Code.

On the other hand, OpenCode have an issue of invoking `$SHELL` instead of `bash -ic` for their 'Bash' tool, which may confuse the LLM agent, make sure to alias `SHELL=/bin/bash opencode` to prevent compatibility issues if you are using fish.

Feel free to set default shell to `zsh` or `fish` if you are using Claude Code. So I set my default shell to `fish` which is my favorite.

### Editor

I use NeoVim. Coupled with Claude Code, NeoVim is not responsible for writing code, but for writing Markdown files and prompts.

I set `$EDITOR` to `nvim` so that Claude Code starts NeoVim when pressing `C-g` (edit long prompts in NeoVim)

### File Manager

A terminal file manager works better than manual `mv` and `cp` in shell.

So `yazi` is a cool choice but, I personally prefer use the `oil.nvim` plugin of NeoVim which is super intuitive to Vim users - just watch their demo video, and you will understand why.

### Modern CLI Tools

These CLI tools are in knowledge cutoff time in most LLM models and nice for agent use:

- `rg` not `grep`
- `fd` not `find`
- `exa` not `ls`
- `sd` not `sed`
- `just` not `make`
- `uv` not `pip`
- `uv run` not `python3`
- `pnpm` not `npm`
- `ast-grep` (`sg`)
- `duckdb`
- `mlr` (miller)
- `jc`
- `gron`
- `pueue`
- `gh`
- `pdftotext`
- `sqlite3`
- `hyperfine`

I've already documented them in [`CLAUDE.md`](CLAUDE.md).

### Other Configurations

Check out my other configurations:

- Dotfiles (Kitty & i3wm) - [https://github.com/archibate/dotfiles]
- Tmux - [https://github.com/archibate/dotfiles-tmux]
- NeoVim - [https://github.com/archibate/dotfiles-nvim]
- Fish Shell - [https://github.com/archibate/dotfiles-fish]
- OpenCode - [https://github.com/archibate/dotfiles-opencode]
