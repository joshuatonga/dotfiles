#!/bin/bash
# Do-not-disturb toggle for polybar. `dnd.sh toggle` pauses/resumes dunst,
# `dnd.sh history` re-shows the last notification. claude-notch also reads
# DND_FILE to skip its sound.

DND_FILE="/tmp/dnd_status.txt"

case "$1" in
toggle)
  if [[ -f "$DND_FILE" ]]; then
    dunstctl set-paused false
    rm -f "$DND_FILE"
  else
    dunstctl set-paused true
    touch "$DND_FILE"
  fi
  ;;
history)
  dunstctl history-pop
  ;;
esac

if [[ -f "$DND_FILE" ]]; then
  echo "%{F#FF0000}󰂛 DND ON%{F-}"
else
  echo "%{F#13A10E}󰂚%{F-} DND OFF"
fi
