#!/bin/sh
STATUS="$(mullvad status | head -n1)"

case "$STATUS" in
    Connected*)
        echo "$STATUS"
        ;;
    *)
        exit 1
        ;;
esac
