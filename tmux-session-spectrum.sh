#!/bin/bash

# forked from github.com/a-rodin

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/tmux-session-spectrum.conf" 2>/dev/null

if test -n "${DESKTOP_GROUP_NUMBER:-}"; then
  SESSION_NAME="group-${DESKTOP_GROUP_NUMBER}"
  echo "renaming session to ${SESSION_NAME}"
  tmux rename-session "${SESSION_NAME}"
fi

if [ -n "$STYLES" ]; then
  STYLES=(${STYLES})
else
  STYLES=(colour2 colour4 colour5 colour6 colour8 colour1 colour3)
fi
SESSION_NAME=$(tmux display-message -p '#S')
SESSION_NAME_HEX=$(md5sum <<< "${SESSION_NAME}" | cut -f1 -d' ')
IDX=$(python3 -c "print (0x${SESSION_NAME_HEX} % ${#STYLES[@]})")

STYLE=${STYLES[$(((IDX) % ${#STYLES[@]}))]}
tmux set -t $SESSION_NAME status-style bg=$STYLE
tmux set -t $SESSION_NAME pane-active-border-style fg=$STYLE
tmux set-hook -t $SESSION_NAME after-new-window \
  "set -t $SESSION_ID pane-active-border-style fg=$STYLE"
