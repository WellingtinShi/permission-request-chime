# Changelog

## 0.2.2 - 2026-06-09

- Adds explicit `hooks` entries to both plugin manifests so Codex reliably
  registers each `PermissionRequest` hook after installation.
- Shortens the Windows chime to a single audible notification instead of a
  multi-step fallback sequence.
- Uses an encoded PowerShell command for the Windows hook to avoid nested
  quoting issues with `$env:*` variables on Windows shells.
- Adds a readable Windows `scripts/play-chime.ps1` copy of the hook logic for
  review and maintenance.

## 0.1.0 - 2026-06-09

- Initial public marketplace release.
- Adds a `PermissionRequest` lifecycle hook that plays a local chime.
- Uses `/System/Library/Sounds/Glass.aiff` by default on macOS.
- Falls back to `osascript` beep and then terminal bell.
- Adds a bundled skill with setup and troubleshooting guidance.
