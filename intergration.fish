function claude
    set -l CLAUDE_TOOLS_DIR (path dirname (status --filename))
    set -lx AGENT_BROWSER_SESSION (basename $PWD)-(command -sq openssl; and openssl rand -hex 8; or random)
    $CLAUDE_TOOLS_DIR/claude-router.py $argv
end

if not command -sq commit
    function commit
        timeout -v -s INT 80s claude -p --model haiku --max-turns 50 "Make a git commit with commit message briefly describing what changed in the codebase. Stage and commit all changed files (including untracked ones). If some stagable files looks like should appear in .gitignore, add the file name pattern to .gitignore before stage. Do not edit files in this conversation."
    end
end
