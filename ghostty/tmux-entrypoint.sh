#!/bin/sh

TMUX_BIN=/opt/homebrew/bin/tmux

if "$TMUX_BIN" has-session 2>/dev/null; then
    exec "$TMUX_BIN" attach-session
fi

exec "$TMUX_BIN" new-session
