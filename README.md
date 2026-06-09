# Permission Request Chime

Permission Request Chime is a Codex plugin that plays a short local sound when
Codex creates a permission request. It is useful when approval popups are easy
to miss while you are working in another window.

The plugin uses Codex's `PermissionRequest` lifecycle hook. It does not watch
your screen, inspect window titles, or use OCR.

## Install

Add this repository as a Codex plugin marketplace:

```bash
codex plugin marketplace add WellingtinShi/permission-request-chime
```

For a pinned stable install, use a release tag:

```bash
codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.1.0
```

Then open the Codex plugin directory, choose the Permission Request Chime
marketplace, and install `permission-request-chime`.

After installation, restart Codex. Because this plugin includes a command hook,
Codex will ask you to review and trust the hook before it runs.

## What It Does

- Matches all Codex `PermissionRequest` events with `matcher: "*"`
- Plays `/System/Library/Sounds/Glass.aiff` on macOS with `afplay`
- Falls back to `osascript -e "beep 1"` if `afplay` is unavailable
- Falls back to a terminal bell if neither player is available

The hook definition lives in
`plugins/permission-request-chime/hooks/hooks.json`.

## Customize The Sound

Set `CODEX_PERMISSION_CHIME_SOUND` before starting Codex:

```bash
export CODEX_PERMISSION_CHIME_SOUND=/System/Library/Sounds/Ping.aiff
```

Useful macOS built-in options include:

- `/System/Library/Sounds/Glass.aiff`
- `/System/Library/Sounds/Ping.aiff`
- `/System/Library/Sounds/Pop.aiff`
- `/System/Library/Sounds/Submarine.aiff`

Changing the hook command itself requires restarting Codex and trusting the
updated hook.

## Test

Use a harmless escalated command, such as `/bin/date`, to trigger a permission
request. The expected behavior is:

1. Codex creates a permission request.
2. The plugin's hook plays the chime.
3. After approval, `/bin/date` prints the current date and time.

See `docs/testing.md` for troubleshooting notes.

## Security

This plugin bundles a non-managed command hook. Codex records trust against the
exact hook definition, so changed hooks must be reviewed and trusted again.

The default command only attempts to play a local sound file or beep. Review
`plugins/permission-request-chime/hooks/hooks.json` before trusting it.

## Repository Layout

```text
.
├── .agents/plugins/marketplace.json
├── docs/
│   ├── conversation-summary.md
│   └── testing.md
└── plugins/
    └── permission-request-chime/
        ├── .codex-plugin/plugin.json
        ├── README.md
        ├── hooks/hooks.json
        └── skills/permission-request-chime/SKILL.md
```

## License

MIT
