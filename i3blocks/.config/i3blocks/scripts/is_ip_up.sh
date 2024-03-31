#!/bin/bash

if ping -c 1 -W 1 $1 >/dev/null; then
	echo "UP"
else
	echo "DOWN"
fi
