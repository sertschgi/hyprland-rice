#!/usr/bin/env bash

if [[ -f ~/.hyprland_rice/fs_man ]]; then
    ~/.hyprland_rice/fs_man && exit 0 || exit 1
fi

thunar || pcmanfm || nemo || exit 1
