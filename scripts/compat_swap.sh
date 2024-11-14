#!/usr/bin/env bash

# This script is responsible for swapping out parts of the rice configuration
# so that the configuration can bridge over many different Hyprland versions
# all with breaking changes.

source ~/.config/hypr/lib.sh

die () {
    echo -e "[ FATAL ]: $1" >&2

    exit 1
}

compat_dirs="$HOME/.config/hypr/compat_files"

latest_compat_dir () {
    father_ver=$(find "$compat_dirs"/* -maxdepth 0 | xargs -I {} basename {} | cut -f1 -d '.' | sort -nr | head --lines 1)
    major_ver=$(find "$compat_dirs"/${father_ver}.* -maxdepth 0 | xargs -I {} basename {} | cut -f2 -d '.' | sort -nr | head --lines 1)

    echo "${father_ver}.${major_ver}"
}

# Subcommand handling.
if [[ "$1" == "latest-compat" ]]; then
    echo "v$(latest_compat_dir)"

    exit 0
fi

# This variable is a constant. If this is changed, there are more places that need to be changed too.
tmp_dir="/tmp/oglo-hyprland-rice-compat-files"

# Setup
[[ -d "$tmp_dir" ]] && rm -rf "$tmp_dir"
[[ -d "$tmp_dir" ]] && die "Failed to remove old temporary directory! ('${tmp_dir}')"
mkdir -p "$tmp_dir" || die "Failed to create temporary directory! ('${tmp_dir}')"

hyprland_ver="$(hyprland_version)"
hyprland_ver_major="$(hyprland_version | sed 's/\..$//')"

compat_dir="$compat_dirs/${hyprland_ver_major}"

echo -en "\n"

if [[ -d "$compat_dir" ]]; then
    echo "Found existing compatibility directory! (No further searching required...)"
else
    echo "Could not find compatibility directory... searching for latest to use as fallback..."

    latest_compat="$(latest_compat_dir)"

    compat_dir="$compat_dirs/${latest_compat}"

    echo "  v${hyprland_ver_major} -> v${latest_compat}"
fi

echo -e "\nPerforming compatibility swap..."
echo -e "  Hyprland Version: ${hyprland_ver}"
echo -e "  Hyprland Major Version: ${hyprland_ver_major}"
echo -e "Target is the major version...\n"

conf_compat_file="$compat_dir/hyprland_compat.conf"

if [[ -f "$conf_compat_file" ]]; then
    cp "$conf_compat_file" "$tmp_dir" || die "Failed to copy Hyprland configuration compatibility file!"
else
    die "Missing Hyprland configuration compatibility file! ('${conf_compat_file}')"
fi

echo -e "Hyprland rice compatibility swap completed successfully! (Target: v${hyprland_ver_major})\n"
