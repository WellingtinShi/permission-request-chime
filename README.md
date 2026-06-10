# Permission Request Chime

[English](README.md) | [简体中文](README.zh-CN.md)

Permission Request Chime plays a short local sound when Codex creates a
permission request, so Codex is less likely to sit quietly while you are working
in another window.

It uses Codex's `PermissionRequest` lifecycle hook. It does not watch your
screen, inspect window titles, or use OCR.

## Quick Install

Add the marketplace:

```text
codex plugin marketplace add WellingtinShi/permission-request-chime --ref stable
```

Then open the Codex plugin directory and install one plugin:

| OS | Install this plugin |
| --- | --- |
| macOS | `permission-request-chime` |
| Windows | `permission-request-chime-windows` |

Restart Codex after installation. Codex will ask you to review and trust the
hook before it runs.

Do not install both plugins on the same machine unless you intentionally want
two hooks to run.

## Ask Codex To Install

You can also paste this into a local Codex conversation:

```text
Please add the Permission Request Chime marketplace by running:

codex plugin marketplace add WellingtinShi/permission-request-chime --ref stable

Then remind me to open the Codex plugin directory and install the plugin for my OS:
macOS: permission-request-chime
Windows: permission-request-chime-windows
```

## Upgrade

If you installed with `--ref stable`, update the marketplace without
uninstalling the plugin:

```text
codex plugin marketplace upgrade permission-request-chime
```

Restart Codex after upgrading. If Codex asks you to review and trust the updated
hook, trust it before testing the chime.

If you previously pinned an old tag such as `v0.2.1`, switch to `stable` once:

```text
codex plugin marketplace remove permission-request-chime
codex plugin marketplace add WellingtinShi/permission-request-chime --ref stable
```

For a reproducible install instead of automatic stable upgrades, pin the latest
release tag:

```text
codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.2.2
```

## What It Does

Both plugins match all Codex `PermissionRequest` events with `matcher: "*"`.

macOS:

- Plays `/System/Library/Sounds/Glass.aiff` with `afplay`.
- Falls back to `osascript -e "beep 1"`.
- Falls back to a terminal bell.

Windows:

- Runs an encoded `powershell.exe` command to avoid quoting issues.
- Plays `CODEX_PERMISSION_CHIME_SOUND` if it points to a readable `.wav` file.
- Otherwise plays a short `.wav` file from `C:\Windows\Media`.
- Falls back to `SystemSounds.Exclamation`, then `[Console]::Beep(...)`.

## Customize The Sound

macOS:

```bash
export CODEX_PERMISSION_CHIME_SOUND=/System/Library/Sounds/Ping.aiff
```

Windows:

```powershell
$env:CODEX_PERMISSION_CHIME_SOUND = "C:\Windows\Media\Windows Notify System Generic.wav"
```

After changing the hook command itself, restart Codex and trust the updated
hook again.

## Test

Use a harmless permission request.

macOS:

```bash
/bin/date
```

Windows:

```powershell
powershell.exe -NoProfile -Command Get-Date
```

Expected behavior:

1. Codex creates a permission request.
2. The installed plugin plays the chime.
3. After approval, the command prints the current date and time.

## Security

These plugins bundle non-managed command hooks, so Codex requires explicit
trust before they run. Review the hook before trusting it:

- macOS: `plugins/permission-request-chime/hooks/hooks.json`
- Windows: `plugins/permission-request-chime-windows/hooks/hooks.json`

The readable Windows PowerShell source is also kept at
`plugins/permission-request-chime-windows/scripts/play-chime.ps1`.

## Troubleshooting

If there is no sound, check:

- The plugin for your OS is installed and enabled.
- Codex has been restarted after installation or upgrade.
- The hook has been reviewed and trusted.
- Your system is not muted and the output device works.
- Windows focus assist or audio mixer settings are not blocking the sound.

See `docs/testing.md` for more checks.

## License

MIT
