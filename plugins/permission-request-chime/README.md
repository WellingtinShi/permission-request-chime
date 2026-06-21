# Permission Request Chime (macOS)

[Repository README](../../README.md) | [中文说明](../../README.zh-CN.md)

This is the macOS version of Permission Request Chime. It plays a local macOS
sound whenever Codex creates a permission request.

Windows users should install `permission-request-chime-windows` instead.

## Design

The plugin uses Codex's `PermissionRequest` lifecycle hook instead of watching
the screen. The hook matches every permission request and launches a small
`/bin/sh` command.

The default command plays `/System/Library/Sounds/Glass.aiff` with `afplay`.
If `afplay` is unavailable, it falls back to `osascript -e "beep 1"`, then to a
terminal bell.

## Browser Site Prompts

Codex in-app Browser site access prompts, such as:

```text
Allow Codex to access https://example.com?
```

are Codex app UI prompts, not `PermissionRequest` lifecycle events. The normal
hook cannot see them.

For those prompts, this plugin includes an optional macOS watcher that reads
the Codex window through macOS Accessibility and plays the same local chime
when it sees an `Allow Codex to access ...` dialog.

Install the optional watcher:

```bash
scripts/install-browser-site-watcher.sh
```

Uninstall it:

```bash
scripts/uninstall-browser-site-watcher.sh
```

If the watcher does not chime, grant Accessibility access in System Settings >
Privacy & Security > Accessibility, then run the installer again or log out and
back in.

## Install

Add the marketplace:

```text
codex plugin marketplace add WellingtinShi/permission-request-chime --ref stable
```

Then open the Codex plugin directory and install:

```text
permission-request-chime
```

Restart Codex after installation. Because the plugin bundles a command hook,
Codex will ask you to review and trust the hook before it runs.

## Customize

Set `CODEX_PERMISSION_CHIME_SOUND` before starting Codex:

```bash
export CODEX_PERMISSION_CHIME_SOUND=/System/Library/Sounds/Ping.aiff
```

Useful macOS built-in options:

- `/System/Library/Sounds/Glass.aiff`
- `/System/Library/Sounds/Ping.aiff`
- `/System/Library/Sounds/Pop.aiff`
- `/System/Library/Sounds/Submarine.aiff`

## Security

The default hook command only attempts to play a local sound file, run a system
beep, or emit a terminal bell. Codex requires explicit trust before non-managed
command hooks can run.

Review `hooks/hooks.json` before trusting it.

## Limitations

- macOS only.
- Requires local Codex sessions that load lifecycle hooks.
- Depends on hooks being enabled in Codex configuration.
- Browser site access prompts require the optional Accessibility-based watcher.
- System mute, focus mode, or an unavailable audio device can still prevent
  audible playback.
