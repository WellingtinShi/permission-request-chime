#!/bin/sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
WATCHER="$SCRIPT_DIR/watch-codex-browser-site-prompt.sh"
INSTALL_DIR="$HOME/Library/Application Support/PermissionRequestChime"
INSTALLED_WATCHER="$INSTALL_DIR/watch-codex-browser-site-prompt.sh"
LABEL="com.wellingtinshi.permission-request-chime.browser-site-watcher"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
LOG_DIR="$HOME/Library/Logs"
UID_VALUE="$(id -u)"

if [ ! -f "$WATCHER" ]; then
  echo "Watcher script not found: $WATCHER" >&2
  exit 1
fi

mkdir -p "$HOME/Library/LaunchAgents" "$LOG_DIR" "$INSTALL_DIR"
cp "$WATCHER" "$INSTALLED_WATCHER"
chmod 700 "$INSTALLED_WATCHER"

cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/sh</string>
    <string>$INSTALLED_WATCHER</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardOutPath</key>
  <string>$LOG_DIR/permission-request-chime-browser-site-watcher.log</string>
  <key>StandardErrorPath</key>
  <string>$LOG_DIR/permission-request-chime-browser-site-watcher.err.log</string>
</dict>
</plist>
EOF

/bin/launchctl bootout "gui/$UID_VALUE" "$PLIST" >/dev/null 2>&1 || true
/bin/launchctl bootstrap "gui/$UID_VALUE" "$PLIST" 2>/dev/null || /bin/launchctl load "$PLIST"
/bin/launchctl kickstart -k "gui/$UID_VALUE/$LABEL" >/dev/null 2>&1 || true

cat <<EOF
Installed Browser site prompt watcher.

If it does not chime, grant Accessibility access to the process running the
watcher in System Settings > Privacy & Security > Accessibility, then run this
installer again or log out and back in.

LaunchAgent:
$PLIST

Watcher:
$INSTALLED_WATCHER
EOF
