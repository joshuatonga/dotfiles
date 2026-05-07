#!/bin/bash

DND_FILE="/tmp/dnd_status.txt"

case "$BLOCK_BUTTON" in
1)
  if [[ -f "$DND_FILE" ]]; then
    dunstctl set-paused false
    rm -f "$DND_FILE"
  else
    dunstctl set-paused true
    touch "$DND_FILE"
  fi
  ;;
3)
  dunstctl history-pop
  ;;
esac

if [[ -f "$DND_FILE" ]]; then
  echo "🔕 DND ON "
  echo
  echo \#FF0000
else
  echo "🔔 DND OFF "
  echo
  echo \#000000
fi
