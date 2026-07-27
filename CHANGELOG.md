# Changelog

## 0.2.4 - 2026-07-26

- Keeps requests handled by Codex automatic approval review silent.
- Reads the current turn's `approvals_reviewer` metadata before playback so the
  chime is reserved for requests routed to the user.
- Adds a readable macOS `scripts/play-chime.sh` implementation.
- Updates the encoded Windows command to mirror the reviewer-aware readable
  PowerShell script.
- Preserves the original chime behavior when older Codex versions do not expose
  reviewer metadata.

`0.2.3` was a withdrawn experiment and is intentionally skipped.

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
