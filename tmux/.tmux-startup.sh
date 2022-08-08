#!/bin/sh
tmux new-session -ds 'c&c'
tmux split-window -h
tmux split-window -v 'cmus'
tmux -2 attach-session -d
