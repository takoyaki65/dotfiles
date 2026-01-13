#!/bin/bash

set -e

echo "Detecting display server..."

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    echo "Wayland detected (XDG_SESSION_TYPE), installing wl-clipboard..."
    sudo apt install -y wl-clipboard
elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
    echo "X11 detected (XDG_SESSION_TYPE), installing xclip..."
    sudo apt install -y xclip
elif pgrep -x "gnome-shell" > /dev/null && [ -n "$WAYLAND_DISPLAY" ]; then
    echo "Wayland detected (WAYLAND_DISPLAY), installing wl-clipboard..."
    sudo apt install -y wl-clipboard
elif pgrep -f "wayland" > /dev/null; then
    echo "Wayland detected (process), installing wl-clipboard..."
    sudo apt install -y wl-clipboard
elif [ -n "$DISPLAY" ]; then
    echo "X11 detected (DISPLAY), installing xclip..."
    sudo apt install -y xclip
else
    echo "Could not detect display server, installing both..."
    sudo apt install -y xclip wl-clipboard
fi

echo "Clipboard provider installation complete!"
