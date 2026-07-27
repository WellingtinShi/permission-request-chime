---
name: permission-request-chime-windows
description: Explain and tune the Windows Permission Request Chime plugin for Codex permission approval sounds.
---

# Permission Request Chime (Windows)

This plugin is automatic once installed and enabled. It uses Codex's
`PermissionRequest` lifecycle hook to play a local Windows sound when Codex
routes an approval request to the user. Automatically reviewed requests stay
silent.

## How it works

- The hook lives at `hooks/hooks.json`.
- The matcher is `*`, so it covers Bash, apply_patch/Edit/Write, MCP tools, and
  other permission-requesting tools that Codex exposes through the hook event.
- The encoded command mirrors `scripts/play-chime.ps1`, reads the current turn's
  reviewer metadata, and exits silently when `approvals_reviewer` is
  `auto_review`.
- On Windows it launches `powershell.exe`.
- If `CODEX_PERMISSION_CHIME_SOUND` points to a readable `.wav` file, the hook
  plays that file with `System.Media.SoundPlayer`.
- Otherwise it tries common Windows `.wav` files from `C:\Windows\Media`.
- If that fails, it plays `SystemSounds.Exclamation`.
- If that fails, it falls back to `[Console]::Beep(...)`.

## Tune the sound

Set `CODEX_PERMISSION_CHIME_SOUND` before starting Codex. On Windows this should
point to a readable `.wav` file.

Example:

```powershell
$env:CODEX_PERMISSION_CHIME_SOUND = "C:\Windows\Media\Windows Notify System Generic.wav"
```

After changing the hook command, restart Codex and review/trust the updated hook.

## Notes

Non-managed command hooks must be reviewed and trusted before they run. If the
plugin is enabled but no sound plays, open the hook review UI and trust the
PermissionRequest hook.
