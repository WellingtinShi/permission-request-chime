# Permission Request Chime (Windows)

[Repository README](../../README.md) | [中文说明](../../README.zh-CN.md)

This is the Windows version of Permission Request Chime. It plays a local
Windows sound whenever Codex creates a permission request.

macOS users should install `permission-request-chime` instead.

## Design

The plugin uses Codex's `PermissionRequest` lifecycle hook instead of watching
the screen. The hook matches every permission request and launches a small
`powershell.exe` command.

The default command tries to play `CODEX_PERMISSION_CHIME_SOUND` when it points
to a readable `.wav` file. If no custom sound is configured, it plays the
Windows `SystemSounds.Asterisk` sound. If that fails, it falls back to
`[Console]::Beep(880,250)`.

## Install

Add the marketplace:

```bash
codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.2.0
```

Then open the Codex plugin directory and install:

```text
permission-request-chime-windows
```

Restart Codex after installation. Because the plugin bundles a command hook,
Codex will ask you to review and trust the hook before it runs.

## Customize

Set `CODEX_PERMISSION_CHIME_SOUND` before starting Codex:

```powershell
$env:CODEX_PERMISSION_CHIME_SOUND = "C:\Windows\Media\Windows Notify System Generic.wav"
```

On Windows, custom sounds should be `.wav` files readable by PowerShell.

## Security

The default hook command only attempts to play a local `.wav` file, a Windows
system sound, or a beep. Codex requires explicit trust before non-managed
command hooks can run.

Review `hooks/hooks.json` before trusting it.

## Limitations

- Windows only.
- Requires `powershell.exe`.
- Requires local Codex sessions that load lifecycle hooks.
- Depends on hooks being enabled in Codex configuration.
- System mute, focus assist, or an unavailable audio device can still prevent
  audible playback.
