# Archibate's Claude - Setup Guide

**English** | [中文 译 GLM-5.1](README.zh-CN.md)

Sharing my Claude Code configuration from personal use.

## Known Limitations

### Designed For Claude Code
Note that the setup guide below is aimed at Claude Code, and may not work universally for all agents. See [archibate/dotfiles-opencode](https://github.com/archibate/dotfiles-opencode) if you are looking for OpenCode configuration, which is an open-source alternative for Claude Code.

Fun fact: I recently found that Cursor and OpenCode seems able to automatically compatible to Claude Code configurations under `~/.claude` by default :) So you may install this pack, and expect it to work automatically in Cursor and OpenCode!

Already have OpenCode configuration? No worry since OpenCode's compatibility to Claude Code is a union merge, not replacement. You will have both your native OpenCode configuration plus all skills in this Claude Code pack, together in OpenCode sessions.

### No Warranty On Microshit Windows
Microshit Windows (TM) is simply not friendly to both developers and AI agents: mouse-first, anti-POSIX, anti-developer design.

AI agents use codes and APIs (not mouse) to investigate and manipulate your system. Windows is against this.

Claude Code (and most other agentic tools) are optimized for Unix platforms. This configuration pack as well: I'm not sure if it works well on Windows.

Actually Claude Code itself have several known issues on Windows. Common examples are UTF-8 compatibility causing clipboard paste Chinese characters as bizarre characters, and poor Bash support - LLMs are simply trained to work better in bash rather than powershell (lower hallucination rate).

Windows user please consider use WSL or SSH to remote server for best experience.

### Skills with Dependencies
Some skills require dependent tools installed to work.

For example: `just-cli` skill requires the `just` tool installed; `tmux` skill of course requires `tmux`.

Just type "please install just for me" into Claude Code and it will install for you.

> May also say "please install latest tmux from source for me" if the one in your package manager is too old, and you don't know how to install traditional C softwares from source. AI agents are good at getting dirty shell jobs done.

### Account Banning Concerns
Read this section only if you are using Claude official subscription. Common ban reasons are:

1. Using Claude subscription in OpenClaw, OpenCode, Codex - Claude subscription is for Claude Code and Claude Desktop only. The OAuth2 of OpenClaw is misleading, can ruin your Claude account! You can only use Claude as API billing in OpenClaw, not as subscription.
2. Using a poor VPN provider; Quickly switching IP locations - Anthropic bans suspectious user IPs as a risk control policy.
3. Continue to use the same enviroment and location after ban - Claude Code records various fingerprints, including `git config user.email`, according to my inspection into CC source code. Your fingerprint might get blacklisted after one ban, even if you buy a new account from Taobao. This explains why some people get banned again and again after first ban.

Critical information: You should get full refund in money when being banned. You can get ALL your money back, not part of it. If a Taobao purchased Claude account doesn't revoke all money back on banned:

This Taobao merchant is a sneaky theft! they steal and sell your account with money-making API router sites, purposingly make your account get banned!
- Anthropic: oh this is a risky account! we need to ban it and refund their money.
- Merchant: eat all the money Anthropic refunds, and told you this is "Anthropic's fault".
- You: believed, oh fuck Anthropic, and you say "thank" to these thefts.

For my case, I brought a Claude subscription on Taobao last month, and I've never been banned by Claude subscription since then. I never greed for small discounts, suspectiously cheap prices are 99% pitfalls.

### Fun Facts on Zhipu

As a comparision, Zhipu won't ban you because you use their Coding Plan in Claude Code - actually they encourages you to do so.

In fact the advertised SWE-bench scores on Zhipu official site are created by running GLM models in Claude Code - the industry acknowledged best coding agent.

## What's in here?

### [`CLAUDE.md`](CLAUDE.md)

- **Modern Alternatives** - Prefers `rg`, `fd`, `exa`, `sd`, `just`, `uv`, `pnpm` over legacy tools
- **Agent CLI Tools** - `ast-grep`, `duckdb`, `mlr`, `jc`, `gron`, `pueue`, `gh`, `pdftotext`, `sqlite3`, `hyperfine`
- **Python Preferences** - `uv` for package management, `ruff` + `basedpyright` for linting
- **Background Tasks** - Load `pueue` skill for long-running tasks (>2 min)
- **Writing Style** - Maintain consistent tone, changes should blend naturally
- **Code Collaboration** - Proactive collaboration, minimal comments, faithful reporting, verify before done (inspired by Anthropic ant mode prompts)

### [Skills](skills/)

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
- `better-translate` - Best practices for AI-driven English-to-Chinese translation

#### [Optional Skills](optional-skills/)

These skills are **not installed by default**. Copy or symlink the ones you need to `~/.claude/skills/`.

**Web & Data:**
- `jina-ai` - Jina AI web search and URL-to-Markdown conversion (alternative to Jina MCP)
- `mcp-deepwiki` - Query DeepWiki for open-source project docs (alternative to DeepWiki MCP)
- `mcp-duckgo` - Web search and content scraping via DuckDuckGo MCP
- `bilibili-api` - Bilibili API wrapper (video download, user info, danmaku, live, etc.)

**Development & Design:**
- `frontend-design` - Design and implement polished frontend interfaces
- `shader-dev` - GLSL shader techniques (ray marching, SDF, particles, post-processing)
- `openscad` - Create, preview, and export OpenSCAD 3D models
- `remotion` - React-based video creation with Remotion
- `color-themes` - Color palettes for UI/UX and desktop config (i3wm, dunst, etc.)

**AI & Vision:**
- `glm-vision` - Image analysis using Zhipu GLM-4.6V multimodal model
- `qwen-asr` - Audio transcription using Qwen ASR (no API key required)

**Browser & Automation:**
- `chrome-cdp` - Interact with local Chrome browser via DevTools Protocol

**Discovery:**
- `find-skills` - Discover and install skills from the open agent skills ecosystem

**Lifestyle:**
- `weather` - Weather forecast for Chinese locations

### [Hooks](hooks/)

- `no-heredoc.sh` - Prevents heredoc anti-patterns
- `no-cat-write.sh` - Enforces using Write tool instead of `cat >`
- `no-background-ampersand.sh` - Prevents `&` background suffix in Bash commands
- `no-sed-print.sh` - Prevents `sed -n`/`sed -p` patterns
- `no-sleep-pueue.sh` - Recommends `pueue follow` over `sleep` poll
- `pep723-script.sh` - Auto-adds PEP 723 inline metadata to Python scripts
- `link-venv.sh` - Links venv on session start
- `show-image-on-read.sh` - Displays images when read

#### [Optional Hooks](optional-hooks/)

- `no-cat-read.sh` - Enforces using Read tool instead of `cat`
- `modern-tools.sh` - Recommends modern CLI tools (rg, fd, exa, sd, etc.)

### Example Settings

Read [`settings.example.json`](settings.example.json) for my personal setup. You may update your `~/.claude/settings.json` accordingly if you find it make sense.

To copy my settings as-is, you may run:
```bash
cp ~/.claude/settings.json ~/.claude/settings.json.bak
cp settings.example.json ~/.claude/settings.json
```

## Installation Steps

### Install Claude Code (if not yet)
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

#### Fix Terminal Flickering Problem
First upgrade to latest to enable this option:
```bash
claude update
```

Add this environment variable to your `.bashrc` (or `.zshrc`) and restart shell:
```bash
export CLAUDE_CODE_NO_FLICKER=1
```

#### Switching Model Providers
Official Claude models are expensive. Some students may prefer cheaper domestic models.

To set up Zhipu's GLM, add these to your `.bashrc` (or `.zshrc`) and restart shell:

```bash
export ANTHROPIC_AUTH_TOKEN=ZHIPU_API_KEY  # replace this by your Zhipu API key
export ANTHROPIC_API_KEY=
export ANTHROPIC_BASE_URL=https://open.bigmodel.cn/api/anthropic
export API_TIMEOUT_MS=3000000
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export ANTHROPIC_DEFAULT_HAIKU_MODEL=glm-4.7
export ANTHROPIC_DEFAULT_SONNET_MODEL=glm-5
export ANTHROPIC_DEFAULT_OPUS_MODEL=glm-5.1
```

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

### Install Archibate Claude Router

The claude router lets you switch between model providers by prefixing your command with a route name (e.g. `./claude-router.py glm`, `./claude-router.py openrouter`) configured in [`router.json`](router.example.json).

To configure the claude code router:
```bash
cp router.example.json router.json
```

Then edit [`router.json`](router.example.json) to fill your model providers and API keys. Example:

```json
{
    "default": {},
    "glm": {
        "ANTHROPIC_AUTH_TOKEN": "YOUR_TOKEN_HERE",
        "ANTHROPIC_API_KEY": "",
        "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
        "API_TIMEOUT_MS": "3000000",
        "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",
        "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-4.7",
        "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-5",
        "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-5.1"
    },
    "openrouter": {
        "ANTHROPIC_AUTH_TOKEN": "YOUR_TOKEN_HERE",
        "ANTHROPIC_API_KEY": "",
        "ANTHROPIC_BASE_URL": "https://openrouter.ai/api",
        "API_TIMEOUT_MS": "3000000",
        "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",
        "ANTHROPIC_DEFAULT_HAIKU_MODEL": "z-ai/glm-4.7",
        "ANTHROPIC_DEFAULT_SONNET_MODEL": "z-ai/glm-5",
        "ANTHROPIC_DEFAULT_OPUS_MODEL": "z-ai/glm-5.1"
    }
}
```

To make `claude` points to archibate claude router, add the appropriate line to your shell config:

```bash
# For bash (add to ~/.bashrc) or zsh (add to ~/.zshrc):
source /path/to/archibate-skills/integration.sh

# For fish (add to ~/.config/fish/config.fish):
source /path/to/archibate-skills/integration.fish
```

Where `/path/to/archibate-skills` is the path to this project. This adds:
- `claude` wrapper that routes through the claude router
- `commit` alias for quick git commits via claude

Running `./shell_integration_install.sh` will auto-detect your shell and offer to add the line.

After that, you may invoke `claude glm` or `claude openrouter` to use the configured route at start up. When no argument specified, defaults to the `"default"` route (routes to official Claude in this example).

- Other third-party alternatives: `ccr`, `cc-switch`

No worry. It was tacitly approved to use alternative providers in Claude Code, not violates Anthropic Term of Services (Anthropic just want Claude Code popularity in community). Using `claude glm` and official `claude` at the same time will never be a cause of account ban. In AI agent community, many people use CC routers publicly.

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
The `--scope user` option means to configure globally instead of configuring in current project.

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
- Have higher invocation rate: agents highly tend to use jina.ai instead of built-in WebSearch and WebFetch tools.
- Seems to have more functionality (e.g. Arxiv and SSRN specialized fetcher).

Cons:
- Occupies about 1k token in agent context, waste your token if you don't use search and fetch often.
- May distract the model when working on tasks unrelated to web searches.

##### Jina Skill
Pros:
- Save more tokens for most scenarios when Jina is not necessarily used.
- Saves model attention, prevent distraction in unrelated tasks.

Cons:
- Agents may forget to use jina.ai instead of built-in web tools.
- Has less functionality (only search and fetch).

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

To my claude-hud configuration as-is, you may run:
```bash
cp claude-hud-config.example.json ~/.claude/plugins/claude-hud/config.json
```

If you don't like claude-hud, you can also customize your own using Claude built-in `/statusline` command.

#### Configure Codex Interop (Optional)
This will guide you to install [codex-plugin-cc](https://github.com/openai/codex-plugin-cc), a plugin to allow Claude Code to invoke Codex.

Make sure you have `codex` installed and logged in.

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
cc-connect is a tool that bridges AI coding agents (Claude Code, Codex, OpenCode, etc.) to your instant messaging platforms (Discord, Feishu, Weixin, Telegram, etc.).

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

### Outputting Glitch on Long Conversation (when using Zhipu GLM-5)

This is a known bug of GLM, not Claude Code.

> I meet this in OpenCode frequently too. Only when using GLM models, never happens in GPT-Codex and Claude models. Some students report this happens in Gemini too. Might be a problem with sparse attention - Claude and GPT are dense, while GLM/DeepSeek/Gemini are sparse attention.

So GLM advertises 200k context (to match up with their Anthropic competitors), but they are actually only capable of ~128k context :)

Above ~128k context, GLM have a high chance to fail into chaotic glitch response.

To avoid this, trigger auto-compact earlier at `50%`:

```bash
export CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50
```

So that limits context max to 100k.

However, this only reduces the 'chance' of glitch, but still are cases GLM glitches at ~30% context, really annoying.

Switch to expensive model providers (official Claude is best) to eliminate this.

GLM-5.1 is also having lower glitch chance compared to GLM-5 at this time.

### Claude Code Flickering
Problem: Terminal keeps flickering (blinking) when using Claude Code.
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
- Trae
- Windsurf
- Warp
- Qoder

IDE Plugins:
- Claude Code (VS Code & JetBrains)
- OpenCode (VS Code)
- Codex (VS Code)
- Cline (VS Code)
- Kilo Code (VS Code)
- GitHub Copilot (VS Code)
- CodeBuddy (VS Code)

Poops:
- OpenFlaw

#### AI Models

Here are the models I have ever used, personal subjective ranking. Not used models are not listed.

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

Here are the subjective ranking of models concluded from my friends and colleagues review:

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
- Qwen Coder xxx whatever

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
- Kitty is beautiful (in my aesthetic) and fast, keyboard-first design, fits neatly into my i3wm environment

#### Shell

Setting default shell to other than `bash` is okay for Claude Code, as Claude Code always uses `bash -c '<command>'` for their `Bash` tool, no compatibility issues.

> Thus, please make sure your bash has reasonable configuration in `~/.bashrc`, otherwise may slow down `Bash` tool execution in Claude Code.

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

- Dotfiles (Kitty & i3wm) - [archibate/dotfiles](https://github.com/archibate/dotfiles)
- Tmux - [archibate/dotfiles-tmux](https://github.com/archibate/dotfiles-tmux)
- NeoVim - [archibate/dotfiles-nvim](https://github.com/archibate/dotfiles-nvim)
- Fish Shell - [archibate/dotfiles-fish](https://github.com/archibate/dotfiles-fish)
- OpenCode - [archibate/dotfiles-opencode](https://github.com/archibate/dotfiles-opencode)
