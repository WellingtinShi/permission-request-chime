#!/bin/sh

hook_input=$(/bin/cat)
reviewer=""

# PermissionRequest runs before Codex chooses automatic review or user review.
# Read the current turn context so automatic reviews stay silent.
if [ -x /usr/bin/plutil ]; then
  transcript_path=$(printf '%s' "$hook_input" |
    /usr/bin/plutil -extract transcript_path raw -o - - 2>/dev/null) ||
    transcript_path=""
  turn_id=$(printf '%s' "$hook_input" |
    /usr/bin/plutil -extract turn_id raw -o - - 2>/dev/null) ||
    turn_id=""

  if [ -n "$transcript_path" ] && [ -r "$transcript_path" ]; then
    if [ -n "$turn_id" ]; then
      turn_context=$(
        /usr/bin/grep -F '"type":"turn_context"' "$transcript_path" 2>/dev/null |
          /usr/bin/grep -F "\"turn_id\":\"$turn_id\"" 2>/dev/null |
          /usr/bin/tail -n 1
      )
    else
      turn_context=$(
        /usr/bin/grep -F '"type":"turn_context"' "$transcript_path" 2>/dev/null |
          /usr/bin/tail -n 1
      )
    fi

    if [ -n "$turn_context" ]; then
      reviewer=$(printf '%s' "$turn_context" |
        /usr/bin/plutil -extract payload.approvals_reviewer raw -o - - 2>/dev/null) ||
        reviewer=""
    fi
  fi
fi

case "$reviewer" in
auto_review | guardian_subagent)
  exit 0
  ;;
esac

if [ "${CODEX_PERMISSION_CHIME_DRY_RUN:-}" = "1" ]; then
  printf '%s\n' "chime"
  exit 0
fi

sound="${CODEX_PERMISSION_CHIME_SOUND:-/System/Library/Sounds/Glass.aiff}"
if [ -r "$sound" ] && command -v afplay >/dev/null 2>&1; then
  (afplay "$sound" >/dev/null 2>&1 &)
elif command -v osascript >/dev/null 2>&1; then
  (osascript -e "beep 1" >/dev/null 2>&1 &)
else
  printf "\a" >/dev/tty 2>/dev/null || true
fi
