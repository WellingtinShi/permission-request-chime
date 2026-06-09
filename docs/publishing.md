# Publishing

This repository is structured as a Codex plugin marketplace. The marketplace
file is `.agents/plugins/marketplace.json`, and it exposes two plugin bundles:

- `plugins/permission-request-chime/` for macOS.
- `plugins/permission-request-chime-windows/` for Windows.

## Public GitHub Repository

Repository:

```text
WellingtinShi/permission-request-chime
```

## Release Flow

`v0.1.0` was the original macOS-only release. `v0.2.0` introduced the macOS /
Windows split. `v0.2.1` improves the Windows hook by using real `.wav` files
before falling back to system sounds.

To publish a new stable release:

```bash
git push origin main
git tag v0.2.1
git push origin v0.2.1
```

If the tag already exists locally or remotely, inspect it before changing it.
Do not move published tags casually.

## Install Verification

After the public repository is updated, verify a fresh install:

```text
codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.2.1
```

Then install the matching plugin from the Codex plugin directory:

- macOS: `permission-request-chime`
- Windows: `permission-request-chime-windows`

Restart Codex, review and trust the hook, and trigger a harmless permission
request.

## Release Checklist

- Validate JSON files with `jq`.
- Validate the macOS hook shell command with `sh -n`.
- Review the Windows PowerShell hook command manually or test on Windows.
- Run the plugin validator for both plugin directories.
- Confirm the public repository contains `.agents/plugins/marketplace.json`.
- Confirm both plugin entries appear in the marketplace.
- Confirm the release tag points at the intended commit.
- Test installation from the pinned tag.
