#!/bin/sh
# Date + time in one of several timezones. `time-tz.sh next` cycles to the
# next zone (saved in ~/.tz).
export STRFTIME_FORMAT='%Y-%m-%d %R'
export TZONES='$DEFAULT_TZ,UTC,Australia/Melbourne'
export TZ_LABELS='MNL,UTC,AU'
[ "$1" = next ] && export BLOCK_BUTTON=1
exec "$(dirname "$0")/time"
