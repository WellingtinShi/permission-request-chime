---
name: permission-request-chime
description: Explain and tune the local Permission Request Chime plugin for Codex permission approval sounds.
---

# Permission Request Chime

This plugin is automatic once installed and enabled. It uses Codex's
`PermissionRequest` lifecycle hook to play a local sound whenever Codex creates
an approval request.

## How it works

- The hook lives at `hooks/hooks.json`.
- The matcher is `*`, so it covers Bash, apply_patch/Edit/Write, MCP tools, and
  other permission-requesting tools that Codex exposes through the hook event.
- On macOS it plays `/System/Library/Sounds/Glass.aiff` with `afplay`.
- If `afplay` is unavailable, it falls back to `osascript -e "beep 1"`.
- If neither is available, it tries a terminal bell.

## Tune the sound

Set `CODEX_PERMISSION_CHIME_SOUND` before starting Codex, or edit
`hooks/hooks.json` and replace the default sound path.

Common macOS sound paths include:

- `/System/Library/Sounds/Glass.aiff`
- `/System/Library/Sounds/Ping.aiff`
- `/System/Library/Sounds/Pop.aiff`
- `/System/Library/Sounds/Submarine.aiff`

After changing the hook command, restart Codex and review/trust the updated hook.

## Notes

Non-managed command hooks must be reviewed and trusted before they run. If the
plugin is enabled but no sound plays, open the hook review UI and trust the
PermissionRequest hook.
