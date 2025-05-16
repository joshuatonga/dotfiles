#!/bin/bash

DND_FILE="/tmp/dnd_status.txt"
SOUND_FILE="$HOME/.config/assets/notifications/{{notif_default_sound}}"

dbus-monitor "interface='org.freedesktop.Notifications'" |
  while read -r line; do
    if echo "$line" | grep -q "method call.*Notify"; then
      if [[ ! -f "$DND_FILE" ]]; then
        paplay "$SOUND_FILE" &
      fi
    fi
  done
