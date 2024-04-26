#!/bin/bash

# Use fzf to select a folder
selected_folder=$(find "$HOME" -mindepth 1 -maxdepth 5 -type d 2>/dev/null | fzf --preview-label="Last modified" --preview="stat -c '%y' {}" --preview-window=top:10%)

# Open the selected folder using Thunar
if [ -n "$selected_folder" ]; then
	thunar "$selected_folder"
fi
