#!/bin/bash
PIDFILE="/tmp/aerospace-help.pid"

# Toggle: if already showing, kill it and exit
if [ -f "$PIDFILE" ]; then
    pid=$(cat "$PIDFILE")
    if kill -0 "$pid" 2>/dev/null; then
        kill "$pid" 2>/dev/null
        rm -f "$PIDFILE"
        exit 0
    fi
    rm -f "$PIDFILE"
fi

# Show help, store PID so we can toggle it off
osascript -e '
tell application "System Events"
    display alert "AeroSpace Shortcuts" message "
WORKSPACES (switch only; never launch apps)
  alt + 1         Free
  alt + 2         Chrome
  alt + 3         ChatGPT / Codex
  alt + 4         Ghostty + Finder
  alt + 5         Discord
  alt + tab        Toggle last workspace
  alt + shift + #  Move unpinned window to workspace # (1-5)

APP LAUNCHERS
  alt + ctrl + c    Calendar
  alt + enter / t    Ghostty
  alt + b    Chrome
  alt + n    Notion      alt + m    Mail
  alt + c    Codex   alt + d    Discord

WINDOWS
  alt + h/j/k/l                Focus direction
  alt + shift + h/j/k/l    Move window
  alt + - / =                   Shrink / Grow
  alt + /        Toggle tile direction
  alt + ,        Toggle accordion
  alt + f        Fullscreen
  alt + w       Close window

SERVICE MODE (alt + shift + ;)
  esc  Reload    r  Reset layout
  f  Float/Tile    backspace  Close others

alt + shift + /   Toggle this help" buttons {"OK"} default button "OK"
end tell
' &

echo $! > "$PIDFILE"
wait $!
rm -f "$PIDFILE"
