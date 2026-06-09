# Permission Request Chime

Permission Request Chime is a Codex plugin that plays a short local sound
whenever Codex creates a permission request.

## Design

The plugin uses Codex's `PermissionRequest` lifecycle hook instead of watching
the screen. The hook matches every permission request and launches a tiny shell
command that plays `/System/Library/Sounds/Glass.aiff` in the background.

This means the plugin reacts to Codex's own approval event, not to fragile UI
details such as window titles or screen OCR.

## Install

Choose one of these install methods.

### Option 1: Run In Terminal

For most users, run this pinned stable install command in Terminal:

```bash
codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.1.0
```

For development or latest changes, omit the `--ref` flag:

```bash
codex plugin marketplace add WellingtinShi/permission-request-chime
```

Do not run both commands. The first one pins the marketplace to a stable release
tag. The second one tracks the repository's default branch.

### Option 2: Ask Codex To Run It

You can also paste this into a local Codex conversation and let Codex run the
command for you:

```text
Please install the Permission Request Chime plugin marketplace by running:

codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.1.0
```

Codex may ask for permission before running the command. Approve the request if
you want Codex to add this plugin marketplace.

### Finish Installation

The marketplace command only adds this repository as a plugin source. After it
finishes, install `permission-request-chime` from the Codex plugin directory and
restart Codex. Because the plugin bundles a command hook, Codex will ask you to
review and trust the hook before it runs.

## Customize

By default the hook plays:

`/System/Library/Sounds/Glass.aiff`

To use another sound, edit `hooks/hooks.json` and change the path, or start
Codex with `CODEX_PERMISSION_CHIME_SOUND` set to another readable audio file.

Useful macOS built-in options:

- `/System/Library/Sounds/Glass.aiff`
- `/System/Library/Sounds/Ping.aiff`
- `/System/Library/Sounds/Pop.aiff`
- `/System/Library/Sounds/Submarine.aiff`

## Security

The default hook command only attempts to play a local sound file, run a system
beep, or emit a terminal bell. Codex requires explicit trust before
non-managed command hooks can run.

## Limitations

- This targets local Codex sessions that load lifecycle hooks.
- It depends on hooks being enabled in Codex configuration.
- The default sound path is macOS-specific.
- System mute, focus mode, or an unavailable audio device can still prevent
  audible playback.
- The first run requires hook trust, which is intentional for local command
  safety.
