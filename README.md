# Permission Request Chime

[English](README.md) | [简体中文](README.zh-CN.md)

Permission Request Chime is a Codex plugin marketplace with two OS-specific
plugins. Each plugin plays a short local sound when Codex creates a permission
request, so approval prompts are harder to miss when you are working in another
window.

The plugins use Codex's `PermissionRequest` lifecycle hook. They do not watch
your screen, inspect window titles, or use OCR.

## Versions

Install only the version that matches your OS:

| OS | Plugin to install | Sound command |
| --- | --- | --- |
| macOS | `permission-request-chime` | `/bin/sh` + `afplay` |
| Windows | `permission-request-chime-windows` | `powershell.exe` + Windows system sound |

`v0.1.0` was macOS-only. Use `v0.2.0` or newer for the macOS / Windows split.

## Install

### 1. Add The Marketplace

Run this pinned stable install command:

```text
codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.2.0
```

For development or latest changes, omit the `--ref` flag:

```text
codex plugin marketplace add WellingtinShi/permission-request-chime
```

Do not run both commands. The first one pins the marketplace to a stable release
tag. The second one tracks the repository's default branch.

### 2. Install The Right Plugin

The marketplace command only adds this repository as a plugin source. After it
finishes, open the Codex plugin directory and install one plugin:

- macOS: install `permission-request-chime`.
- Windows: install `permission-request-chime-windows`.

Do not install both versions on the same machine unless you intentionally want
two hooks to run.

### 3. Restart And Trust

Restart Codex after installation. Because these plugins include command hooks,
Codex will ask you to review and trust the hook before it runs.

## Ask Codex To Install

You can paste one of these prompts into a local Codex conversation.

macOS:

```text
Please add the Permission Request Chime marketplace by running:

codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.2.0

Then remind me to install permission-request-chime from the Codex plugin directory.
```

Windows:

```text
Please add the Permission Request Chime marketplace by running:

codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.2.0

Then remind me to install permission-request-chime-windows from the Codex plugin directory.
```

Codex may ask for permission before running the command. Approve the request if
you want Codex to add this plugin marketplace.

## What The Plugins Do

Both plugins:

- Match all Codex `PermissionRequest` events with `matcher: "*"`.
- Play a local sound as soon as Codex creates an approval request.
- Require hook review/trust before first run.

macOS version:

- Plays `/System/Library/Sounds/Glass.aiff` with `afplay`.
- Falls back to `osascript -e "beep 1"`.
- Falls back to a terminal bell if neither player is available.

Windows version:

- Runs `powershell.exe`.
- Plays `CODEX_PERMISSION_CHIME_SOUND` when it points to a readable `.wav` file.
- Otherwise plays the Windows `SystemSounds.Asterisk` sound.
- Falls back to `[Console]::Beep(880,250)`.

## Customize The Sound

macOS:

```bash
export CODEX_PERMISSION_CHIME_SOUND=/System/Library/Sounds/Ping.aiff
```

Useful macOS built-in options include:

- `/System/Library/Sounds/Glass.aiff`
- `/System/Library/Sounds/Ping.aiff`
- `/System/Library/Sounds/Pop.aiff`
- `/System/Library/Sounds/Submarine.aiff`

Windows:

```powershell
$env:CODEX_PERMISSION_CHIME_SOUND = "C:\Windows\Media\Windows Notify System Generic.wav"
```

On Windows, custom sounds should be `.wav` files readable by PowerShell.

Changing the hook command itself requires restarting Codex and trusting the
updated hook.

## Test

Use a harmless escalated command to trigger a permission request.

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
2. The installed plugin's hook plays the chime.
3. After approval, the harmless command prints the current date and time.

See `docs/testing.md` for troubleshooting notes.

## Security

These plugins bundle non-managed command hooks. Codex records trust against the
exact hook definition, so changed hooks must be reviewed and trusted again.

The default commands only attempt to play a local sound file, run a system
sound/beep, or emit a terminal bell. Review the hook before trusting it:

- macOS: `plugins/permission-request-chime/hooks/hooks.json`
- Windows: `plugins/permission-request-chime-windows/hooks/hooks.json`

## Repository Layout

```text
.
├── .agents/plugins/marketplace.json
├── README.zh-CN.md
├── docs/
│   ├── publishing.md
│   └── testing.md
└── plugins/
    ├── permission-request-chime/
    │   ├── .codex-plugin/plugin.json
    │   ├── README.md
    │   ├── hooks/hooks.json
    │   └── skills/permission-request-chime/SKILL.md
    └── permission-request-chime-windows/
        ├── .codex-plugin/plugin.json
        ├── README.md
        ├── hooks/hooks.json
        └── skills/permission-request-chime-windows/SKILL.md
```

## License

MIT
