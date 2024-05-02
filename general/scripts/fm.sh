#!/bin/bash

# List all directories in the home directory up to 5 levels deep and pass them through dmenu for fuzzy search
selected_folder=$(find "$HOME" -not -path '*/.*' -mindepth 1 -maxdepth 5 -type d 2>/dev/null | dmenu -fn 'Anonymous Pro-16' -h 26 -nb '#a31002' -nf white -sb red -sf white -i -l 10 -p "Open directory: ")

# Open the selected folder using Thunar
if [ -n "$selected_folder" ]; then
	thunar "$selected_folder"
fi
