# Archibate 的 Claude - 配置指南

[English](README.md) | **中文 译 GLM-5.1**

分享我的个人 Claude Code 配置。

## 已知限制

### 专为 Claude Code 设计
请注意，以下配置指南主要面向 Claude Code，不一定适用于所有 AI 代理。如果你正在寻找 OpenCode（Claude Code 的开源替代方案）的配置，请参阅 [archibate/dotfiles-opencode](https://github.com/archibate/dotfiles-opencode)。

趣闻：我最近发现 Cursor 和 OpenCode 似乎能够默认自动兼容 `~/.claude` 下的 Claude Code 配置 :) 所以你可以安装这个包，然后在 Cursor 和 OpenCode 中自动使用！

已经有 OpenCode 配置了？不用担心，OpenCode 对 Claude Code 的兼容是合并（union merge），不是替换。你将同时拥有原生的 OpenCode 配置加上本包中的所有技能。

### 不保证支持 Microshit Windows
Microshit Windows (TM) 对开发者和 AI 代理都不友好：鼠标优先、反 POSIX、反开发者设计。

AI 代理通过代码和 API（而非鼠标）来操作你的系统。Windows 与此理念相悖。

Claude Code（以及大多数其他代理工具）针对 Unix 平台进行了优化。本配置包也是如此：我不确定它在 Windows 上能否正常工作。

实际上 Claude Code 本身在 Windows 上就有若干已知问题。常见例子包括 UTF-8 兼容性导致剪贴板粘贴中文字符时出现乱码，以及 Bash 支持不佳——LLM 在 bash 上的训练效果远优于 PowerShell（幻觉率更低）。

Windows 用户建议使用 WSL 或 SSH 远程服务器以获得最佳体验。

### 依赖工具的技能
部分技能需要安装相应的依赖工具才能使用。

例如：`just-cli` 技能需要安装 `just` 工具；`tmux` 技能当然需要安装 `tmux`。

只需在 Claude Code 中输入"请帮我安装 just"，它就会为你安装。

> 如果你的包管理器中的版本太旧，也可以说"请帮我从源码安装最新版 tmux"。AI 代理擅长处理这类繁琐的 shell 工作。

### 账号封禁须知
本节仅适用于使用 Claude 官方订阅的用户。常见封禁原因：

1. 在 OpenClaw、OpenCode、Codex 中使用 Claude 订阅——Claude 订阅仅适用于 Claude Code 和 Claude Desktop。OpenClaw 的 OAuth2 存在误导性，可能会毁掉你的 Claude 账号！在 OpenClaw 中只能使用 API 计费的 Claude，不能使用订阅。
2. 使用劣质 VPN 提供商；快速切换 IP 所在地——Anthropic 作为风控策略会封禁可疑用户 IP。
3. 封禁后继续使用相同环境和位置——根据我对 CC 源码的检查，Claude Code 会记录各种指纹信息，包括 `git config user.email`。你的指纹可能在一次封禁后被列入黑名单，这解释了为什么有些人在首次封禁后反复被封（即使从淘宝买了新账号）。

重要信息：被封禁时你应该获得全额退款。你可以拿回所有钱，不是部分退款。如果淘宝购买的 Claude 账号被封后没有全额退款：

这个淘宝商家是个奸商！他们盗取并出售你的账号用于 API 路由站牟利，故意造成你的账号被封！
- Anthropic：这个账号有风险！我们需要封禁并退款。
- 商家：私吞 Anthropic 退还的所有款项，然后告诉你这是"Anthropic 的错"。
- 你：信以为真，骂 Anthropic，还对奸商说"谢谢"。

就我而言，我上个月在淘宝买了 Claude 订阅，从那以后从未被 Claude 封过号。我从不会贪图小折扣，可疑的低价 99% 是陷阱。

### 关于智谱的趣闻

作为对比，智谱不会因为你把编程套餐用在 Claude Code 里就封你——实际上他们还鼓励你这么做。

事实上，智谱官网上宣传的 SWE-bench 分数就是用 GLM 模型在 Claude Code 中运行得到的——业界公认的最佳编程代理。

## 包含内容

### [`CLAUDE.md`](CLAUDE.md)

- **现代替代工具** - 优先使用 `rg`、`fd`、`exa`、`sd`、`just`、`uv`、`pnpm` 而非传统工具
- **代理 CLI 工具** - `ast-grep`、`duckdb`、`mlr`、`jc`、`gron`、`pueue`、`gh`、`pdftotext`、`sqlite3`、`hyperfine`
- **Python 偏好** - 使用 `uv` 管理包，`ruff` + `basedpyright` 进行代码检查
- **后台任务** - 长时间运行的任务（>2 分钟）加载 `pueue` 技能
- **写作风格** - 保持一致的语调，修改应自然融入
- **代码协作** - 主动协作、最少注释、如实汇报、完成前验证（受 Anthropic ant 模式提示启发）

### [技能](skills/)

**代理与插件开发：**
- `agent-development` - 为 Claude Code 插件创建自主代理
- `hook-development` - 创建事件驱动钩子（PreToolUse、PostToolUse 等）
- `skill-development` - 为 Claude Code 插件创建技能
- `skillify` - 将会话工作流捕获为可复用的技能

**自动化与编排：**
- `agent-crew` - 多专家代理编排，处理复杂任务
- `agent-browser` - 浏览器自动化 CLI（导航、点击、截图、抓取）
- `self-driven` - 无需人工干预的长时间任务自主代理
- `pueue` - 长时间运行任务的后台任务管理
- `long-waits` - 延迟/周期性任务调度（等待 >10 分钟）
- `tmux` - 远程控制 tmux 会话，用于交互式 CLI

**代码搜索与分析：**
- `ast-grep` - 基于 AST 的结构化代码搜索
- `code-quality-metrics` - 圈复杂度/认知复杂度指标
- `anti-defensive` - 审查防御性编程反模式
- `review-ai-slop` - 审查 AI 生成的低质量代码模式

**Web 与数据：**
- `scrapling` - 带 anti-bot 绕过的网页抓取（Cloudflare 等）
- `cc-connect` - 通过消息平台发送图片/文件（Discord、Telegram）
- `librarian` - 本地缓存远程 git 仓库以便复用

**实用工具：**
- `just-cli` - Just 命令运行器文档
- `show-image` - 在 Kitty 终端中显示图片
- `grill-me` - 实现前先面试用户关于计划的问题
- `skillful` - 强制代理在对话前加载技能

#### [可选技能](optional-skills/)

这些技能**默认不安装**。将你需要的复制或符号链接到 `~/.claude/skills/`。

**Web 与数据：**
- `jina-ai` - Jina AI 网页搜索和 URL 转 Markdown（Jina MCP 的替代方案）
- `mcp-deepwiki` - 查询 DeepWiki 获取开源项目文档（DeepWiki MCP 的替代方案）
- `mcp-duckgo` - 通过 DuckDuckGo MCP 进行网页搜索和内容抓取
- `bilibili-api` - Bilibili API 封装（视频下载、用户信息、弹幕、直播等）

**开发与设计：**
- `frontend-design` - 设计和实现精美的前端界面
- `shader-dev` - GLSL 着色器技术（光线行进、SDF、粒子、后处理）
- `openscad` - 创建、预览和导出 OpenSCAD 3D 模型
- `remotion` - 基于 React 的视频创作
- `color-themes` - UI/UX 和桌面配置的调色板（i3wm、dunst 等）

**AI 与视觉：**
- `glm-vision` - 使用智谱 GLM-4.6V 多模态模型进行图像分析
- `qwen-asr` - 使用 Qwen ASR 进行音频转录（无需 API 密钥）

**浏览器与自动化：**
- `chrome-cdp` - 通过 DevTools Protocol 与本地 Chrome 浏览器交互

**发现：**
- `find-skills` - 从开放代理技能生态中发现和安装技能

**生活：**
- `weather` - 中国地区天气预报

### [钩子](hooks/)

- `no-heredoc.sh` - 防止 heredoc 反模式
- `no-cat-write.sh` - 强制使用 Write 工具而非 `cat >`
- `no-background-ampersand.sh` - 防止在 Bash 命令中使用 `&` 后台后缀
- `no-sed-print.sh` - 防止 `sed -n`/`sed -p` 模式
- `no-sleep-pueue.sh` - 推荐使用 `pueue follow` 而非 `sleep` 轮询
- `pep723-script.sh` - 自动为 Python 脚本添加 PEP 723 内联元数据
- `link-venv.sh` - 会话启动时链接 venv
- `show-image-on-read.sh` - 读取文件时显示图片

#### [可选钩子](optional-hooks/)

- `no-cat-read.sh` - 强制使用 Read 工具而非 `cat`
- `modern-tools.sh` - 推荐现代 CLI 工具（rg、fd、exa、sd 等）

### 示例设置

查看 [`settings.example.json`](settings.example.json) 了解我的个人配置。如果你觉得合适，可以相应更新你的 `~/.claude/settings.json`。

## 安装步骤

### 安装 Claude Code（如果尚未安装）
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

#### 修复终端闪烁问题
首先升级到最新版本以启用此选项：
```bash
claude update
```

将此环境变量添加到你的 `.bashrc`（或 `.zshrc`）并重启 shell：
```bash
export CLAUDE_CODE_NO_FLICKER=1
```

#### 切换模型提供商
官方 Claude 模型价格较高。部分同学可能更倾向使用更便宜的国产模型。

要配置智谱的 GLM，将以下内容添加到你的 `.bashrc`（或 `.zshrc`）并重启 shell：

```bash
export ANTHROPIC_AUTH_TOKEN=ZHIPU_API_KEY  # 替换为你的智谱 API 密钥
export ANTHROPIC_API_KEY=
export ANTHROPIC_BASE_URL=https://open.bigmodel.cn/api/anthropic
export API_TIMEOUT_MS=3000000
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export ANTHROPIC_DEFAULT_HAIKU_MODEL=glm-4.7
export ANTHROPIC_DEFAULT_SONNET_MODEL=glm-5
export ANTHROPIC_DEFAULT_OPUS_MODEL=glm-5.1
```

### 克隆本仓库
```bash
git clone https://github.com/archibate/archibate-skills ~/archibate-skills
```

### 安装技能和钩子
运行我的一键安装脚本：
```bash
./install.sh
```

这将安装：
- 技能符号链接到 `~/.claude/skills/`（agent-browser、agent-crew、pueue 等）
- CLAUDE.md 符号链接到 `~/.claude/CLAUDE.md`
- 钩子符号链接到 `~/.claude/hooks/` 并注册到 `settings.json`
- Codex 集成（如果 `~/.codex` 存在）

### 安装 Archibate Claude Router

Claude Router 允许你通过命令前缀切换模型提供商（例如 `./claude-router.py glm`、`./claude-router.py openrouter`），在 [`router.json`](router.example.json) 中配置。

配置 Claude Code Router：
```bash
cp router.example.json router.json
```

然后编辑 [`router.json`](router.example.json) 填入你的模型提供商和 API 密钥。示例：

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

要让 `claude` 指向 Archibate Claude Router，将以下行添加到你的 shell 配置中：

```bash
# bash（添加到 ~/.bashrc）或 zsh（添加到 ~/.zshrc）：
source /path/to/archibate-skills/integration.sh

# fish（添加到 ~/.config/fish/config.fish）：
source /path/to/archibate-skills/integration.fish
```

其中 `/path/to/archibate-skills` 是本项目的路径。这将添加：
- `claude` 包装器，通过 Claude Router 路由
- `commit` 别名，用于通过 claude 快速提交 git

运行 `./shell_integration_install.sh` 将自动检测你的 shell 并提示添加该行。

之后，你可以通过 `claude glm` 或 `claude openrouter` 启动时使用配置的路由。不指定参数时，默认使用 `"default"` 路由（此示例中路由到官方 Claude）。

- 其他第三方替代方案：`ccr`、`cc-switch`

不用担心。在 Claude Code 中使用替代提供商是默许的，不违反 Anthropic 服务条款（Anthropic 只是希望 Claude Code 在社区流行）。同时使用 `claude glm` 和官方 `claude` 永远不会成为账号封禁的原因。在 AI 代理社区中，很多人公开使用 CC Router。

### 配置 MCP 服务器

#### 安装 Context7 MCP
在 Claude Code 中输入：
```
/plugin install context7
```

#### 安装 gh-grep MCP
在 Bash 中输入：
```bash
claude mcp add --transport http grep https://mcp.grep.app --scope user
```
`--scope user` 选项表示全局配置而非仅在当前项目中配置。

#### 安装 Jina MCP
```bash
claude mcp add -s user --transport http jina https://mcp.jina.ai/v1 --header "Authorization: Bearer $JINA_API_KEY"
```

Jina.ai API 密钥可从 https://jina.ai/ 获取，提供 1000 万 token 免费额度。

详见 [`jina-ai/MCP`](https://github.com/jina-ai/MCP)。

Jina MCP 功能：
- 搜索网页结果，替代 WebSearch。
- 抓取网页内容，替代 WebFetch。
- 返回 LLM 友好的 Markdown 格式。
- 可抓取 Arxiv、SSRN 论文。

或者，你可以安装 `optional-skills` 文件夹中的 `jina-ai` 技能。

##### Jina MCP

优点：
- 具有更高的调用率：代理更倾向于使用 jina.ai 而非内置的 WebSearch 和 WebFetch 工具。
- 似乎有更多功能（例如 Arxiv 和 SSRN 专用抓取器）。
缺点：
- 占用代理上下文中约 1k token，不经常使用搜索和抓取时会浪费 token。
- 处理与网页搜索无关的任务时可能分散模型注意力。

##### Jina 技能

优点：
- 在大多数不需要 Jina 的场景中节省更多 token。
- 节省模型注意力，防止在无关任务中分心。
缺点：
- 代理可能会忘记使用 jina.ai 而使用内置的网页工具。
- 功能较少（仅搜索和抓取）。

#### 安装 DeepWiki MCP
```bash
claude mcp add -s user -t http deepwiki https://mcp.deepwiki.com/mcp
```

或者，你可以安装 `optional-skills` 文件夹中的 `mcp-deepwiki` 技能。

优缺点与上述 Jina MCP vs 技能类似。

### 配置插件

#### 推荐的 Claude 官方插件
以下是我从 Claude 官方市场安装的其他插件。
```
/plugin install clangd-lsp
/plugin install claude-md-management
/plugin install code-simplifier
/plugin install context7
/plugin install pyright-lsp
/reload-plugins
```

#### 配置状态栏（claude-hud）
以下将引导你配置 [claude-hud](https://github.com/jarrodwatts/claude-hud)，一个状态栏插件。

在 Claude Code 中逐行输入：
```
/plugin marketplace add jarrodwatts/claude-hud
/plugin install claude-hud
/reload-plugins
/claude-hud:setup
```
你可以进一步询问以配置更多。

完成后，可以禁用该插件以节省上下文：
```
/plugin disable claude-hud
```
该插件只是一个引导工具。配置完成后，claude-hud 状态栏将在没有此插件的情况下继续工作。

如果你不喜欢 claude-hud，也可以使用 Claude 内置的 `/statusline` 命令自定义。

#### 配置 Codex 互操作（可选）
以下将引导你安装 [codex-plugin-cc](https://github.com/openai/codex-plugin-cc)，一个允许 Claude Code 调用 Codex 的插件。

确保已安装并登录 `codex`。

如果你不使用 `codex`，请跳过此步骤——此插件不适合你。

在 Claude Code 中逐行输入：
```
/plugin marketplace add openai/codex-plugin-cc
/plugin install codex@openai-codex
/reload-plugins
/codex:setup
```

### 配置远程控制
如果你想从手机控制 Claude Code，请阅读本节。以下是我的方案：

#### 官方远程控制
在 Claude 移动应用中启用远程控制：
```bash
claude remote-control
```

或在现有 Claude Code 会话中输入：
```
/remote-control
```

缺点：
- 需要 Claude Pro 付费订阅。
- 目前优化不够。

#### 第三方远程控制
[happy](https://github.com/slopus/happy) 是 Claude Code 和 Codex 的移动端和网页客户端。
```bash
npm install -g happy-coder
happy
```

#### 安装 cc-connect
cc-connect 是一个将 AI 编程代理（Claude Code、Codex、OpenCode 等）桥接到你的即时通讯平台（Discord、飞书、微信、Telegram 等）的工具。

替代 OpenFlaw。

```bash
npm install -g cc-connect@beta
```

你可以按照[官方文档](https://github.com/chenhg5/cc-connect)指南配置各种消息平台。

Claude Code 中的所有配置（插件、技能、钩子）在将 Claude Code 配置为后端后将自动在 cc-connect 中可用。

##### 显示图片

Claude Code 运行在终端中，无法显示图片。`cc-connect` 技能允许代理通过你配置的消息平台回传图片和文件。

或者，如果你使用 Kitty 终端，可以安装 `optional-skills` 中的 `show-image` 技能。该技能能够直接在 Kitty 终端中显示图片（得益于 Kitty 图片协议）。

## 故障排除

### 长对话输出乱码（使用智谱 GLM-5 时）

这是 GLM 的已知 bug，不是 Claude Code 的问题。

> 我在 OpenCode 中也经常遇到。仅在使用 GLM 模型时出现，在 GPT-Codex 和 Claude 模型中从未发生。有同学报告 Gemini 也有此问题。可能是稀疏注意力的问题——Claude 和 GPT 是稠密注意力，而 GLM/DeepSeek/Gemini 是稀疏注意力。

所以 GLM 宣传 200k 上下文（为了匹敌 Anthropic 竞争对手），但实际上只能处理约 128k 上下文 :)

超过约 128k 上下文时，GLM 有很高概率陷入混乱的乱码响应。

为避免此问题，将自动压缩提前到 `50%` 触发：

```bash
export CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50
```

这样将上下文上限限制为 100k。

然而，这只能降低乱码的"概率"，GLM 仍有可能在约 30% 上下文时出现乱码，确实令人烦恼。

切换到更贵的模型提供商（官方 Claude 最佳）可彻底消除此问题。

目前 GLM-5.1 相比 GLM-5 的乱码概率也更低。

### Claude Code 闪烁
问题：使用 Claude Code 时终端持续闪烁。
解决：编辑 `~/.claude/settings.json`，添加：
```diff
{
  "env": {
    ...,
    "CLAUDE_CODE_NO_FLICKER": "1"
  },
  ...
}
```

> 或者，可以在 `.bashrc` 中添加环境变量 `export CLAUDE_CODE_NO_FLICKER=1`。

参见 [`settings.example.json`](settings.example.json) 示例。

### 状态栏错误
问题：在主目录启动 `claude` 时显示警告 `statusline skipped - restart to fix`
解决：编辑 `~/.claude.json`，找到 `"/home/bate"`（其中 bate 是你的用户名），修改：
```diff
-"hasTrustDialogAccepted": false,
+"hasTrustDialogAccepted": true,
```

### 设置损坏？
如果设置不生效，可以复制我的示例设置：
```bash
cp ~/.claude/settings.json ~/.claude/settings.json.bak
cp settings.example.json ~/.claude/settings.json
nvim ~/.claude/settings.json  # 根据自己的需求编辑
```

## 杂项

### 工具推荐

#### AI 编程代理

终端中的：
- Claude Code（本仓库面向的工具）
- OpenCode
- Crush
- Codex
- Gemini CLI
- Kimi CLI
- Qwen Coder
- Pi Agent

图形化 IDE：
- Cursor
- Kiro Code
- Cline
- Trae
- Windsurf
- Warp
- Qoder

垃圾：
- OpenFlaw

#### AI 模型

以下是我使用过的模型，个人主观排名。未使用过的模型未列出。

顶级：
- Claude Opus 4.6

第一梯队：
- DeepSeek V3.2
- GLM-5.1
- Claude Sonnet 4.6
- GPT-5.2-Codex

第二梯队：
- Claude Haiku 4.5
- GLM-5
- GLM-5-Turbo

第三梯队：
- GLM-4.7
- GPT-5.3-Codex

以下是我的朋友和同事评价汇总的主观排名：

第零梯队：
- Gemini 3.1 Preview
- Claude Opus 4.6

第一梯队：
- GPT-5.4

第二梯队：
- Kimi K2.5
- Composer 2（Cursor 中的）
- GLM-5
- Claude Sonnet 4.6

第三梯队：
- GLM-4.7
- GPT-5.3-Codex

第四梯队：
- Minimax M2.5
- Qwen Coder xxx 随便什么

#### 现代终端

使用现代终端以避免 Claude Code 卡顿。

- Ghostty（Claude Code 官方团队推荐）
- Kitty（我的最爱）
- Smux、Cmux、Warp、WezTerm、Alacritty...

以上终端都具有内置的多路复用功能，这对代理开发者很重要。

对于没有或内置多路复用功能较弱的终端，使用终端多路复用工具。

- Tmux（我的最爱）
- Zellij（号称直观但我讨厌：太多快捷键绑定，与 NeoVim 和 Claude Code 冲突）
- OpenMux（基于 OpenTUI，与 OpenCode 相同的技术）

我的选择理由：
- Tmux 额外提供了多路复用的持久性，对 SSH（远程服务器）用户至关重要
- Kitty 美观（以我的审美）且快速，键盘优先设计，完美融入我的 i3wm 环境

#### Shell

将默认 shell 设置为 `bash` 以外的都可以，因为 Claude Code 总是使用 `bash -c '<command>'` 来执行其 `Bash` 工具，没有兼容性问题。

> 因此，请确保你的 bash 在 `~/.bashrc` 中有合理的配置，否则可能会减慢 Claude Code 中 `Bash` 工具的执行速度。

另一方面，OpenCode 存在一个问题，会调用 `$SHELL` 而非 `bash -ic` 来执行其"Bash"工具，这可能会让 LLM 代理困惑。如果你使用 fish，请确保设置 `SHELL=/bin/bash opencode` 以防止兼容性问题。

如果你使用 Claude Code，可以放心地将默认 shell 设置为 `zsh` 或 `fish`。所以我把默认 shell 设置为了我最喜欢的 `fish`。

#### 编辑器

我使用 NeoVim。配合 Claude Code，NeoVim 不负责编写代码，而是负责编写 Markdown 文件和提示词。

我将 `$EDITOR` 设置为 `nvim`，这样在按 `C-g`（在 NeoVim 中编辑长提示词）时 Claude Code 会启动 NeoVim。

#### 文件管理器

终端文件管理器比手动在 shell 中使用 `mv` 和 `cp` 更好用。

`yazi` 是个不错的选择，但我个人更喜欢使用 NeoVim 的 `oil.nvim` 插件，对 Vim 用户来说超级直观——看看他们的演示视频你就明白了。

#### 现代 CLI 工具

这些 CLI 工具在大多数 LLM 模型的知识截止时间之后出现，且非常适合代理使用：

- `rg` 而非 `grep`
- `fd` 而非 `find`
- `exa` 而非 `ls`
- `sd` 而非 `sed`
- `just` 而非 `make`
- `uv` 而非 `pip`
- `uv run` 而非 `python3`
- `pnpm` 而非 `npm`
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

我已在 [`CLAUDE.md`](CLAUDE.md) 中记录了这些工具。

### 其他配置

查看我的其他配置：

- Dotfiles（Kitty 和 i3wm） - [archibate/dotfiles](https://github.com/archibate/dotfiles)
- Tmux - [archibate/dotfiles-tmux](https://github.com/archibate/dotfiles-tmux)
- NeoVim - [archibate/dotfiles-nvim](https://github.com/archibate/dotfiles-nvim)
- Fish Shell - [archibate/dotfiles-fish](https://github.com/archibate/dotfiles-fish)
- OpenCode - [archibate/dotfiles-opencode](https://github.com/archibate/dotfiles-opencode)
