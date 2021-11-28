#!/bin/bash

# STOW_FOLDERS="gitconfig,tmux,vim,zsh"
# STOW_FOLDERS="commitizen"
# 
# DOT_FILES=$HOME/dotfiles
# 
# pushd $DOT_FILES
# for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
# do
#     stow -D $folder
#     stow $folder
# done
# popd

stow commitizen
stow tmux
stow configs
stow zsh
stow git
