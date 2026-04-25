#!/usr/bin/env bash
input=$(cat)

GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'
SEP=" | "

# --- Model ---
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')

# --- Context percentage ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used_pct" ]; then
  ctx_str=$(printf "ctx %.0f%%" "$used_pct")
else
  ctx_str="ctx --"
fi

# --- 5h rate limit progress bar (█/░ with color coding) ---
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
if [ -n "$five_pct" ]; then
  five_int=$(printf "%.0f" "$five_pct")
  if [ "$five_int" -ge 90 ]; then bar_color="$RED"
  elif [ "$five_int" -ge 70 ]; then bar_color="$YELLOW"
  else bar_color="$GREEN"; fi
  filled=$(( five_int / 10 ))
  empty=$(( 10 - filled ))
  printf -v fill "%${filled}s"; printf -v pad "%${empty}s"
  bar="${fill// /█}${pad// /░}"
  rate_str="5h limit ${bar_color}${bar}${RESET} ${five_int}%"
else
  rate_str="5h limit --"
fi

# --- Directory + git info ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
dir_display=$(basename "$cwd")

git_branch=""
git_remote_url=""
git_status_str=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  git_remote_url=$(git -C "$cwd" remote get-url origin 2>/dev/null || true)

  # Color-coded git status indicators
  staged=$(git -C "$cwd" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
  modified=$(git -C "$cwd" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
  [ "$staged" -gt 0 ]   && git_status_str="${git_status_str}${GREEN}+${staged}${RESET}"
  [ "$modified" -gt 0 ] && git_status_str="${git_status_str} ${YELLOW}~${modified}${RESET}"
fi

# Build OSC 8 clickable link for directory if it's a git repo
if [ -n "$git_remote_url" ]; then
  if echo "$git_remote_url" | grep -q "^git@"; then
    web_url=$(echo "$git_remote_url" | sed 's|git@\([^:]*\):\(.*\)\.git|https://\1/\2|' | sed 's|\.git$||')
  else
    web_url=$(echo "$git_remote_url" | sed 's|\.git$||')
  fi
  dir_link=$'\e]8;;'"$web_url"$'\e\\'"$dir_display"$'\e]8;;\e\\'
else
  dir_link="$dir_display"
fi

# --- Assemble output ---
line="[${model}]${SEP}${ctx_str}"
[ -n "$rate_str" ] && line="${line}${SEP}${rate_str}"
line="${line}${SEP}${dir_link}"
if [ -n "$git_branch" ]; then
  branch_part=" $git_branch"
  [ -n "$git_status_str" ] && branch_part="${branch_part} ${git_status_str}"
  line="${line}${SEP}${branch_part}"
fi

printf "%b\n" "${line}"
