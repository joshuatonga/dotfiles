#!/bin/bash

# Terminate already running bar instances and wait for them to exit, so the
# new top bar can claim the system tray
killall -q polybar
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 0.1; done

launch() {
  polybar "$1" 2>&1 | tee -a /tmp/polybar.log & disown
}

launch top
launch infobar
# second monitor's top bar, only when it's plugged in
if polybar --list-monitors | cut -d: -f1 | grep -qx '{{display_second}}'; then
  launch top-second
fi

echo "Polybar launched..."
