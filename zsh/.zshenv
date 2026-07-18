# Environment shared by interactive, login, and non-interactive zsh shells.
# Keep this file fast and free of commands that print output or require a TTY.

export GOPATH="${GOPATH:-$HOME/go}"
if [[ -z ${NVM_DIR:-} ]]; then
  if [[ -n ${XDG_CONFIG_HOME:-} ]]; then
    export NVM_DIR="$XDG_CONFIG_HOME/nvm"
  else
    export NVM_DIR="$HOME/.nvm"
  fi
fi
export NVM_SYMLINK_CURRENT=true
if [[ -z ${PNPM_HOME:-} ]]; then
  if [[ -n ${XDG_DATA_HOME:-} ]]; then
    export PNPM_HOME="$XDG_DATA_HOME/pnpm"
  elif [[ $OSTYPE == darwin* ]]; then
    export PNPM_HOME="$HOME/Library/pnpm"
  else
    export PNPM_HOME="$HOME/.local/share/pnpm"
  fi
fi

# `path` is zsh's array form of PATH. Making it unique prevents duplicates when
# another startup file sources this file again.
typeset -U path PATH
path=(
  "$HOME/bin"
  "$HOME/biv"
  "$HOME/.local/bin"
  "$PNPM_HOME"
  "$HOME/.deno/bin"
  "$HOME/.cargo/bin"
  "$GOPATH/bin"
  "$HOME/scripts"
  "$HOME/.dotfiles-personal/scripts"
  "$HOME/.local/share/nvim/mason/bin"
  "$HOME/.rbenv/shims"
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /opt/homebrew/opt/influxdb@1/bin
  /home/linuxbrew/.linuxbrew/bin
  /home/linuxbrew/.linuxbrew/sbin
  /usr/local/bin
  /usr/local/go/bin
  "${KREW_ROOT:-$HOME/.krew}/bin"
  "$HOME/.ebcli-virtual-env/executables"
  "$NVM_DIR/current/bin"
  "$NVM_DIR/current/lib/node_modules/corepack/shims"
  $path
)

# NVM creates `current` after an interactive shell loads it. On a fresh machine,
# make Node/Corepack available to non-interactive app shells before that happens.
if [[ ! -d "$NVM_DIR/current/bin" ]]; then
  _nvm_node_bins=("$NVM_DIR"/versions/node/v*/bin(Nn))
  if (( ${#_nvm_node_bins} )); then
    path=(
      "${_nvm_node_bins[-1]}"
      "${_nvm_node_bins[-1]:h}/lib/node_modules/corepack/shims"
      $path
    )
  fi
  unset _nvm_node_bins
fi

export PATH
