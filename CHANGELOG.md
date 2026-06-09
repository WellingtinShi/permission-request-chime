# Changelog

## 0.1.0 - 2026-06-09

- Initial public marketplace release.
- Adds a `PermissionRequest` lifecycle hook that plays a local chime.
- Uses `/System/Library/Sounds/Glass.aiff` by default on macOS.
- Falls back to `osascript` beep and then terminal bell.
- Adds a bundled skill with setup and troubleshooting guidance.
