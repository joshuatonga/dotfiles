#!/bin/bash

dnd_file="/tmp/dnd_status.txt"

check_dnd_status() {
	if [ -e "$dnd_file" ]; then
		echo "on"
	else
		echo "off"
	fi
}

toggle_dnd() {
	current_status=$(check_dnd_status)

	if [ "$current_status" == "on" ]; then
		wired --dnd off
		rm "$dnd_file"
		echo "DND is now off."
	else
		wired --dnd on
		touch "$dnd_file"
		echo "DND is now on."
	fi
}
toggle_dnd
