To define hooks local to a skill, in `SKILL.md` frontmatter:

```markdown
---
name: secure-operations
description: Perform operations with security checks
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./hooks/security-check.sh"
---
```
