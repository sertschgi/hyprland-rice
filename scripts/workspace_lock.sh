#!/usr/bin/env bash

lock_file="/tmp/hyprland_rice_workspace_lock"

get_workspace () {
    hyprctl activeworkspace | head --lines 1 | cut -f3 -d ' '
}

workspace="$(get_workspace)"

[[ "$2" == "" ]] || workspace="$2"

if [[ "$1" == "lock" ]]; then
    notify-send -et 1000 'Locking workspace...' "Workspace ${workspace} is being locked."
    echo "${workspace}" > "${lock_file}"
elif [[ "$1" == "unlock" ]]; then
    notify-send -et 1000 'Unlocking workspace...' 'Workspace is now unlocked.'
    rm "${lock_file}"
elif [[ "$1" == "get" ]]; then
    if [[ -f "${lock_file}" ]]; then
        cat "${lock_file}"
    else
        exit 1
    fi
else
    exit 1
fi
