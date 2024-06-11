#!/bin/sh
UNIT="warp-svc.service"

if [ "$(systemctl is-active "$UNIT")" = "active" ]; then
    warp-cli registration organization
else
    exit 1
fi
