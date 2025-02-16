#!/usr/bin/env bash

source ~/.config/hypr/lib.sh

swaync-client -rs > /dev/null 2>&1

~/.config/hypr/waybar/start > /dev/null 2>&1
~/.config/hypr/eww/start > /dev/null 2>&1

set_wallpaper_themed

hyprctl reload > /dev/null
