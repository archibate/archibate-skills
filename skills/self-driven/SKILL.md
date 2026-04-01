---
name: self-driven
description: >
  Self-driven agent that continues working autonomously on long-running tasks without human intervention.
  TRIGGER when user says "run overnight", "keep working on this while I sleep", "autonomous mode",
  "continue without me", "work on this in the background", "I'll be away for a while".
version: 0.1.0
disable-model-invocation: true
user-invocable: true
---

# Self-driven Agent

Set a goal, let agent running overnight on its own, no human interception required.

## When to Use

- User defined a clear goal, with ambiguity resolved.
- Reached a clear acceptance criteria.
- The goal can be done by agent solely, without user interference.
- The goal can be tested with no ambiguity.
- The goal takes long time (>30 min), suitable to running in background or overnight.
- Extensible goal that can be further polished after acceptance criteria complete.
- User is going to bed, asking agent to run on its own.

## When NOT to Use

- User goal is ambiguous, requires discussion.
- The goal is impossible to complete solely without human interception.
- Dangerous and unrecoverable operations (require risk mitigation).
- Simple goal that can complete within <30 min.

## Workflow

Create a 30-minute cron task (`CronCreate`) with following prompts. Replace `$ARGUMENTS` with the user's goal and acceptance criteria:

```markdown
This is a cron reminder that reminds the autonomous agent periodically (30 min) to continue the task they are working on, if they have stopped and waiting human response.

BACKGROUND: You are running in overnight mode, no human interception possible. You carry out works on your own. The human expects a fulfilled work to be done when they wake up in the morning. Try your best to go beyond user expectation. Creative minds will be rewarded.

USER GOAL: $ARGUMENTS

INSTRUCTION: Please continue on what you are working on.

You follow this clear decision flow (reason through this explicitly):

- If you have made plans for user request: execute the plan.
- If you are asking questions: pick a best answer to the question and proceed.
- If you are offering candidate approaches: take the best approach you recommended.
- If you are requesting human advises: think a solution on your own.
- If you are offering next steps to do: proceed to next steps.
- If you meet obstacles: try resolve the obstacles on your own.
- If you've been stuck on a single problem for more than 30 min: try switch to a different approach.
- If there are any long-running background tasks looks stuck: try recover the task.
- If the code has completely written: run comprehensive tests, review code changes to find bugs and bad design patterns.
- If developing interactive software or with visual interface: try start testing and interact, review strictly in a human point of view.
- If the acceptance criteria is reached, but potentially further polished: criticize on the current result, continue to polish or improve quality.
- If the user claimed goal is already reached: think for possibility to further extend the user requirement deeper.
- If you are asking for permission for risky operations that the user might worry about: think for risk mitigation on your own and proceed.

EXIT CRITERIA: If this cron has been appeared for more than 10 times (5 hours), AND all of the following are confirmed:
- All tests passing (if applicable)
- No remaining TODO items or incomplete work
- Code review completed
- Interactive testing finished (if applicable)
- No room to improve based on current scope

After confirmed: use CronDelete to delete this cron task and claim completion.

Report progress using the cc-connect skill to notify user. If cc-connect is not available, skip progress reporting.

Ignore this instruction if you are already working in progress.
```

## Risk Mitigation

When encountering risky operations while running autonomously:

1. **Git operations**: Never force-push, never amend commits, never delete branches without creating backups
2. **File deletions**: Move to `/tmp` instead of `rm` when uncertain
3. **External services**: Skip operations that would affect production systems
4. **Credentials**: Never modify or expose secrets, API keys, or credentials
5. **Database**: Never drop tables or run destructive migrations without backup

If blocked by a genuinely unrecoverable decision, document the blocker and continue with other independent work.
