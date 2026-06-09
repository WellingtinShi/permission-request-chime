# Publishing

This repository is structured as a Codex plugin marketplace. The marketplace
file is `.agents/plugins/marketplace.json`, and the plugin bundle is under
`plugins/permission-request-chime/`.

## Public GitHub Repository

Create a public GitHub repository:

```text
WellingtinShi/permission-request-chime
```

Then push this local repository:

```bash
git remote add origin git@github.com:WellingtinShi/permission-request-chime.git
git push -u origin main
git push origin v0.1.0
```

If SSH is not configured, use the HTTPS remote instead:

```bash
git remote add origin https://github.com/WellingtinShi/permission-request-chime.git
```

## Install Verification

After the public repository exists, verify a fresh install:

```bash
codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.1.0
```

Then install `permission-request-chime` from the Codex plugin directory, restart
Codex, review and trust the hook, and trigger a harmless permission request.

## Release Checklist

- Validate JSON files with `jq`.
- Validate the hook shell command with `sh -n`.
- Run the plugin validator when its Python dependencies are available.
- Confirm the public repository contains `.agents/plugins/marketplace.json`.
- Confirm `v0.1.0` points at the intended release commit.
- Test installation from the pinned tag.
