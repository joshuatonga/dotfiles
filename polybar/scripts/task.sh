#!/bin/bash
TASK_FILE=~/.current_task

case "$BLOCK_BUTTON" in
1) # left click
  newtask=$(yad --entry \
    --title="Current Task" \
    --text="What are you working on?" \
    --width=300 \
    --center)
  if [ -n "$newtask" ]; then
    echo "$newtask" >"$TASK_FILE"
  fi
  ;;
3) # right click - clear task
  >"$TASK_FILE"
  ;;
esac

if [[ -s "$TASK_FILE" ]]; then
  task=$(cat "$TASK_FILE")
  printf 'currently working on: %s\n' "$task"
else
  echo "no task"
fi
