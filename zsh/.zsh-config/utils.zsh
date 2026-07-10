# service() {
#   systemctl $2 $1
# }

get_pod_node_architecture() {
    local NAMESPACE="$1"

    for POD in $(kubectl get pods -n $NAMESPACE -o=jsonpath='{.items[*].metadata.name}'); do
        NODE=$(kubectl get pod $POD -n $NAMESPACE -o=jsonpath='{.spec.nodeName}')
        ARCH=$(kubectl get node $NODE -o=jsonpath='{.status.nodeInfo.architecture}')
        echo "Pod: $POD - Node: $NODE - Architecture: $ARCH"
    done
}

get_namespace_logs() {
    local NAMESPACE="$1"
    local LINES="$2"

    for POD in $(kubectl get pods -n $NAMESPACE -o=jsonpath='{.items[*].metadata.name}'); do
      echo "Logs for Pod: $POD"
      kubectl logs --tail=$LINES -n $NAMESPACE $POD
      echo "------------------------"
    done
}


# Ref: https://polothy.github.io/post/2019-08-19-fzf-git-checkout/
fzf-git-branch() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    git branch --color=always --all --sort=-committerdate |
        grep -v HEAD |
        fzf --height 50% --ansi --no-multi --preview-window right:65% \
            --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}

fzf-git-checkout() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    local branch

    branch=$(fzf-git-branch)
    if [[ "$branch" = "" ]]; then
        echo "No branch selected."
        return
    fi

    # If branch name starts with 'remotes/' then it is a remote branch. By
    # using --track and a remote branch name, it is the same as:
    # git checkout -b branchName --track origin/branchName
    if [[ "$branch" = 'remotes/'* ]]; then
        git checkout --track $branch
    else
        git checkout $branch;
    fi
}

# Ref: https://bezhermoso.github.io/2018/07/28/jump-back-up-to-git-repo-root-directory/
function jump-to-git-root {
  local _root_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [[ $? -gt 0 ]]; then
    >&2 echo 'Not a Git repo!'
    exit 1
  fi
  local _pwd=$(pwd)
  if [[ $_pwd = $_root_dir ]]; then
    # Handle submodules:
    # If parent dir is also managed under Git then we are in a submodule.
    # If so, cd to nearest Git parent project.
    _root_dir="$(git -C $(dirname $_pwd) rev-parse --show-toplevel 2>/dev/null)"
    if [[ $? -gt 0 ]]; then
      echo "Already at Git repo root."
      return 0
    fi
  fi
  # Make `cd -` work.
  OLDPWD=$_pwd
  echo "Git repo root: $_root_dir"
  cd $_root_dir
}

dl-music() {
  local _path="~/Music/desktop-music/$1/%(title)s.%(ext)s"
  echo "Downloading youtube video to $_path"
  youtube-dl -o $_path -x --audio-format mp3 $2
}

push-bashrc() {
  if [[ "$2" != "" ]]; then
    local _alias=":($2)"
  fi
  echo "export PS1=\"\\\u@\\h$_alias "\\W\$\""" | ssh $1 'mkdir -p .jtonga && cat > .jtonga/bashrc'
}

ghpr() {
  GH_FORCE_TTY=100% gh pr list | fzf --ansi --preview 'GH_FORCE_TTY=100% gh pr view {1}' --preview-window down --header-lines 3 | awk '{print $1}' | xargs gh pr checkout
}

conv-mp4-to-mp3() {
  if [[ -z "$1" ]]; then
    echo "provide source as 1st argument"
    exit 1
  fi

  if [[ -z "$2" ]]; then
    echo "provide dest as 2nd argument"
    exit 1
  fi
  ffmpeg -i $1 -vn -acodec libmp3lame -ac 2 -ab 160k -ar 48000 $2
}

watch-api() {
  if [[ -z "$1" ]]; then
    echo "provide url as 1st argument"
    exit 1
  fi

  sleepTimer="${2:-1}"

  echo "URL: $1"
  echo "Interval: ${sleepTimer}s"

  while true; do
    echo "$(date) - code: $(curl -s -o /dev/null -w "%{http_code}" $1 -m $sleepTimer)"; sleep $sleepTimer;
  done
}

y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

mkproj() {
  local name="$*"
  # local date_prefix
  # date_prefix=$(date +%m-%d)  # mm-dd format
  # date_prefix=$(date +%F) # yyyy-mm-dd
  # local year=$(date +%Y)  # Get the year

  local dir="$HOME/projects/${name// /-}"
  mkdir -p "$dir"

  echo "# Notes for $name" > "$dir/notes.md"
  touch "$dir/scratch.md"

  echo "created project folder $dir"
}

# Switch BROWSER (and xdg default) between firefox and chrome.
# Persists to a state file read by .zshrc so new shells pick it up.
browser() {
  if [[ "$OSTYPE" == darwin* ]]; then
    echo "browser: linux only (mac uses system default)"
    return 1
  fi

  local state_file="$HOME/.local/state/browser"
  local bin desktop

  case "$1" in
    firefox) bin=firefox-developer-edition; desktop=firefox-developer-edition.desktop ;;
    chrome)  bin=google-chrome-stable;      desktop=google-chrome.desktop ;;
    "")
      echo "BROWSER=$BROWSER"
      echo "xdg default: $(env -u BROWSER xdg-settings get default-web-browser)"
      return
      ;;
    *) echo "usage: browser [firefox|chrome]"; return 1 ;;
  esac

  mkdir -p "${state_file:h}"
  echo "$bin" > "$state_file"
  export BROWSER="$bin"
  # xdg-settings refuses to write (and reads back) $BROWSER when it's set
  env -u BROWSER xdg-settings set default-web-browser "$desktop"
  echo "BROWSER=$BROWSER (xdg default: $desktop)"
}

fcerts() {
  local file
  file=$(find . -maxdepth 2 -type f \( -name '*.crt' -o -name '*.pem' \) | fzf \
    --preview 'openssl x509 -in {} -noout -text 2>/dev/null || openssl req -in {} -noout -text 2>/dev/null || cat {}' \
    --preview-window=right:70%:wrap) || return

  [ -z "$file" ] && return

  ( openssl x509 -in "$file" -noout -text 2>/dev/null \
    || openssl req -in "$file" -noout -text 2>/dev/null \
    || cat "$file" ) | xclip -selection clipboard -in

  echo "Copied openssl output for: $file"
}
