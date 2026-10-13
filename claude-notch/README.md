# claude-notch

A Dynamic Island style notch for Claude Code on i3 + X11, built with Eww.
It sits top-center over the i3bar, shows how many Claude sessions are running,
and expands on hover into a panel listing every session with its status.
Clicking a session focuses its terminal through i3; right-clicking removes it
from the list (a live session comes back on its next hook event).

```
collapsed:   ✳ 2 ●●          (icon · live session count · one dot per session, colored by status)
expanded:    api-server     Needs input      ← amber, notifies
             dotfiles       Working          ← green, pulsing
             infra          Ready for review ← blue
```

## How it works

| Piece | What it does |
| --- | --- |
| `bin/claude-notch hook` | Claude Code hook. Reads the event JSON on stdin, updates `$XDG_RUNTIME_DIR/claude-notch/sessions/<id>.json` (atomic write + flock), pings the daemon. Never blocks Claude, always exits 0. |
| `bin/claude-notch start` | The systemd service. Starts an Eww instance (`-c ~/.cache/claude-notch/eww`), opens the window on the chosen monitor, then runs the state daemon: unix socket for hooks + UI stream, i3 IPC subscription (window/workspace/output/shutdown), liveness checks, notifications. |
| `eww/eww.yuck`, `eww/eww.scss` | UI templates. `@@TOKENS@@` are filled from `config.toml` and written to `~/.cache/claude-notch/eww/`. |
| `systemd/claude-notch.service` | User service. i3 starts it via `exec_always ... claude-notch ensure` (idempotent). |

State lives only in `$XDG_RUNTIME_DIR/claude-notch` (mode 0700). Prompts, tool
arguments and transcript paths are never stored; only sanitized labels such as
"Editing app.tsx" or "Running: Run tests".

### Status model

| Status | Set by | Cleared by |
| --- | --- | --- |
| Working (green) | `UserPromptSubmit`, `PreToolUse`, `PostToolUse` | `Stop`, permission/question |
| Needs input (amber) | `PermissionRequest`, `AskUserQuestion`, `ExitPlanMode`, `Elicitation`, `Notification: permission_prompt` | the matching `PostToolUse`, `ElicitationResult`, next prompt |
| Ready for review (blue) | `Stop`, `StopFailure`, `Notification: idle_prompt` while working | focusing the terminal (configurable), next prompt |
| Idle (gray) | `SessionStart`, reviewed | next prompt |
| Disconnected (gray) | Claude process gone without `SessionEnd` (checked every second, pid + start time) | removed after `disconnect_grace_s` |
| Ended (gray) | `SessionEnd` | removed after `recent_ttl_s` or beyond `recent_retain` |

Notes: `Stop` means the turn ended, not that the task succeeded. A user
interrupt (Esc) produces no hook event, so an interrupted session shows Working
until Claude's `idle_prompt` notification (about 60s) flips it to Ready. Long
running tools are never expired by time, only by process death.

One live session per Claude process: `/clear` or `--resume` supersedes the old
entry for that pid.

### Terminal focus

At `SessionStart` the hook records the Claude pid, `WINDOWID` and tmux
socket/pane. Focus resolves, in order: tmux client → ancestor process with an X
window (`xdotool search --pid`) → `WINDOWID`. The lookup is repeated at click
time, so re-attaching tmux from another terminal still works.

## Captures (Copper-style scratchpad)

Keep prompts, answers and links you want to reuse, and copy them back into
Claude with one click. Stored locally in `~/.local/share/claude-notch/captures.json`.

| Key (i3) | Action |
| --- | --- |
| `$mod+Shift+i` | capture the highlighted text (X11 PRIMARY selection, falls back to the clipboard) |
| `$mod+Shift+n` | rofi prompt: type a note or prompt, Enter saves it |
| `$mod+Shift+p` | rofi picker: choose a capture, Enter copies it to the clipboard |

In the panel, each capture has a checkbox (click to mark done), click the text
to copy it, right-click to delete. `claude-notch captures list|clear-done|clear`
from the shell. Options in `[captures]` of `config.toml`.

## Commands

```
claude-notch status        daemon, monitor, sessions (pid, window, workspace)
claude-notch reload        regenerate the eww config from config.toml and reload
claude-notch restart       systemctl --user restart claude-notch
claude-notch stop
claude-notch logs          journalctl --user -u claude-notch -f
claude-notch raise         re-raise the notch above other windows
claude-notch focus <id>    focus a session's terminal
claude-notch dismiss <id>  remove a session from the panel
claude-notch capture [txt] save highlighted text (or txt) as a capture
claude-notch note | pick   rofi prompt to add / rofi picker to copy
claude-notch captures      list | clear-done | clear
claude-notch install-hooks / uninstall-hooks
claude-notch simulate start demo | prompt demo | tool demo | permission demo | done demo | end demo | stop
```

## Configuration

`config.toml` next to this file (symlinked to `~/.config/claude-notch`).
Sections: `[notch]` monitor/anchor/offsets/sizes/collapse delay,
`[notifications]`, `[sound]`, `[sessions]`, `[theme]`. Run `claude-notch reload`
after editing.

Tip: the i3blocks `task` block is centered on the primary bar, so a long task
text can run under the notch. Set `x_offset` in `[notch]` to shift the notch, or
lower `min_width` of the task block.

## Troubleshooting

```
claude-notch status                                  # is the daemon up, which monitor
journalctl --user -u claude-notch -n 100             # daemon + eww logs
eww -c ~/.cache/claude-notch/eww logs                # eww only
eww -c ~/.cache/claude-notch/eww get expanded        # UI variables
cat $XDG_RUNTIME_DIR/claude-notch/hook.log           # hook errors (only written on failure)
ls $XDG_RUNTIME_DIR/claude-notch/sessions/           # one json per session
echo '{"session_id":"t1","hook_event_name":"SessionStart","cwd":"/tmp"}' | claude-notch hook
```

- Notch missing after `i3-msg restart`: the daemon re-raises it on the i3
  `shutdown` event. `claude-notch raise` does it by hand.
- Notch on the wrong monitor: set `monitor = "HDMI-0"` (an output xrandr reports
  as connected). Eww cannot see outputs that xrandr lists as disconnected even if
  i3 still has them.
- Nothing updates: check `grep claude-notch ~/.claude/settings.json` and that
  the session was started after the hooks were installed.
- Panel does not collapse: the collapse timer runs in a background shell; make
  sure `grep` and `sleep` are on PATH for the service.
