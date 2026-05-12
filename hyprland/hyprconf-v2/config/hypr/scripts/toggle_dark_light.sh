#!/usr/bin/env bash

# Toggle GNOME color-scheme between prefer-dark and prefer-light when available.

if ! command -v gsettings &>/dev/null; then
    notify-send "Theme" "gsettings not found. Skipping toggle." &>/dev/null
    exit 0
fi

schema="org.gnome.desktop.interface"
key="color-scheme"
current=$(gsettings get "$schema" "$key" 2>/dev/null)

if [[ "$current" == "'prefer-dark'" ]]; then
    gsettings set "$schema" "$key" 'prefer-light'
    notify-send "Theme" "Switched to light" &>/dev/null
else
    gsettings set "$schema" "$key" 'prefer-dark'
    notify-send "Theme" "Switched to dark" &>/dev/null
fi
