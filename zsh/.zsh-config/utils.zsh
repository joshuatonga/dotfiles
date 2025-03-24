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

function ranger {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
    )

    ${ranger_cmd[@]} "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}
