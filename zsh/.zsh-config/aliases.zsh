alias vi=$EDITOR
alias vim=$EDITOR
alias v="fd --type f --hidden --exclude .git --print0 | fzf --read0 --print0 --exit-0 | xargs -r -0 $EDITOR"
alias tldrf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'
alias vimdiff='nvim -d'

if [[ $OSTYPE == linux-gnu* ]]; then
  alias open="xdg-open"
fi

alias work=~/.tmux-startup.sh

alias p1="cd ~/paymongo/"

alias notes="vi ~/notes/"
alias pnotes="vi ~/paymongo/notes/"

alias wa="watch -n1 "

# kubernetes stuff
alias k=kubectl
alias kc="kubectx"
alias kn="kubens"
alias kt=kubetail
alias kdebug="kubectl run tmp-shell --rm -i --tty --image nicolaka/netshoot -- /bin/bash"

alias alert="afplay /System/Library/Sounds/Submarine.aiff"

alias t=tmux
alias letsgo="tmux new -s c"
alias tf=terraform
alias g=git
alias lg=lazygit
alias gb=fzf-git-branch
alias gco=fzf-git-checkout
alias gr=jump-to-git-root
alias f=fzf
alias fb=firebase

alias pc=pre-commit
alias pca="pre-commit run --all-files"

alias yt=yt-dlp
alias yt-mp3=yt-dlp -x -f bestaudio

alias vplug="vi $HOME/personal/dotfiles/configs/.config/nvim/plugs/plugins.vim"
alias aliases="vi $HOME/me/dotfiles/zsh/.zsh-config/aliases.zsh"
alias i3config="vi $HOME/me/dotfiles/i3/.config/i3/config"
alias tracker="node ~/personal/coding-tracker/src/index.js"

alias usd-php="curl -s 'https://api.exchangerate-api.com/v4/latest/USD' | jq '.rates.PHP'"

# search stuff
alias sw="s -p wikipedia"
alias saw="s -p archwiki"
alias sap="s -p archpkg"
alias ses="s -p explainshell"
alias sr="s -p reddit"
alias sreg="s -p regex"
alias ss="s -p stackoverflow"
alias sy="s -p youtube"

alias svc=service
