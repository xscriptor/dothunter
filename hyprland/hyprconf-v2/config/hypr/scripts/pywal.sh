#!/usr/bin/env bash

# Regenerate colors using pywal when available.

if ! command -v wal &>/dev/null; then
    notify-send "Colors" "pywal (wal) not found." &>/dev/null
    exit 0
fi

wallpaper="$HOME/.config/hypr/.cache/current_wallpaper.png"

if [[ -f "$wallpaper" ]]; then
    wal -i "$wallpaper" &>/dev/null
else
    wal -R &>/dev/null
fi

if [[ -x "$HOME/.config/hypr/scripts/wallcache.sh" ]]; then
    "$HOME/.config/hypr/scripts/wallcache.sh" &>/dev/null
fi
