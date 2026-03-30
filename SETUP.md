# Archibate's Claude - Setup Guide

Claude Code configuration for archibate personal use.

> Be careful that below setup guide is aimed for Claude Code, may not work universally for all agents. See [dotfiles-opencode](https://github.com/) if you are looking for OpenCode configuration, which is an open-source alternative for Claude Code.

### Clone this Repo
```bash
git clone https://github.com/archibate/archibate-skills ~/archibate-skills
```

### Install Archibate Settings
```bash
cp ~/.claude/settings.json ~/.claude/settings.json.bak
cp settings.example.json ~/.claude/settings.json
```

### Install Archibate Skills and Hooks
Run my one-shot installation script:
```bash
./install.sh
```

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

## Configure Status Line (claude-hud)
This will guide you to configure [claude-hud](https://github.com/jarrodwatts/claude-hud), a status line plugin.

Type in Claude Code, one by one:
```
/plugin marketplace add jarrodwatts/claude-hud
/plugin install claude-hud
/reload-plugin
/claude-hud:setup
```
You can further configure more by ask.

After complete, you can disable that plugin to save context:
```
/plugin disable claude-hud
```
The plugin is just a bootstrapping tool. Once configured, claude-hud status line will continue to work without this plugin.

If you don't like claude-hud, you can also customize your own using Claude built-in `/statusline` command.

## Troubleshooting

Problem: Starting `claude` in home saying `statusline skipped - restart to fix`
Fix: Edit `~/.claude/settings.json`, find `"/home/bate"` (where bate is your user name), change:
```diff
-"hasTrustDialogAccepted": false,
+"hasTrustDialogAccepted": true,
```
