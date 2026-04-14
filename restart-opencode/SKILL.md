---
name: restart-opencode
description: |-
  Restart the opencode process running inside a Docker container by killing it with SIGKILL.
  Use when opencode becomes unresponsive, needs a fresh state, or container requires restart.

  Examples:
  - user: "Restart opencode" → ask for approval, then execute kill -9 $(pgrep opencode)
  - user: "Kill and restart opencode" → confirm before killing opencode process
  - user: "Fresh opencode session" → ask confirmation, then restart opencode process
---

# Restart Opencode

Restart opencode by killing its process. The Docker container will automatically restart the servic
e.

## When to Use

- Opencode becomes unresponsive or freezes
- Need to reset opencode's state completely
- Container requires restart for any reason
- Fresh session needed after major changes

## IMPORTANT: Mandatory Confirmation

**ALWAYS ask for user's explicit approval BEFORE executing the restart command.**

Do NOT execute automatically. Execute the restart script:

```bash
~/.config/opencode/skills/restart-opencode/restart-opencode.sh
```

### Confirmation Process

1. Present the command to the user
2. Wait for explicit approval (e.g., "yes", "go ahead", "do it")
3. Only execute after approval is received
4. If user declines or asks for alternative, do NOT execute

## Quick Reference

| Action | Command |
|--------|---------|
| Kill opencode process | `~/.config/opencode/skills/restart-opencode/restart-opencode.sh` |

## Common Mistakes

- **Executing without confirmation** — Always ask first
- **Using wrong signal** — Must use `-9` (SIGKILL) for guaranteed restart
- **Using other kill variants** — `pkill` may not work reliably in container

## Notes

This works because:
1. Opencode is running inside a Docker container
2. When the main process is killed, the container exits
3. Docker automatically restarts the container based on its restart policy
4. A new opencode session begins automatically
