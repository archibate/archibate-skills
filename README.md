# Archibate's Claude - Setup Guide

Sharing my Claude Code configuration from personal use.

## Known Limitations

### Designed For Claude Code

Be careful that below setup guide is aimed for Claude Code, may not work universally for all agents. See [dotfiles-opencode](https://github.com/) if you are looking for OpenCode configuration, which is an open-source alternative for Claude Code.

### No Warranty On Microshit Windows

Microshit Windows (TM) is simply not friendly to both developers and AI agents: mouse-first, anti-POSIX, anti-developer design.

AI agents use codes and APIs (not mouse) to investigate and manipulate your system. Windows is against this.

Claude Code (and most other agentic tools) are optimized for Unix platforms. This configuration pack as well: I'm not sure if works well on Windows.

Actually Claude Code itself have several known issues on Windows. COmmon examples are UTF-8 compatibility causing clipboard paste Chinese characters as bizzare KunKeenKaw characters, and poor Bash support - LLMs are simply trained to work better in bash rather than powershell (lower hallucination rate).

Windows user please consider use WSL or SSH to remote server for best experience.

### Skills with Dependencies

Some skills require dependent tools installed to work.

For example: `just-cli` skill require the `just` tool installed; `tmux` skill of course requires `tmux`.

Just type "please install just for me" into Claude Code and it will install for you.

> May also say "please install latest tmux from source for me" if the one in your package manager is too old, and you don't know how to install traditional C softwares from source. AI agents are good at getting dirty shell jobs done.

## What's in there?

### Skills

**Agent & Plugin Development:**
- `agent-development` - Creating autonomous agents for Claude Code plugins
- `hook-development` - Creating event-driven hooks (PreToolUse, PostToolUse, etc.)
- `skill-development` - Creating skills for Claude Code plugins
- `skillify` - Capture session workflow into a reusable skill

**Automation & Orchestration:**
- `agent-crew` - Multi-specialist agent orchestration for complex tasks
- `agent-browser` - Browser automation CLI (navigate, click, screenshot, scrape)
- `self-driven` - Autonomous agent for long-running tasks without human intervention
- `pueue` - Background task management for long-running tasks
- `long-waits` - Schedule delayed/recurring tasks for extended waits (>10 min)
- `tmux` - Remote control tmux sessions for interactive CLIs

**Code Search & Analysis:**
- `ast-grep` - AST-based structural code search
- `code-quality-metrics` - Cyclomatic/cognitive complexity metrics
- `anti-defensive` - Review defensive programming anti-patterns
- `review-ai-slop` - Review code for AI-generated slop patterns

**Web & Data:**
- `scrapling` - Web scraping with anti-bot bypass (Cloudflare, etc.)
- `cc-connect` - Send images/files via messaging platforms (Discord, Telegram)
- `librarian` - Cache remote git repos locally for reuse

**Utilities:**
- `just-cli` - Just command runner documentation
- `show-image` - Display images in Kitty terminal
- `grill-me` - Interview user about plans before implementation
- `skillful` - Force agent to load skills before conversation

### Hooks

- `no-heredoc.sh` - Prevents heredoc anti-patterns
- `no-cat-write.sh` - Enforces using Write tool instead of `cat >`
- `no-background-ampersand.sh` - Prevents `&` background suffix in Bash commands
- `no-sed-print.sh` - Prevents `sed -n`/`sed -p` patterns
- `no-sleep-pueue.sh` - Recommends pueue over raw `sleep`
- `pep723-script.sh` - Auto-adds PEP 723 inline metadata to Python scripts
- `link-venv.sh` - Links venv on session start
- `show-image-on-read.sh` - Displays images when read

Optional hooks (in `optional-hooks/`):
- `no-cat-read.sh` - Enforces using Read tool instead of `cat`
- `modern-tools.sh` - Recommends modern CLI tools (rg, fd, exa, sd, etc.)

## Installation Steps

### Install Claude Code (if not yet)

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

> If you've already installed, make sure to run `claude update` to get latest version for new features.

### Clone this Repo
```bash
git clone https://github.com/archibate/archibate-skills ~/archibate-skills
```

### Install Skills and Hooks
Run my one-shot installation script:
```bash
./install.sh
```

This will install:
- Skills symlinked to `~/.claude/skills/` (agent-browser, agent-crew, pueue, etc.)
- CLAUDE.md symlinked to `~/.claude/CLAUDE.md`
- Hooks symlinked to `~/.claude/hooks/` and registered in `settings.json`
- Codex integration (if `~/.codex` exists)

### Install Fish Intergration (optional)
If you are using `fish` shell, you may add this to your `~/.config/fish/config.fish` or whatever:
```fish
source /path/to/archibate-skills/intergration.fish
```
Where `/path/to/archibate-skills` is path to this project.

This adds `commit` alias and the claude code router in this project as `claude` alias.

To configure the claude code router:
```bash
cp router.example.json router.json
```
Then edit `router.json` to fill your model providers and API keys.

### Configure MCP Servers

#### Install Context7 MCP
Type in Claude Code:
```
/plugin install context7
```

#### Install gh-grep MCP
Type in Bash:
```bash
claude mcp add --transport http grep https://mcp.grep.app --scope user
```
The `--scope user` option means to configure globally instead of configure in current project.

#### Install Jina MCP
```bash
claude mcp add -s user --transport http jina https://mcp.jina.ai/v1 --header "Authorization: Bearer $JINA_API_KEY"
```

Jina.ai API key can be obtained from https://jina.ai/, with 10M tokens free tier.

See [`jina-ai/MCP`](https://github.com/jina-ai/MCP) for more details.

Jina MCP capabilities:
- Search web results, replaces WebSearch.
- Fetch web pages, replaces WebFetch.
- Return in LLM-friendly Markdown format.
- Able to scrape Arxiv, SSRN for papers.

Alternatively, you may install the `jina-ai` skill in `optional-skills` folder.

##### Jina MCP

Pros:
- Have higher invocation rate: agent highly tend to use jina.ai instead of built-in WebSearch and WebFetch tools.
- Seems to have more functionality (e.g. Arxiv and SSRN specialized fetcher).
Cons:
- Occupies about 1k token in agent context, waste your token if you don't use search and fetch often.
- May distracts model when working on tasks unrelated to web searches.

##### Jina Skill

- Pros:
- Save more tokens for most scenarios when Jina is not necessary used.
- Saves model attention, prevent distraction in unrelated tasks.
- Cons:
- Agents may forget to use jina.ai instead of built-int web tools.
- Have less functionality (only search and fetch).

#### Install DeepWiki MCP
```bash
claude mcp add -s user -t http deepwiki https://mcp.deepwiki.com/mcp
```

Alternatively, you may install the `mcp-deepwiki` skill in `optional-skills` folder.

The Pros and Cons are similar as above Jina MCP vs skill.

### Configure Plugins

#### Claude Official Plugins Recommended
These are the other plugins I installed from Claude official marketplace.
```
/plugin install clangd-lsp
/plugin install claude-md-management
/plugin install code-simplifier
/plugin install context7
/plugin install pyright-lsp
/reload-plugins
```

#### Configure Status Line (claude-hud)
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

#### Configure Codex Interop (Optional)
This will guide you to install [codex-plugin-cc](https://github.com/openai/codex-plugin-cc), a plugin to allow Claude Code invoke Codex.

Make sure you have `codex` installed and login.

If you are not using `codex`, skip this step - this plugin is not for you.

Type in Claude Code, one by one:
```
/plugin marketplace add openai/codex-plugin-cc
/plugin install codex@openai-codex
/reload-plugins
/codex:setup
```

### Configuring Remote Control
Read this section if you'd like to control Claude Code from mobile. Here's my approaches:

#### Official Remote Control
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

#### Third-party Remote Control
[happy](https://github.com/slopus/happy) is a mobile and web client for Claude Code & Codex.
```bash
npm install -g happy-coder
happy
```

#### Installing cc-connect
cc-connect is a tool bridges AI coding agents (Claude Code, Codex, OpenCode, etc.) to your instant messaging platforms (Discord, Feishu, Weixin, Telegram, etc.).

Replaces OpenFlaw.

```bash
npm install -g cc-connect@beta
```

You can configure various messaging platforms following the [official document](https://github.com/chenhg5/cc-connect) guide.

All our configuration (plugins, skills, hooks) in Claude Code will be available in cc-connect once Claude Code configured as backend.

##### Showing Images

Claude Code lives in terminal can't show images. The `cc-connect` skill allows agent to send back images and files via your configured messaging platforms.

Alternatively, if you are in Kitty terminal, you may install the `show-image` skill in `optional-skills`. This skill is able to show image directly in Kitty terminal (thanks to the Kitty image protocol).

## Troubleshooting

### Claude Code Flickering
Problem: Terminal keep flickering (blinking) when using Claude Code.
Fix: Edit `~/.claude/settings.json`, add:
```diff
{
  "env": {
    ...,
    "CLAUDE_CODE_NO_FLICKER": "1"
  },
  ...
}
```

> Alternatively, you may add an enviroment variable `export CLAUDE_CODE_NO_FLICKER=1` in your `.bashrc`.

See [`settings.example.json`](settings.example.json) for example.

### Statusline Error
Problem: Starting `claude` in home shows warning `statusline skipped - restart to fix`
Fix: Edit `~/.claude.json`, find `"/home/bate"` (where bate is your user name), change:
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

## Miscellaneous

### Tooling Recommendation

#### AI Coding Agent

Living in terminal:
- Claude Code (as this repo is for)
- OpenCode
- Crush
- Codex
- Gemini CLI
- Kimi CLI
- Qwen Coder
- Pi Agent

Graphical IDEs:
- Cursor
- Kiro Code
- Cline
- Trae
- Windsurf
- Warp
- Qoder

Poops:
- OpenFlaw

#### AI Models

Here are the models I ever used, personal subjective ranking. Not used models are not listed.

Top tier:
- Claude Opus 4.6

Tier 1:
- DeepSeek V3.2
- GLM-5.1
- Claude Sonnet 4.6
- GPT-5.2-Codex

Tier 2:
- Claude Haiku 4.5
- GLM-5
- GLM-5-Turbo

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

#### Modern Terminals

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

#### Shell

Setting default shell to other than `bash` is okay for Claude Code, as Claude Code always uses `bash -c '<command>'` for their `Bash` tool, no compatibility issues.

> Thus, please make sure your bash has reasonable configuration in `~/.bashrc`, otherwise may slowdown `Bash` tool execution in Claude Code.

On the other hand, OpenCode have an issue of invoking `$SHELL` instead of `bash -ic` for their 'Bash' tool, which may confuse the LLM agent, make sure to alias `SHELL=/bin/bash opencode` to prevent compatibility issues if you are using fish.

Feel free to set default shell to `zsh` or `fish` if you are using Claude Code. So I set my default shell to `fish` which is my favorite.

#### Editor

I use NeoVim. Coupled with Claude Code, NeoVim is not responsible for writing code, but for writing Markdown files and prompts.

I set `$EDITOR` to `nvim` so that Claude Code starts NeoVim when pressing `C-g` (edit long prompts in NeoVim)

#### File Manager

A terminal file manager works better than manual `mv` and `cp` in shell.

So `yazi` is a cool choice but, I personally prefer use the `oil.nvim` plugin of NeoVim which is super intuitive to Vim users - just watch their demo video, and you will understand why.

#### Modern CLI Tools

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
