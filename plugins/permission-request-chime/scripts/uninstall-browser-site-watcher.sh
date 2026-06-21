#!/bin/sh
set -eu

LABEL="com.wellingtinshi.permission-request-chime.browser-site-watcher"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
INSTALL_DIR="$HOME/Library/Application Support/PermissionRequestChime"
INSTALLED_WATCHER="$INSTALL_DIR/watch-codex-browser-site-prompt.sh"
UID_VALUE="$(id -u)"

/bin/launchctl bootout "gui/$UID_VALUE" "$PLIST" >/dev/null 2>&1 || true
/bin/launchctl remove "$LABEL" >/dev/null 2>&1 || true
rm -f "$PLIST"
rm -f "$INSTALLED_WATCHER"
rmdir "$INSTALL_DIR" >/dev/null 2>&1 || true

echo "Removed Browser site prompt watcher."
