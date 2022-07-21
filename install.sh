#!/bin/bash

STOW_FOLDERS="ag,general,commitizen,tmux,configs,zsh,git,powerlevel10k"

DOT_FILES=$HOME/dotfiles

pushd $DOT_FILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
   stow -D $folder
   stow $folder
done
popd
