#!/usr/bin/env python3
"""claude-notch: a Dynamic Island style activity monitor for Claude Code on i3 + Eww.

Subcommands
  hook            Claude Code hook entrypoint (reads the hook JSON on stdin)
  start           Run eww + the state daemon in the foreground (used by systemd)
  ensure          Start the systemd service if it is not running (used by i3 exec_always)
  stop|restart    Control the systemd service
  reload          Regenerate the eww config from config.toml and reload eww
  status          Show daemon + session state
  logs            Follow the service journal
  stream          Stream UI state as JSON lines (used by eww deflisten)
  focus <id>      Focus the terminal of a session through i3
  dismiss <id>    Remove a session from the panel (right-click on a row)
  capture [text]  Save the highlighted text (X11 PRIMARY selection) or the given text as a capture
  note            Rofi prompt: type a note or prompt, Enter saves it
  pick            Rofi picker: choose a capture, Enter copies it to the clipboard
  copy|toggle|delete <id>, captures [list|clear-done|clear]
  raise           Re-raise the notch window above other windows
  install-hooks   Merge the hooks into ~/.claude/settings.json (idempotent)
  uninstall-hooks Remove them again
  simulate ...    Create fake sessions for testing (see `simulate help`)

Only the Python standard library is used.
"""

import fcntl
import json
import os
import re
import select
import shutil
import signal
import socket
import struct
import subprocess
import sys
import threading
import time
from pathlib import Path

VERSION = "1.0.0"
APP = "claude-notch"
LIB_DIR = Path(__file__).resolve().parent
APP_DIR = LIB_DIR.parent
BIN = APP_DIR / "bin" / APP
CONFIG_DIR = Path(os.environ.get("XDG_CONFIG_HOME") or "~/.config").expanduser() / APP
CACHE_DIR = Path(os.environ.get("XDG_CACHE_HOME") or "~/.cache").expanduser() / APP
RUNTIME_DIR = Path(os.environ.get("XDG_RUNTIME_DIR") or f"/tmp/{APP}-{os.getuid()}") / APP
SESSIONS_DIR = RUNTIME_DIR / "sessions"
SOCK_PATH = RUNTIME_DIR / "daemon.sock"
HOOK_LOG = RUNTIME_DIR / "hook.log"
EWW_DIR = CACHE_DIR / "eww"
DATA_DIR = Path(os.environ.get("XDG_DATA_HOME") or "~/.local/share").expanduser() / APP
CAPTURES_PATH = DATA_DIR / "captures.json"
SERVICE = f"{APP}.service"
CLAUDE_SETTINGS = Path("~/.claude/settings.json").expanduser()

SID_RE = re.compile(r"^[A-Za-z0-9_.:-]{1,128}$")
LIVE_STATUSES = ("working", "attention", "ready", "idle")

HOOK_EVENTS = [
    "SessionStart", "SessionEnd", "UserPromptSubmit",
    "PreToolUse", "PostToolUse", "PostToolUseFailure",
    "PermissionRequest", "PermissionDenied", "Notification",
    "Stop", "StopFailure", "SubagentStart", "SubagentStop",
    "PreCompact", "PostCompact", "Elicitation", "ElicitationResult", "CwdChanged",
]

DEFAULTS = {
    "notch": {
        "monitor": "primary", "anchor": "top center", "x_offset": 0, "y_offset": 0,
        "pill_height": 25, "pill_min_width": 110, "panel_width": 400,
        "collapse_delay_ms": 120, "animate": True, "anim_ms": 100, "hide_on_fullscreen": True,
    },
    "notifications": {
        "enabled": True, "attention": True, "completion": True, "skip_if_focused": True,
        "attention_timeout_ms": 20000, "completion_timeout_ms": 4000,
    },
    "sound": {
        "enabled": False, "file": "~/.config/assets/notifications/confident.mp3",
        "player": "paplay", "dnd_file": "/tmp/dnd_status.txt",
    },
    "sessions": {
        "recent_retain": 3, "recent_ttl_s": 600, "disconnect_grace_s": 20,
        "ready_clears_on_focus": True,
    },
    "captures": {
        "enabled": True, "max_shown": 8, "copy_notification": True, "capture_notification": True,
        "max_chars": 20000,
    },
    "theme": {
        "font": "DejaVu Sans", "font_size_px": 12,
        "bg": "#0b0b0e", "bg_hover": "#1a1a21", "border": "#26262d",
        "fg": "#ececf1", "muted": "#8b8f9a",
        "working": "#3ddc84", "attention": "#f5a524", "ready": "#4c9df2", "idle": "#6b7280",
        "radius": 14,
    },
}

STATUS_LABEL = {
    "working": "Working", "attention": "Needs input", "ready": "Ready for review",
    "idle": "Idle", "disconnected": "Disconnected", "ended": "Ended",
}
STATUS_ORDER = {"attention": 0, "working": 1, "ready": 2, "idle": 3, "disconnected": 4, "ended": 5}


# --------------------------------------------------------------------------- utils

def now():
    return time.time()


def log(msg):
    sys.stderr.write(f"[{APP}] {msg}\n")
    sys.stderr.flush()


def hook_log(msg):
    try:
        RUNTIME_DIR.mkdir(parents=True, exist_ok=True, mode=0o700)
        with open(HOOK_LOG, "a") as f:
            f.write(f"{time.strftime('%H:%M:%S')} {msg}\n")
    except Exception:
        pass


def ensure_dirs():
    for d in (RUNTIME_DIR, SESSIONS_DIR):
        d.mkdir(parents=True, exist_ok=True)
        try:
            os.chmod(d, 0o700)
        except OSError:
            pass


def deep_merge(base, extra):
    for k, v in extra.items():
        if isinstance(v, dict) and isinstance(base.get(k), dict):
            deep_merge(base[k], v)
        else:
            base[k] = v
    return base


def load_config():
    cfg = json.loads(json.dumps(DEFAULTS))
    for p in (CONFIG_DIR / "config.toml", APP_DIR / "config.toml"):
        if p.exists():
            try:
                import tomllib
                with open(p, "rb") as f:
                    deep_merge(cfg, tomllib.load(f))
            except Exception as e:  # keep running with defaults
                log(f"config error in {p}: {e}")
            break
    return cfg


def clean_text(s, limit=48):
    if not isinstance(s, str):
        s = str(s)
    s = "".join(ch for ch in s if ch.isprintable())
    s = " ".join(s.split())
    if len(s) > limit:
        s = s[: limit - 1].rstrip() + "…"
    return s


def fmt_elapsed(seconds):
    seconds = max(0, int(seconds))
    if seconds < 60:
        return f"{seconds}s"
    if seconds < 3600:
        return f"{seconds // 60}m"
    h, m = divmod(seconds // 60, 60)
    return f"{h}h{m:02d}m"


def atomic_write_json(path, obj):
    tmp = path.with_suffix(path.suffix + f".tmp{os.getpid()}")
    with open(tmp, "w") as f:
        json.dump(obj, f, separators=(",", ":"))
    os.chmod(tmp, 0o600)
    os.replace(tmp, path)


def run(cmd, timeout=5, env=None, **kw):
    return subprocess.run(cmd, capture_output=True, text=True, timeout=timeout, env=env, **kw)


def sub_env():
    """Environment for i3-msg / eww subprocesses (never trust an inherited I3SOCK)."""
    env = dict(os.environ)
    env.pop("I3SOCK", None)
    return env


# --------------------------------------------------------------------------- process helpers

def proc_stat(pid):
    """Return (comm, ppid, starttime) for pid, or None."""
    try:
        with open(f"/proc/{pid}/stat") as f:
            data = f.read()
    except OSError:
        return None
    lp = data.rfind(")")
    comm = data[data.find("(") + 1: lp]
    fields = data[lp + 2:].split()
    return comm, int(fields[1]), int(fields[19])


def pid_alive(pid, start=None):
    st = proc_stat(pid)
    if not st:
        return False
    return start is None or st[2] == start


def ancestors(pid, limit=16):
    out = []
    while pid and pid > 1 and len(out) < limit:
        out.append(pid)
        st = proc_stat(pid)
        if not st:
            break
        pid = st[1]
    return out


def find_claude_pid(start):
    for p in ancestors(start, 8):
        st = proc_stat(p)
        if st and st[0] == "claude":
            return p
    return start


# --------------------------------------------------------------------------- i3 helpers

def i3_msg(args, timeout=5):
    r = run(["i3-msg", *args], timeout=timeout, env=sub_env())
    if r.returncode != 0 and not r.stdout:
        raise RuntimeError(r.stderr.strip() or "i3-msg failed")
    return json.loads(r.stdout)


def i3_tree():
    return i3_msg(["-t", "get_tree"])


def i3_outputs():
    return [o for o in i3_msg(["-t", "get_outputs"]) if o.get("active")]


def tree_windows(tree):
    """Map X window id -> {ws_num, ws_name, output, focused, fullscreen}."""
    out = {}

    def walk(node, ws, output):
        if node.get("type") == "output":
            output = node.get("name")
        if node.get("type") == "workspace":
            ws = node
        if node.get("window"):
            out[node["window"]] = {
                "ws_num": ws.get("num") if ws else None,
                "ws_name": ws.get("name") if ws else None,
                "output": output,
                "focused": bool(node.get("focused")),
                "fullscreen": int(node.get("fullscreen_mode") or 0),
                "class": (node.get("window_properties") or {}).get("class"),
            }
        for ch in node.get("nodes", []) + node.get("floating_nodes", []):
            walk(ch, ws, output)

    walk(tree, None, None)
    return out


def xdotool_windows_for_pid(pid):
    try:
        r = run(["xdotool", "search", "--pid", str(pid)], timeout=3)
        return [int(x) for x in r.stdout.split() if x.isdigit()]
    except Exception:
        return []


def window_for_pid_ancestry(pid, tree_ids):
    for p in ancestors(pid, 12):
        hits = [w for w in xdotool_windows_for_pid(p) if w in tree_ids]
        if hits:
            return hits[0]
    return None


def tmux_client_pids(sock, pane):
    """PIDs of tmux clients attached to the session containing pane (most recent first)."""
    try:
        base = ["tmux", "-S", sock]
        r = run(base + ["display-message", "-p", "-t", pane, "#{session_id}"], timeout=3)
        sess = r.stdout.strip()
        if r.returncode != 0 or not sess:
            return []
        r = run(base + ["list-clients", "-F", "#{session_id} #{client_pid} #{client_activity}"], timeout=3)
        rows = []
        for line in r.stdout.splitlines():
            parts = line.split()
            if len(parts) >= 2 and parts[0] == sess and parts[1].isdigit():
                act = int(parts[2]) if len(parts) > 2 and parts[2].isdigit() else 0
                rows.append((act, int(parts[1])))
        rows.sort(reverse=True)
        return [p for _, p in rows]
    except Exception:
        return []


def resolve_window(s, wins=None):
    """Find the X window id showing this session's terminal. Returns (id, source) or (None, None)."""
    if wins is None:
        try:
            wins = tree_windows(i3_tree())
        except Exception:
            return None, None
    ids = set(wins)
    if s.get("tmux_socket") and s.get("tmux_pane"):
        for cpid in tmux_client_pids(s["tmux_socket"], s["tmux_pane"]):
            w = window_for_pid_ancestry(cpid, ids)
            if w:
                return w, "tmux"
    wid = s.get("env_windowid")
    if wid and wid in ids and not s.get("tmux_socket"):
        return wid, "env"
    if s.get("pid"):
        w = window_for_pid_ancestry(s["pid"], ids)
        if w:
            return w, "pid"
    if wid and wid in ids:
        return wid, "env"
    return None, None


# --------------------------------------------------------------------------- session storage

class session_lock:
    def __init__(self, sid):
        self.path = SESSIONS_DIR / f"{sid}.lock"

    def __enter__(self):
        self.f = open(self.path, "w")
        fcntl.flock(self.f, fcntl.LOCK_EX)
        return self

    def __exit__(self, *a):
        fcntl.flock(self.f, fcntl.LOCK_UN)
        self.f.close()


def session_path(sid):
    return SESSIONS_DIR / f"{sid}.json"


def load_session(sid):
    try:
        with open(session_path(sid)) as f:
            return json.load(f)
    except (OSError, ValueError):
        return None


def save_session(s):
    atomic_write_json(session_path(s["id"]), s)


def delete_session(sid):
    for p in (session_path(sid), SESSIONS_DIR / f"{sid}.lock"):
        try:
            p.unlink()
        except OSError:
            pass


def all_sessions():
    out = {}
    try:
        for p in SESSIONS_DIR.glob("*.json"):
            s = load_session(p.stem)
            if s and s.get("id") == p.stem:
                out[s["id"]] = s
    except OSError:
        pass
    return out


def project_name(cwd):
    try:
        p = Path(cwd)
    except Exception:
        return "?"
    root = None
    for q in (p, *p.parents):
        if (q / ".git").exists():
            root = q
            break
    if root is None or root == p:
        return clean_text(p.name or str(p), 28)
    return clean_text(f"{root.name}/{p.name}", 28)


def new_session(sid, data):
    t = now()
    cwd = data.get("cwd") or os.getcwd()
    s = {
        "id": sid, "cwd": cwd, "project": project_name(cwd),
        "status": "idle", "status_since": t, "activity": "Session started",
        "attention_reason": "", "attention_tool": None,
        "started_at": t, "updated_at": t, "turn_started_at": None,
        "tools": {}, "subagents": {}, "prompts": 0,
        "pid": None, "pid_start": None,
        "env_windowid": None, "tmux_socket": None, "tmux_pane": None,
        "window_id": None, "window_source": None, "ws_num": None, "ws_name": None, "output": None,
        "ended_at": None, "end_reason": None, "last_event": None,
    }
    capture_process_info(s)
    return s


def capture_process_info(s):
    """Record the Claude process and terminal window for the hook's caller."""
    pid = find_claude_pid(os.getppid())
    st = proc_stat(pid)
    s["pid"] = pid
    s["pid_start"] = st[2] if st else None
    wid = os.environ.get("WINDOWID", "")
    s["env_windowid"] = int(wid) if wid.isdigit() else None
    tmux = os.environ.get("TMUX", "")
    s["tmux_socket"] = tmux.split(",")[0] if tmux else None
    s["tmux_pane"] = os.environ.get("TMUX_PANE") or None
    try:
        wins = tree_windows(i3_tree())
        wid, src = resolve_window(s, wins)
        s["window_id"], s["window_source"] = wid, src
        if wid and wid in wins:
            s["ws_num"], s["ws_name"], s["output"] = wins[wid]["ws_num"], wins[wid]["ws_name"], wins[wid]["output"]
    except Exception as e:
        hook_log(f"window resolve failed: {e}")


# --------------------------------------------------------------------------- event -> state

def tool_label(tool, inp):
    inp = inp if isinstance(inp, dict) else {}

    def base(key="file_path"):
        v = inp.get(key) or inp.get("notebook_path") or ""
        return clean_text(os.path.basename(str(v)), 32) if v else ""

    if tool in ("Edit", "MultiEdit", "Write", "NotebookEdit"):
        return f"Editing {base()}".strip()
    if tool == "Read":
        return f"Reading {base()}".strip()
    if tool == "Bash":
        d = inp.get("description")
        if d:
            return "Running: " + clean_text(d, 36)
        cmd = str(inp.get("command") or "").strip().split()
        return f"Running {clean_text(cmd[0], 20)}" if cmd else "Running command"
    if tool in ("Grep", "Glob"):
        return "Searching files"
    if tool == "WebFetch":
        url = str(inp.get("url") or "")
        host = re.sub(r"^\w+://", "", url).split("/")[0]
        return f"Fetching {clean_text(host, 30)}" if host else "Fetching web page"
    if tool == "WebSearch":
        return "Searching the web"
    if tool in ("Agent", "Task"):
        t = inp.get("subagent_type") or inp.get("description") or ""
        return f"Agent: {clean_text(t, 30)}" if t else "Running agent"
    if tool in ("TodoWrite", "TaskCreate", "TaskUpdate", "TaskList", "TaskGet"):
        return "Updating tasks"
    if tool == "AskUserQuestion":
        return "Waiting for your answer"
    if tool == "ExitPlanMode":
        return "Plan ready for approval"
    if tool == "EnterPlanMode":
        return "Planning"
    if tool == "Skill":
        return f"Skill: {clean_text(inp.get('skill') or '', 28)}"
    if tool.startswith("mcp__"):
        parts = tool.split("__")
        if len(parts) >= 3:
            return clean_text(f"{parts[1]}: {parts[2]}", 40)
    return clean_text(f"Using {tool}", 40)


def set_status(s, status, activity=None, reason=""):
    if s.get("status") != status:
        s["status"] = status
        s["status_since"] = now()
    if activity is not None:
        s["activity"] = activity
    s["attention_reason"] = reason if status == "attention" else ""
    if status != "attention":
        s["attention_tool"] = None


def current_tool_activity(s):
    tools = s.get("tools") or {}
    if tools:
        return list(tools.values())[-1]
    if s.get("subagents"):
        return "Agent: " + clean_text(list(s["subagents"].values())[-1], 30)
    return "Thinking…"


def apply_event(s, ev, data):
    t = now()
    s["updated_at"] = t
    s["last_event"] = ev
    tool = clean_text(data.get("tool_name") or "", 40)
    tuid = data.get("tool_use_id")
    tuid = tuid if isinstance(tuid, str) and len(tuid) < 128 else None

    if ev == "SessionStart":
        src = data.get("source") or "startup"
        if data.get("cwd"):
            s["cwd"] = data["cwd"]
            s["project"] = project_name(data["cwd"])
        if src == "compact":
            s["activity"] = "Context compacted"
        else:
            capture_process_info(s)
            label = {"resume": "Resumed", "clear": "Cleared", "fork": "Forked"}.get(src, "Session started")
            s["tools"], s["subagents"] = {}, {}
            set_status(s, "idle", label)
            s["ended_at"], s["end_reason"] = None, None

    elif ev == "UserPromptSubmit":
        s["tools"], s["subagents"] = {}, {}
        s["turn_started_at"] = t
        s["prompts"] = int(s.get("prompts") or 0) + 1
        set_status(s, "working", "Thinking…")

    elif ev == "PreToolUse":
        label = tool_label(tool, data.get("tool_input"))
        if tuid:
            s.setdefault("tools", {})[tuid] = label
        if tool == "AskUserQuestion":
            set_status(s, "attention", label, "Waiting for your answer")
            s["attention_tool"] = tuid
        elif tool == "ExitPlanMode":
            set_status(s, "attention", label, "Plan needs approval")
            s["attention_tool"] = tuid
        elif s.get("status") != "attention":
            set_status(s, "working", label)

    elif ev == "PermissionRequest":
        set_status(s, "attention", f"Needs permission: {tool}", f"Permission needed for {tool}")
        s["attention_tool"] = tuid

    elif ev == "PermissionDenied":
        set_status(s, "working", f"Auto-denied: {tool}")

    elif ev in ("PostToolUse", "PostToolUseFailure"):
        if tuid:
            s.get("tools", {}).pop(tuid, None)
        if s.get("status") == "attention" and s.get("attention_tool") in (None, tuid):
            set_status(s, "working", current_tool_activity(s))
        elif s.get("status") == "working":
            s["activity"] = current_tool_activity(s)

    elif ev == "Notification":
        nt = data.get("notification_type") or ""
        if nt == "permission_prompt":
            if s.get("status") != "attention":
                set_status(s, "attention", "Needs permission", "Permission needed")
        elif nt == "idle_prompt":
            if s.get("status") == "working":
                set_status(s, "ready", "Waiting for input")
        elif nt in ("agent_needs_input", "elicitation_dialog", "elicitation_url_dialog"):
            set_status(s, "attention", "Needs your input", "Input needed")
        elif nt in ("elicitation_complete", "elicitation_response"):
            if s.get("status") == "attention":
                set_status(s, "working", current_tool_activity(s))
        elif nt == "agent_completed":
            s["activity"] = "Agent completed"
        elif nt.startswith("quota_auto_resume"):
            s["activity"] = {"quota_auto_resume_fired": "Resumed after quota reset",
                             "quota_auto_resume_stale": "Quota auto-resume stale",
                             "quota_auto_resume_disabled": "Quota auto-resume disabled"}.get(nt, "Quota notice")

    elif ev == "Elicitation":
        srv = clean_text(data.get("mcp_server") or "MCP", 24)
        set_status(s, "attention", f"{srv} needs input", f"{srv} needs input")

    elif ev == "ElicitationResult":
        if s.get("status") == "attention":
            set_status(s, "working", current_tool_activity(s))

    elif ev == "Stop":
        s["tools"] = {}
        s["turn_finished_at"] = t
        set_status(s, "ready", "Turn finished")

    elif ev == "StopFailure":
        s["tools"] = {}
        s["turn_finished_at"] = t
        set_status(s, "ready", f"Stopped: {clean_text(data.get('error_type') or 'error', 24)}")

    elif ev == "SubagentStart":
        aid, atype = data.get("agent_id"), clean_text(data.get("agent_type") or "agent", 30)
        if isinstance(aid, str):
            s.setdefault("subagents", {})[aid] = atype
        if s.get("status") == "working":
            s["activity"] = f"Agent: {atype}"

    elif ev == "SubagentStop":
        aid = data.get("agent_id")
        if isinstance(aid, str):
            s.get("subagents", {}).pop(aid, None)
        if s.get("status") == "working":
            s["activity"] = current_tool_activity(s)

    elif ev == "PreCompact":
        s["activity"] = "Compacting context"

    elif ev == "PostCompact":
        if s.get("status") == "working":
            s["activity"] = current_tool_activity(s)

    elif ev == "CwdChanged":
        if data.get("cwd"):
            s["cwd"] = data["cwd"]
            s["project"] = project_name(data["cwd"])

    elif ev == "SessionEnd":
        reason = clean_text(data.get("reason") or "other", 24)
        s["tools"], s["subagents"] = {}, {}
        s["ended_at"], s["end_reason"] = t, reason
        set_status(s, "ended", {"clear": "Cleared", "logout": "Logged out"}.get(reason, "Session ended"))


# --------------------------------------------------------------------------- daemon IPC client

def daemon_connect(obj, timeout=2.0):
    c = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    c.settimeout(timeout)
    c.connect(str(SOCK_PATH))
    c.sendall((json.dumps(obj) + "\n").encode())
    return c


def daemon_request(obj, timeout=2.0):
    """Send one JSON request to the daemon and return the reply dict."""
    c = daemon_connect(obj, timeout)
    buf = b""
    while not buf.endswith(b"\n"):
        chunk = c.recv(65536)
        if not chunk:
            break
        buf += chunk
    c.close()
    return json.loads(buf) if buf.strip() else {}


def ping_daemon(sid):
    try:
        c = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        c.settimeout(0.5)
        c.connect(str(SOCK_PATH))
        c.sendall((json.dumps({"op": "ping", "id": sid}) + "\n").encode())
        c.close()
    except OSError:
        pass  # daemon not running; state is on disk, it will pick it up later


# --------------------------------------------------------------------------- hook command

def cmd_hook():
    try:
        raw = sys.stdin.read()
        data = json.loads(raw) if raw.strip() else {}
        if not isinstance(data, dict):
            return 0
        sid = data.get("session_id")
        ev = data.get("hook_event_name")
        if not (isinstance(sid, str) and SID_RE.match(sid) and isinstance(ev, str)):
            return 0
        ensure_dirs()
        with session_lock(sid):
            s = load_session(sid)
            if s is None:
                s = new_session(sid, data)
            apply_event(s, ev, data)
            save_session(s)
        ping_daemon(sid)
    except Exception as e:
        hook_log(f"error: {e!r}")
    return 0


# --------------------------------------------------------------------------- eww config generation

def eww_cmd(*args, timeout=10):
    return run(["eww", "-c", str(EWW_DIR), *args], timeout=timeout, env=sub_env())


def hex_to_rgb(color):
    """'#rrggbb' -> 'r,g,b' for use inside CSS rgba(); anything else passes through."""
    m = re.fullmatch(r"#?([0-9a-fA-F]{6})", color.strip())
    if not m:
        return "128,128,128"
    h = m.group(1)
    return ",".join(str(int(h[i:i + 2], 16)) for i in (0, 2, 4))


def generate_eww_config(cfg):
    EWW_DIR.mkdir(parents=True, exist_ok=True)
    n, th = cfg["notch"], cfg["theme"]
    tokens = {
        "BIN": str(BIN), "EWW_DIR": str(EWW_DIR),
        "COLLAPSE_DELAY_S": f"{int(n['collapse_delay_ms']) / 1000:.3f}",
        "ANIM_MS": str(int(n["anim_ms"]) if n.get("animate", True) else 0),
        # with animation, the inner (height) revealer must be updated one frame after the outer one
        "EXPAND_GAP": "sleep 0.025; " if n.get("animate", True) else "",
        "ANCHOR": str(n["anchor"]), "X_OFFSET": str(int(n["x_offset"])), "Y_OFFSET": str(int(n["y_offset"])),
        "PILL_HEIGHT": str(int(n["pill_height"])), "PILL_MIN_WIDTH": str(int(n["pill_min_width"])),
        "PANEL_WIDTH": str(int(n["panel_width"])),
        "FONT": str(th["font"]), "FONT_SIZE": str(int(th["font_size_px"])), "RADIUS": str(int(th["radius"])),
    }
    for k in ("bg", "bg_hover", "border", "fg", "muted", "working", "attention", "ready", "idle"):
        tokens[k.upper()] = str(th[k])
        tokens[k.upper() + "_RGB"] = hex_to_rgb(str(th[k]))
    for name in ("eww.yuck", "eww.scss"):
        text = (APP_DIR / "eww" / name).read_text()
        for k, v in tokens.items():
            text = text.replace(f"@@{k}@@", v)
        (EWW_DIR / name).write_text(text)


# --------------------------------------------------------------------------- i3 event socket

class I3Events:
    MAGIC = b"i3-ipc"

    def __init__(self):
        self.sock = None

    def connect(self):
        r = run(["i3", "--get-socketpath"], timeout=5, env=sub_env())
        path = r.stdout.strip()
        if not path:
            raise RuntimeError("i3 socket not found")
        s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        s.connect(path)
        self.sock = s
        self._send(2, json.dumps(["window", "workspace", "output", "shutdown"]).encode())
        self._recv()  # subscribe reply

    def _send(self, mtype, payload):
        self.sock.sendall(self.MAGIC + struct.pack("=II", len(payload), mtype) + payload)

    def _read_exact(self, n):
        buf = b""
        while len(buf) < n:
            chunk = self.sock.recv(n - len(buf))
            if not chunk:
                raise ConnectionError("i3 socket closed")
            buf += chunk
        return buf

    def _recv(self):
        hdr = self._read_exact(14)
        length, mtype = struct.unpack("=II", hdr[6:])
        payload = self._read_exact(length) if length else b""
        return mtype, (json.loads(payload) if payload else {})

    def read_event(self):
        mtype, payload = self._recv()
        return mtype & 0x7FFFFFFF, payload

    def close(self):
        try:
            if self.sock:
                self.sock.close()
        finally:
            self.sock = None


EVENT_WORKSPACE, EVENT_OUTPUT, EVENT_WINDOW, EVENT_SHUTDOWN = 0, 1, 3, 6


# --------------------------------------------------------------------------- daemon

class Daemon:
    def __init__(self, cfg, manage_eww=True):
        self.cfg = cfg
        self.manage_eww = manage_eww
        self.sessions = {}
        self.streams = []
        self.clients = {}
        self.server = None
        self.i3 = I3Events()
        self.i3_down_since = None
        self.eww_proc = None
        self.window_open = False
        self.monitor = None
        self.tree_dirty_at = None
        self.raise_at = None
        self.reopen_at = None
        self.focused_window = None
        self.hidden_for_fullscreen = False
        self.notified = {}
        self.captures = load_captures()
        self.last_broadcast = ""
        self.stopping = False
        self.lock = threading.Lock()

    # ---- lifecycle
    def run(self):
        ensure_dirs()
        self.load_all()
        self.open_server()
        if self.manage_eww:
            self.start_eww()
        self.connect_i3()
        self.refresh_tree()
        self.broadcast(force=True)
        log("daemon ready")
        last_tick = 0.0
        while not self.stopping:
            timeout = self.next_timeout()
            fds = [self.server] + list(self.clients)
            if self.i3.sock:
                fds.append(self.i3.sock)
            try:
                r, _, _ = select.select(fds, [], [], timeout)
            except InterruptedError:
                r = []
            for fd in r:
                if fd is self.server:
                    self.accept()
                elif fd is self.i3.sock:
                    self.handle_i3()
                else:
                    self.handle_client(fd)
            t = now()
            if self.i3.sock is None and (self.i3_down_since is None or t - self.i3_down_since > 0.5):
                self.connect_i3(quiet=True)
            if self.tree_dirty_at and t >= self.tree_dirty_at:
                self.tree_dirty_at = None
                self.refresh_tree()
            if self.raise_at and t >= self.raise_at:
                self.raise_at = None
                self.raise_window()
            if self.reopen_at and t >= self.reopen_at:
                self.reopen_at = None
                self.reopen_window()
            if t - last_tick >= 1.0:
                last_tick = t
                self.tick()
            if self.manage_eww and self.eww_proc and self.eww_proc.poll() is not None:
                log("eww exited; shutting down so systemd can restart us")
                return 1
            self.broadcast()
        return 0

    def shutdown(self):
        self.stopping = True
        try:
            if self.eww_proc and self.eww_proc.poll() is None:
                self.eww_proc.terminate()
                try:
                    self.eww_proc.wait(3)
                except subprocess.TimeoutExpired:
                    self.eww_proc.kill()
        except Exception:
            pass
        try:  # only remove the socket if it is still the one we created
            if getattr(self, "sock_ino", None) == os.stat(SOCK_PATH).st_ino:
                SOCK_PATH.unlink()
        except OSError:
            pass

    def next_timeout(self):
        t = now()
        cands = [1.0]
        for at in (self.tree_dirty_at, self.raise_at, self.reopen_at):
            if at:
                cands.append(max(0.01, at - t))
        if self.i3.sock is None:
            cands.append(0.5)
        return min(cands)

    # ---- eww
    def start_eww(self):
        generate_eww_config(self.cfg)
        if eww_cmd("ping", timeout=2).returncode == 0:
            log("stale eww instance found; stopping it first")
            eww_cmd("kill", timeout=3)
            for _ in range(30):
                if eww_cmd("ping", timeout=2).returncode != 0:
                    break
                time.sleep(0.1)
        self.eww_proc = subprocess.Popen(
            ["eww", "-c", str(EWW_DIR), "daemon", "--no-daemonize"], env=sub_env(),
            stdout=sys.stderr, stderr=subprocess.STDOUT)
        for _ in range(100):
            if eww_cmd("ping", timeout=2).returncode == 0:
                break
            time.sleep(0.1)
        else:
            raise RuntimeError("eww daemon did not come up")
        self.open_window()

    def resolve_monitor(self):
        """Pick the i3 output to show the notch on. GDK only sees outputs xrandr reports as
        connected, so an i3 'primary' that xrandr calls disconnected is skipped."""
        want = str(self.cfg["notch"]["monitor"]).strip()
        try:
            outs = i3_outputs()
        except Exception:
            outs = []
        connected = set()
        try:
            for line in run(["xrandr", "--query"], timeout=5).stdout.splitlines():
                parts = line.split()
                if len(parts) > 1 and parts[1] == "connected":
                    connected.add(parts[0])
        except Exception:
            pass
        names = [o["name"] for o in outs if not connected or o["name"] in connected]
        if want.lower() == "primary":
            for o in outs:
                if o.get("primary") and o["name"] in names:
                    return o["name"]
            return names[0] if names else "0"
        if want in names or not names:
            return want
        log(f"monitor {want!r} not available, falling back to {names[0]}")
        return names[0]

    def open_window(self):
        self.monitor = self.resolve_monitor()
        r = eww_cmd("open", "notch", "--screen", self.monitor)
        if r.returncode != 0 and self.monitor != "0":
            log(f"eww open on {self.monitor} failed, trying monitor 0: {r.stderr.strip().splitlines()[-1:]}")
            r = eww_cmd("open", "notch", "--screen", "0")
        if r.returncode != 0:
            log(f"eww open failed: {r.stderr.strip()}")
        self.window_open = r.returncode == 0
        if self.window_open:
            eww_cmd("update", "expanded=false", "expanded_v=false", "hovered=false")
        self.raise_at = now() + 0.3

    def close_window(self):
        if self.window_open:
            eww_cmd("close", "notch")
            self.window_open = False

    def reopen_window(self):
        self.close_window()
        self.open_window()

    def raise_window(self):
        if not self.window_open:
            return
        try:
            r = run(["xdotool", "search", "--classname", "^eww-notch$"], timeout=3)
            ids = [w for w in r.stdout.split() if w.isdigit()]
            if not ids:
                r = run(["xdotool", "search", "--class", "^eww$"], timeout=3)
                ids = [w for w in r.stdout.split() if w.isdigit()]
            for w in ids:
                run(["xdotool", "windowraise", w], timeout=3)
        except Exception as e:
            log(f"raise failed: {e}")

    # ---- i3
    def connect_i3(self, quiet=False):
        try:
            was_down = self.i3_down_since is not None
            self.i3.connect()
            self.i3_down_since = None
            self.tree_dirty_at = now() + 0.2
            self.raise_at = now() + 0.6
            if was_down:
                log("reconnected to i3; re-raising the notch")
            elif not quiet:
                log("connected to i3")
        except Exception as e:
            self.i3.close()
            if self.i3_down_since is None:
                self.i3_down_since = now()
                log(f"i3 unavailable ({e}); retrying")
            else:
                self.i3_down_since = now()

    def handle_i3(self):
        try:
            etype, ev = self.i3.read_event()
        except Exception:
            self.i3.close()
            self.i3_down_since = now()
            return
        change = ev.get("change")
        if etype == EVENT_SHUTDOWN:
            self.i3.close()
            self.i3_down_since = now()
            if change == "exit":
                log("i3 exiting")
                self.stopping = True
            return
        if etype == EVENT_WINDOW:
            if change == "title":
                return
            if change == "focus":
                con = ev.get("container") or {}
                self.focused_window = con.get("window")
                self.on_focus(self.focused_window)
            self.tree_dirty_at = now() + 0.25
        elif etype == EVENT_WORKSPACE:
            if change in ("focus", "init", "empty", "move", "reload"):
                self.tree_dirty_at = now() + 0.25
        elif etype == EVENT_OUTPUT:
            self.reopen_at = now() + 1.5

    def refresh_tree(self):
        try:
            tree = i3_tree()
        except Exception:
            return
        wins = tree_windows(tree)
        changed = False
        focused = next((k for k, v in wins.items() if v["focused"]), None)
        if focused:
            self.focused_window = focused
        for s in self.sessions.values():
            wid = s.get("window_id")
            if wid and wid in wins:
                w = wins[wid]
                if (s.get("ws_num"), s.get("ws_name"), s.get("output")) != (w["ws_num"], w["ws_name"], w["output"]):
                    s["ws_num"], s["ws_name"], s["output"] = w["ws_num"], w["ws_name"], w["output"]
                    changed = True
        # fullscreen on the notch's monitor (visible workspace only)
        if self.manage_eww and self.cfg["notch"]["hide_on_fullscreen"]:
            fs = self.fullscreen_on_monitor(tree)
            if fs and self.window_open:
                log("fullscreen window detected; hiding notch")
                self.close_window()
                self.hidden_for_fullscreen = True
            elif not fs and self.hidden_for_fullscreen and not self.window_open:
                self.hidden_for_fullscreen = False
                self.open_window()
        if changed:
            self.last_broadcast = ""

    def fullscreen_on_monitor(self, tree):
        for out in tree.get("nodes", []):
            if out.get("type") != "output" or out.get("name") != self.monitor:
                continue
            visible = None
            for content in out.get("nodes", []):
                for ws in content.get("nodes", []):
                    if ws.get("type") != "workspace":
                        continue
                    # the visible workspace is the one in the focus chain of the output
                    if content.get("focus") and ws.get("id") == content["focus"][0]:
                        visible = ws
            if not visible:
                return False
            stack = [visible]
            while stack:
                n = stack.pop()
                if n.get("window") and int(n.get("fullscreen_mode") or 0) > 0:
                    return True
                stack.extend(n.get("nodes", []))
                stack.extend(n.get("floating_nodes", []))
        return False

    def on_focus(self, wid):
        if not wid or not self.cfg["sessions"]["ready_clears_on_focus"]:
            return
        for s in self.sessions.values():
            if s.get("window_id") == wid and s.get("status") == "ready":
                with session_lock(s["id"]):
                    cur = load_session(s["id"]) or s
                    if cur.get("status") == "ready":
                        set_status(cur, "idle", "Reviewed")
                        save_session(cur)
                        self.sessions[s["id"]] = cur
                self.last_broadcast = ""

    # ---- sessions
    def load_all(self):
        self.sessions = all_sessions()
        self.dedupe()

    def reload_session(self, sid):
        old = self.sessions.get(sid)
        s = load_session(sid)
        if s is None:
            self.sessions.pop(sid, None)
            self.last_broadcast = ""
            return
        self.sessions[sid] = s
        self.dedupe()
        self.on_transition(old, s)
        self.last_broadcast = ""

    def dedupe(self):
        """One live session per Claude process: a /clear or resume supersedes the old one."""
        by_pid = {}
        for s in sorted(self.sessions.values(), key=lambda x: x.get("started_at") or 0):
            if s.get("status") in ("ended", "disconnected"):
                continue
            key = (s.get("pid"), s.get("pid_start"))
            if key[0] and key in by_pid:
                old = by_pid[key]
                self.drop(old["id"])
            by_pid[key] = s

    def drop(self, sid):
        self.sessions.pop(sid, None)
        delete_session(sid)
        self.notified.pop(sid, None)
        self.last_broadcast = ""

    def tick(self):
        t = now()
        sc = self.cfg["sessions"]
        ended = []
        for s in list(self.sessions.values()):
            st = s.get("status")
            if not session_path(s["id"]).exists():  # removed externally
                self.drop(s["id"])
                continue
            if st == "ended":
                ended.append(s)
                continue
            if st == "disconnected":
                if t - (s.get("status_since") or t) > sc["disconnect_grace_s"]:
                    self.drop(s["id"])
                continue
            if s.get("pid") and not pid_alive(s["pid"], s.get("pid_start")):
                with session_lock(s["id"]):
                    cur = load_session(s["id"]) or s
                    if cur.get("status") not in ("ended", "disconnected"):
                        set_status(cur, "disconnected", "Process exited")
                        save_session(cur)
                    self.sessions[s["id"]] = cur
                self.last_broadcast = ""
        ended.sort(key=lambda x: x.get("ended_at") or 0, reverse=True)
        for i, s in enumerate(ended):
            if i >= sc["recent_retain"] or t - (s.get("ended_at") or t) > sc["recent_ttl_s"]:
                self.drop(s["id"])
        # elapsed labels change over time: rebroadcast at most every 5s while anything is shown
        if self.sessions and int(t) % 5 == 0:
            self.last_broadcast = ""

    # ---- notifications
    def on_transition(self, old, new):
        ncfg = self.cfg["notifications"]
        if not ncfg["enabled"]:
            return
        o = (old or {}).get("status")
        n = new.get("status")
        if o == n:
            return
        sid = new["id"]
        if n == "attention" and ncfg["attention"]:
            self.notify(new, "attention")
        elif n == "ready" and o == "working" and new.get("last_event") in ("Stop", "StopFailure"):
            if ncfg["completion"]:
                self.notify(new, "completion")
            self.play_sound()
        if n != "attention":
            self.notified.pop(sid, None)

    def notify(self, s, kind):
        ncfg = self.cfg["notifications"]
        if ncfg["skip_if_focused"] and s.get("window_id") and s.get("window_id") == self.focused_window:
            return
        sid = s["id"]
        if kind == "attention":
            if self.notified.get(sid) == "attention":
                return
            self.notified[sid] = "attention"
            title = f"{s['project']} needs input"
            body = s.get("attention_reason") or s.get("activity") or "Claude is waiting for you"
            urgency, timeout, icon = "normal", ncfg["attention_timeout_ms"], "dialog-question"
        else:
            title = f"{s['project']} is ready"
            body = s.get("activity") or "Turn finished"
            urgency, timeout, icon = "low", ncfg["completion_timeout_ms"], "dialog-information"
        if s.get("ws_name"):
            body += f"  ·  workspace {clean_text(str(s['ws_name']), 20)}"
        cmd = ["notify-send", "-a", "Claude Code", "-u", urgency, "-t", str(int(timeout)), "-i", icon,
               "-h", f"string:x-dunst-stack-tag:{APP}-{sid}", "-A", "default=Focus terminal",
               markup_escape(title), markup_escape(body)]
        threading.Thread(target=self._notify_thread, args=(cmd, sid), daemon=True).start()

    def _notify_thread(self, cmd, sid):
        try:
            r = subprocess.run(cmd, capture_output=True, text=True, timeout=3600)
            if r.stdout.strip() == "default":
                focus_session(sid)
        except Exception as e:
            log(f"notify failed: {e}")

    def play_sound(self):
        sc = self.cfg["sound"]
        if not sc["enabled"]:
            return
        dnd = sc.get("dnd_file")
        if dnd and os.path.exists(os.path.expanduser(dnd)):
            return
        f = os.path.expanduser(sc["file"])
        player = shutil.which(sc["player"])
        if player and os.path.exists(f):
            subprocess.Popen([player, f], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    # ---- UI state
    def ui_state(self):
        t = now()
        rows = []
        for s in sorted(self.sessions.values(),
                        key=lambda x: (STATUS_ORDER.get(x.get("status"), 9), -(x.get("updated_at") or 0))):
            st = s.get("status") or "idle"
            since = s.get("status_since") or t
            if st == "working":
                elapsed = fmt_elapsed(t - (s.get("turn_started_at") or since))
            else:
                elapsed = fmt_elapsed(t - since) + " ago"
            color = st if st in ("working", "attention", "ready") else "idle"
            rows.append({
                "id": s["id"] if SID_RE.match(s["id"]) else "",
                "project": s.get("project") or "?",
                "status": st, "color": color, "live": st in LIVE_STATUSES,
                "label": STATUS_LABEL.get(st, st.title()),
                "activity": clean_text(s.get("activity") or "", 48),
                "elapsed": elapsed,
                "ws": "" if s.get("ws_num") is None else str(s["ws_num"]),
                "ws_name": clean_text(str(s.get("ws_name") or ""), 20),
            })
        counts = {k: 0 for k in ("working", "attention", "ready", "idle")}
        for r in rows:
            counts[r["color"]] += 1
        live = sum(1 for r in rows if r["status"] in LIVE_STATUSES)
        ccfg = self.cfg["captures"]
        caps = []
        if ccfg["enabled"]:
            ordered = sorted(self.captures, key=lambda it: (it.get("done", False), -(it.get("created_at") or 0)))
            for it in ordered[: int(ccfg["max_shown"])]:
                text = it.get("text") or ""
                first = text.strip().splitlines()[0] if text.strip() else ""
                nlines = len(text.splitlines())
                caps.append({
                    "id": it["id"] if SID_RE.match(str(it.get("id", ""))) else "",
                    "text": clean_text(first, 70) + (f"  +{nlines - 1}" if nlines > 1 else ""),
                    "done": bool(it.get("done")),
                    "age": fmt_elapsed(t - (it.get("created_at") or t)),
                })
        overall = "attention" if counts["attention"] else "working" if counts["working"] else \
            "ready" if counts["ready"] else "idle"
        return {"count": live, "total": len(rows), "state": overall, "counts": counts, "sessions": rows,
                "captures": caps, "captures_total": len(self.captures),
                "captures_open": sum(1 for it in self.captures if not it.get("done"))}

    def broadcast(self, force=False):
        payload = json.dumps(self.ui_state(), separators=(",", ":"))
        if payload == self.last_broadcast and not force:
            return
        self.last_broadcast = payload
        line = (payload + "\n").encode()
        for c in list(self.streams):
            try:
                c.sendall(line)
            except OSError:
                self.streams.remove(c)
                self.clients.pop(c, None)
                c.close()

    # ---- control socket
    def open_server(self):
        try:
            SOCK_PATH.unlink()
        except OSError:
            pass
        srv = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        srv.bind(str(SOCK_PATH))
        os.chmod(SOCK_PATH, 0o600)
        srv.listen(16)
        srv.setblocking(False)
        self.server = srv
        self.sock_ino = os.stat(SOCK_PATH).st_ino

    def accept(self):
        try:
            c, _ = self.server.accept()
        except OSError:
            return
        c.setblocking(False)
        self.clients[c] = b""

    def handle_client(self, c):
        try:
            data = c.recv(65536)
        except OSError:
            data = b""
        if not data:
            self.clients.pop(c, None)
            if c in self.streams:
                self.streams.remove(c)
            c.close()
            return
        buf = self.clients.get(c, b"") + data
        while b"\n" in buf:
            line, buf = buf.split(b"\n", 1)
            try:
                req = json.loads(line)
            except ValueError:
                continue
            self.handle_request(c, req)
        self.clients[c] = buf

    def handle_request(self, c, req):
        op = req.get("op")
        if op == "ping":
            sid = req.get("id")
            if isinstance(sid, str) and SID_RE.match(sid):
                self.reload_session(sid)
        elif op == "captures":
            self.captures = load_captures()
            self.last_broadcast = ""
        elif op == "stream":
            self.streams.append(c)
            try:
                c.sendall((json.dumps(self.ui_state(), separators=(",", ":")) + "\n").encode())
            except OSError:
                pass
        elif op == "status":
            self.reply(c, {"ok": True, "monitor": self.monitor, "window_open": self.window_open,
                           "i3": self.i3.sock is not None, "focused_window": self.focused_window,
                           "streams": len(self.streams), "sessions": list(self.sessions.values())})
        elif op == "raise":
            self.raise_at = now() + float(req.get("delay") or 0.3)
            self.reply(c, {"ok": True})
        elif op == "reopen":
            self.reopen_at = now() + 0.1
            self.reply(c, {"ok": True})
        elif op == "reload":
            self.cfg = load_config()
            generate_eww_config(self.cfg)
            r = eww_cmd("reload")
            self.reply(c, {"ok": r.returncode == 0, "err": r.stderr.strip()})
            self.reopen_at = now() + 0.5
        elif op == "drop":
            sid = req.get("id")
            if isinstance(sid, str) and SID_RE.match(sid):
                self.drop(sid)
            self.reply(c, {"ok": True})
        else:
            self.reply(c, {"ok": False, "err": "unknown op"})

    def reply(self, c, obj):
        try:
            c.sendall((json.dumps(obj) + "\n").encode())
        except OSError:
            pass


# --------------------------------------------------------------------------- focus

def focus_session(sid):
    """Focus the terminal window of a session via i3. Returns True on success."""
    if not SID_RE.match(sid):
        return False
    s = load_session(sid)
    if not s:
        return False
    try:
        wins = tree_windows(i3_tree())
    except Exception as e:
        log(f"i3 unavailable: {e}")
        return False
    wid = s.get("window_id")
    if not wid or wid not in wins:
        wid, src = resolve_window(s, wins)
        if wid:
            with session_lock(sid):
                cur = load_session(sid)
                if cur:
                    cur["window_id"], cur["window_source"] = wid, src
                    save_session(cur)
    if not wid:
        subprocess.Popen(["notify-send", "-a", "Claude Code", "-u", "low", "-t", "3000",
                          "Claude Code", f"Could not find the terminal for {s.get('project', '?')}"])
        return False
    res = i3_msg([f"[id={wid}] focus"])
    ok = bool(res and res[0].get("success"))
    try:
        eww_cmd("update", "hovered=false", "expanded=false", "expanded_v=false", timeout=3)
    except Exception:
        pass
    return ok


def dismiss_session(sid):
    """Remove a session from the panel. A live session reappears on its next hook event."""
    if not SID_RE.match(sid):
        return False
    delete_session(sid)
    try:
        daemon_request({"op": "drop", "id": sid})
    except OSError:
        pass
    return True


# --------------------------------------------------------------------------- captures (Copper-style)

class captures_lock:
    def __enter__(self):
        DATA_DIR.mkdir(parents=True, exist_ok=True)
        self.f = open(DATA_DIR / "captures.lock", "w")
        fcntl.flock(self.f, fcntl.LOCK_EX)
        return self

    def __exit__(self, *a):
        fcntl.flock(self.f, fcntl.LOCK_UN)
        self.f.close()


def load_captures():
    try:
        with open(CAPTURES_PATH) as f:
            data = json.load(f)
        return data if isinstance(data, list) else []
    except (OSError, ValueError):
        return []


def save_captures(items):
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    atomic_write_json(CAPTURES_PATH, items)


def notify_daemon_captures():
    try:
        c = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        c.settimeout(0.5)
        c.connect(str(SOCK_PATH))
        c.sendall(b'{"op":"captures"}\n')
        c.close()
    except OSError:
        pass


def markup_escape(text):
    """dunst renders the body as Pango markup; captured text must not be able to inject it."""
    return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def small_notify(title, body, ms=1500):
    subprocess.Popen(["notify-send", "-a", "Claude Code", "-u", "low", "-t", str(ms),
                      "-h", f"string:x-dunst-stack-tag:{APP}-captures", title, markup_escape(body)],
                     stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def clipboard_set(text):
    """Put text on the CLIPBOARD selection (xclip keeps serving it in the background)."""
    tool = shutil.which("xclip")
    if tool:
        cmd = [tool, "-selection", "clipboard", "-in"]
    else:
        tool = shutil.which("xsel")
        if not tool:
            return False
        cmd = [tool, "--clipboard", "--input"]
    p = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                         start_new_session=True)
    p.stdin.write(text.encode())
    p.stdin.close()
    return True


def selection_get(which="primary"):
    for cmd in (["xclip", "-selection", which, "-out"], ["xsel", f"--{which}", "--output"]):
        if shutil.which(cmd[0]):
            try:
                r = subprocess.run(cmd, capture_output=True, timeout=2)
                if r.returncode == 0:
                    return r.stdout.decode("utf-8", "replace")
            except Exception:
                pass
    return ""


def add_capture(text, source):
    cfg = load_config()["captures"]
    text = text.replace("\r\n", "\n").strip("\n")
    if not text.strip():
        return None
    text = text[: int(cfg["max_chars"])]
    item = {"id": f"c{int(now() * 1000):x}{os.getpid() % 1000:03d}", "text": text, "done": False,
            "created_at": now(), "source": source}
    with captures_lock():
        items = load_captures()
        items.append(item)
        save_captures(items)
    notify_daemon_captures()
    if cfg["capture_notification"]:
        small_notify("Captured", clean_text(text.splitlines()[0] if text.strip() else text, 60))
    return item


def capture_find(items, cid):
    for it in items:
        if it.get("id") == cid:
            return it
    return None


def cmd_capture(args):
    if args:
        text = " ".join(args)
        src = "typed"
    else:
        text = selection_get("primary") or selection_get("clipboard")
        src = "selection"
    if not text.strip():
        small_notify("Nothing to capture", "Highlight some text first")
        return 1
    return 0 if add_capture(text, src) else 1


def rofi(args, stdin=""):
    r = subprocess.run(["rofi", *args], input=stdin, capture_output=True, text=True, timeout=600)
    return r.returncode, r.stdout.rstrip("\n")


def cmd_note():
    rc, out = rofi(["-dmenu", "-p", "Capture", "-l", "0", "-theme-str", "listview { enabled: false; }"])
    if rc != 0 or not out.strip():
        return 1
    return 0 if add_capture(out, "typed") else 1


def cmd_pick():
    items = [it for it in load_captures()]
    if not items:
        small_notify("No captures yet", "Highlight text and press the capture shortcut")
        return 1
    items = sorted(items, key=lambda it: (it.get("done", False), -(it.get("created_at") or 0)))
    lines = []
    for it in items:
        first = clean_text(it["text"].splitlines()[0] if it["text"].strip() else it["text"], 90)
        extra = f"  (+{len(it['text'].splitlines()) - 1} lines)" if len(it["text"].splitlines()) > 1 else ""
        lines.append(("☑ " if it.get("done") else "☐ ") + first + extra)
    rc, out = rofi(["-dmenu", "-i", "-p", "Copy", "-format", "i", "-no-custom"], "\n".join(lines))
    if rc != 0 or not out.strip().isdigit():
        return 1
    return cmd_copy(items[int(out.strip())]["id"])


def cmd_copy(cid):
    it = capture_find(load_captures(), cid)
    if not it:
        return 1
    ok = clipboard_set(it["text"])
    cfg = load_config()["captures"]
    if ok and cfg["copy_notification"]:
        small_notify("Copied", clean_text(it["text"].splitlines()[0] if it["text"].strip() else it["text"], 60))
    try:
        eww_cmd("update", "hovered=false", "expanded=false", "expanded_v=false", timeout=3)
    except Exception:
        pass
    return 0 if ok else 1


def cmd_capture_edit(action, cid):
    with captures_lock():
        items = load_captures()
        it = capture_find(items, cid)
        if not it:
            return 1
        if action == "toggle":
            it["done"] = not it.get("done", False)
        elif action == "delete":
            items.remove(it)
        save_captures(items)
    notify_daemon_captures()
    return 0


def cmd_captures(args):
    sub = args[0] if args else "list"
    if sub == "list":
        for it in load_captures():
            mark = "done" if it.get("done") else "open"
            first = it["text"].splitlines()[0] if it["text"].strip() else ""
            print(f"{mark}  {it['id']}  {clean_text(first, 80)}")
        return 0
    if sub in ("clear-done", "clear"):
        with captures_lock():
            items = load_captures()
            items = [] if sub == "clear" else [it for it in items if not it.get("done")]
            save_captures(items)
        notify_daemon_captures()
        print("ok")
        return 0
    print("captures [list|clear-done|clear]")
    return 1


# --------------------------------------------------------------------------- hooks install

def hook_entry():
    return {"type": "command", "command": f'"{BIN}" hook', "timeout": 10}


def is_our_hook(h):
    return isinstance(h, dict) and f"{APP}" in str(h.get("command", "")) and " hook" in str(h.get("command", ""))


def cmd_install_hooks(remove=False):
    settings = {}
    if CLAUDE_SETTINGS.exists():
        settings = json.loads(CLAUDE_SETTINGS.read_text() or "{}")
        backup = CLAUDE_SETTINGS.with_name(f"settings.json.bak-{APP}-{time.strftime('%Y%m%d%H%M%S')}")
        shutil.copy2(CLAUDE_SETTINGS, backup)
        print(f"backup: {backup}")
    hooks = settings.setdefault("hooks", {})
    for ev in HOOK_EVENTS:
        groups = hooks.get(ev) or []
        kept = []
        for g in groups:
            if isinstance(g, dict):
                g["hooks"] = [h for h in g.get("hooks", []) if not is_our_hook(h)]
                if g["hooks"]:
                    kept.append(g)
        if not remove:
            kept.append({"hooks": [hook_entry()]})
        if kept:
            hooks[ev] = kept
        else:
            hooks.pop(ev, None)
    if not hooks:
        settings.pop("hooks", None)
    CLAUDE_SETTINGS.parent.mkdir(parents=True, exist_ok=True)
    tmp = CLAUDE_SETTINGS.with_suffix(".json.tmp")
    tmp.write_text(json.dumps(settings, indent=2) + "\n")
    os.replace(tmp, CLAUDE_SETTINGS)
    print(("removed" if remove else "installed") + f" {APP} hooks for {len(HOOK_EVENTS)} events in {CLAUDE_SETTINGS}")
    return 0


# --------------------------------------------------------------------------- service commands

def systemctl(*args, check=False):
    r = run(["systemctl", "--user", *args], timeout=30)
    if check and r.returncode != 0:
        log(r.stderr.strip())
    return r


def cmd_start():
    cfg = load_config()
    d = Daemon(cfg, manage_eww=True)

    def on_sig(*_):
        d.stopping = True

    signal.signal(signal.SIGTERM, on_sig)
    signal.signal(signal.SIGINT, on_sig)
    try:
        return d.run()
    finally:
        d.shutdown()


def cmd_ensure():
    """Idempotent: start the service if needed, otherwise ask the running daemon to re-raise the notch."""
    r = systemctl("is-active", SERVICE)
    if r.stdout.strip() == "active":
        try:
            daemon_request({"op": "raise", "delay": 0.8})
        except OSError:
            pass
        return 0
    systemctl("reset-failed", SERVICE)
    r = systemctl("start", SERVICE)
    if r.returncode != 0:
        log(f"systemctl start failed: {r.stderr.strip()}; running in background directly")
        subprocess.Popen([str(BIN), "start"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                         start_new_session=True)
    return 0


def cmd_reload():
    cfg = load_config()
    generate_eww_config(cfg)
    try:
        rep = daemon_request({"op": "reload"}, timeout=15)
        print("reloaded" if rep.get("ok") else f"reload failed: {rep.get('err')}")
        return 0 if rep.get("ok") else 1
    except OSError:
        print("daemon not running; config regenerated. Start with: claude-notch restart")
        return 1


def cmd_status():
    r = systemctl("is-active", SERVICE)
    print(f"service: {r.stdout.strip() or 'unknown'}")
    try:
        rep = daemon_request({"op": "status"})
    except OSError as e:
        print(f"daemon: not reachable ({e})")
        print(f"sessions on disk: {len(all_sessions())}")
        return 1
    print(f"daemon: ok  monitor={rep.get('monitor')} window_open={rep.get('window_open')} "
          f"i3={rep.get('i3')} streams={rep.get('streams')}")
    sess = rep.get("sessions") or []
    if not sess:
        print("sessions: none")
    for s in sess:
        print(f"  {s['id'][:8]}  {s.get('status'):12} {s.get('project'):24} pid={s.get('pid')} "
              f"win={s.get('window_id')} ws={s.get('ws_name')} src={s.get('window_source')}  {s.get('activity')}")
    return 0


def cmd_stream():
    """Used by eww deflisten: print UI state lines forever, reconnecting when the daemon restarts."""
    empty = json.dumps({"count": 0, "total": 0, "state": "idle",
                        "counts": {"working": 0, "attention": 0, "ready": 0, "idle": 0}, "sessions": [],
                        "captures": [], "captures_total": 0, "captures_open": 0})
    print(empty, flush=True)
    while True:
        try:
            c = daemon_connect({"op": "stream"}, timeout=5)
            c.settimeout(None)
            buf = b""
            while True:
                chunk = c.recv(65536)
                if not chunk:
                    break
                buf += chunk
                while b"\n" in buf:
                    line, buf = buf.split(b"\n", 1)
                    sys.stdout.write(line.decode() + "\n")
                    sys.stdout.flush()
        except (OSError, BrokenPipeError):
            pass
        print(empty, flush=True)
        time.sleep(1.0)


def cmd_simulate(args):
    """Fake sessions for testing the UI without running Claude."""
    sim_dir = RUNTIME_DIR / "sim"
    sim_dir.mkdir(parents=True, exist_ok=True)
    usage = ("simulate start <name>     create a fake session (idle)\n"
             "simulate <event> <name>   event: prompt|tool|permission|done|end|ask\n"
             "simulate stop             remove all fake sessions\n")
    if not args or args[0] == "help":
        print(usage)
        return 0

    def fake(name, ev, extra=None):
        sid = f"sim-{name}"
        pidfile = sim_dir / f"{name}.pid"
        if ev == "SessionStart":
            p = subprocess.Popen(["sleep", "3600"], start_new_session=True)
            pidfile.write_text(str(p.pid))
        data = {"session_id": sid, "hook_event_name": ev, "cwd": str(Path.home() / "me" / name)}
        data.update(extra or {})
        ensure_dirs()
        with session_lock(sid):
            s = load_session(sid) or new_session(sid, data)
            if ev == "SessionStart" and pidfile.exists():
                pid = int(pidfile.read_text())
                s["pid"], s["pid_start"] = pid, (proc_stat(pid) or (None, None, None))[2]
                s["project"] = name
                s["window_id"] = os.environ.get("WINDOWID") and int(os.environ["WINDOWID"]) or s["window_id"]
                data["source"] = "sim"
                s["activity"] = "Session started"
                set_status(s, "idle", "Session started")
            else:
                apply_event(s, ev, data)
            save_session(s)
        ping_daemon(sid)
        print(f"{sid}: {ev}")

    cmd = args[0]
    if cmd == "stop":
        for pf in sim_dir.glob("*.pid"):
            try:
                os.kill(int(pf.read_text()), signal.SIGTERM)
            except (OSError, ValueError):
                pass
            pf.unlink()
        for sid in list(all_sessions()):
            if sid.startswith("sim-"):
                delete_session(sid)
                try:
                    daemon_request({"op": "drop", "id": sid})
                except OSError:
                    pass
        print("fake sessions removed")
        return 0
    if len(args) < 2:
        print(usage)
        return 1
    name = re.sub(r"[^A-Za-z0-9_-]", "", args[1]) or "demo"
    events = {
        "start": ("SessionStart", {"source": "startup"}),
        "prompt": ("UserPromptSubmit", {}),
        "tool": ("PreToolUse", {"tool_name": "Edit", "tool_input": {"file_path": "/x/app.tsx"}, "tool_use_id": "t1"}),
        "bash": ("PreToolUse", {"tool_name": "Bash", "tool_input": {"description": "Run tests"}, "tool_use_id": "t2"}),
        "tooldone": ("PostToolUse", {"tool_name": "Edit", "tool_use_id": "t1"}),
        "permission": ("PermissionRequest", {"tool_name": "Bash", "tool_use_id": "t2"}),
        "ask": ("PreToolUse", {"tool_name": "AskUserQuestion", "tool_input": {}, "tool_use_id": "t3"}),
        "answered": ("PostToolUse", {"tool_name": "AskUserQuestion", "tool_use_id": "t3"}),
        "done": ("Stop", {"stop_hook_active": False}),
        "end": ("SessionEnd", {"reason": "other"}),
    }
    if cmd not in events:
        print(usage)
        return 1
    ev, extra = events[cmd]
    fake(name, ev, extra)
    return 0


def main(argv=None):
    argv = list(sys.argv[1:] if argv is None else argv)
    cmd = argv[0] if argv else "help"
    if cmd == "hook":
        return cmd_hook()
    if cmd == "start":
        return cmd_start()
    if cmd == "ensure":
        return cmd_ensure()
    if cmd == "stop":
        return systemctl("stop", SERVICE, check=True).returncode
    if cmd == "restart":
        systemctl("reset-failed", SERVICE)
        return systemctl("restart", SERVICE, check=True).returncode
    if cmd == "reload":
        return cmd_reload()
    if cmd == "status":
        return cmd_status()
    if cmd == "logs":
        os.execvp("journalctl", ["journalctl", "--user", "-u", SERVICE, "-f", "-n", "100"])
    if cmd == "stream":
        return cmd_stream()
    if cmd == "focus":
        return 0 if len(argv) > 1 and focus_session(argv[1]) else 1
    if cmd == "capture":
        return cmd_capture(argv[1:])
    if cmd == "note":
        return cmd_note()
    if cmd == "pick":
        return cmd_pick()
    if cmd == "copy":
        return cmd_copy(argv[1]) if len(argv) > 1 and SID_RE.match(argv[1]) else 1
    if cmd in ("toggle", "delete"):
        return cmd_capture_edit(cmd, argv[1]) if len(argv) > 1 and SID_RE.match(argv[1]) else 1
    if cmd == "captures":
        return cmd_captures(argv[1:])
    if cmd == "dismiss":
        return 0 if len(argv) > 1 and dismiss_session(argv[1]) else 1
    if cmd == "raise":
        try:
            daemon_request({"op": "raise"})
            return 0
        except OSError:
            return 1
    if cmd == "install-hooks":
        return cmd_install_hooks()
    if cmd == "uninstall-hooks":
        return cmd_install_hooks(remove=True)
    if cmd == "simulate":
        return cmd_simulate(argv[1:])
    if cmd == "generate":
        generate_eww_config(load_config())
        print(f"generated eww config in {EWW_DIR}")
        return 0
    if cmd in ("version", "--version"):
        print(f"{APP} {VERSION}")
        return 0
    print(__doc__)
    return 0 if cmd in ("help", "-h", "--help") else 1


if __name__ == "__main__":
    sys.exit(main())
