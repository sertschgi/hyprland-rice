#!/usr/bin/env bash

if [[ -f ~/.hyprland_rice/term_emu ]]; then
    ~/.hyprland_rice/term_emu && exit 0 || exit 1
fi

wezterm start || st || kitty || alacritty || exit 1
