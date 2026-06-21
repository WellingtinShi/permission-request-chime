#!/bin/sh
set -u

# Optional macOS companion watcher for Codex in-app Browser site prompts.
# It watches the Codex UI for "Allow Codex to access ..." dialogs and plays the
# same local chime used by the PermissionRequest hook. This is intentionally
# separate from hooks/hooks.json because Browser site prompts are app UI prompts,
# not Codex PermissionRequest lifecycle events.

SOUND="${CODEX_PERMISSION_CHIME_SOUND:-/System/Library/Sounds/Glass.aiff}"
INTERVAL="${CODEX_BROWSER_PERMISSION_CHIME_INTERVAL:-2}"
LAST_PROMPT=""

play_chime() {
  if [ -r "$SOUND" ] && command -v afplay >/dev/null 2>&1; then
    (afplay "$SOUND" >/dev/null 2>&1 &)
  elif command -v osascript >/dev/null 2>&1; then
    (osascript -e "beep 1" >/dev/null 2>&1 &)
  else
    printf "\a" >/dev/tty 2>/dev/null || true
  fi
}

detect_prompt() {
  /usr/bin/osascript <<'APPLESCRIPT'
on isBrowserSitePrompt(t)
  if t contains "Allow Codex to access" then return true
  if t contains "允许 Codex 访问" then return true
  return false
end isBrowserSitePrompt

tell application "System Events"
  if not (exists process "Codex") then return ""
  tell process "Codex"
    repeat with w in windows
      try
        set itemsToCheck to entire contents of w
        repeat with itemToCheck in itemsToCheck
          try
            set candidate to value of itemToCheck as text
            if my isBrowserSitePrompt(candidate) then return candidate
          end try
          try
            set candidate to name of itemToCheck as text
            if my isBrowserSitePrompt(candidate) then return candidate
          end try
          try
            set candidate to description of itemToCheck as text
            if my isBrowserSitePrompt(candidate) then return candidate
          end try
        end repeat
      end try
    end repeat
  end tell
end tell

return ""
APPLESCRIPT
}

while true; do
  PROMPT_TEXT="$(detect_prompt 2>/dev/null || true)"

  if [ -n "$PROMPT_TEXT" ]; then
    PROMPT_KEY="$(printf "%s" "$PROMPT_TEXT" | /usr/bin/cksum | awk '{print $1 ":" $2}')"
    if [ "$PROMPT_KEY" != "$LAST_PROMPT" ]; then
      play_chime
      LAST_PROMPT="$PROMPT_KEY"
    fi
  else
    LAST_PROMPT=""
  fi

  sleep "$INTERVAL"
done
