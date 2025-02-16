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

end_compat_dir () {
    sort_flags='-n' # Earliest compat dir.

    [[ "$1" == "1" ]] && sort_flags='-nr' # Latest compat dir.

    father_ver=$(find "$compat_dirs"/* -maxdepth 0 | xargs -I {} basename {} | cut -f1 -d '.' | sort "$sort_flags" | head --lines 1)
    major_ver=$(find "$compat_dirs"/${father_ver}.* -maxdepth 0 | xargs -I {} basename {} | cut -f2 -d '.' | sort "$sort_flags" | head --lines 1)

    echo "${father_ver}.${major_ver}"
}

cmp_vers () {
    operator="$1"

    lhs="$2"
    rhs="$3"

    cmp_flags='Cyka!'

    if [[ "$operator" == '==' ]]; then
        [[ "$lhs" == "$rhs" ]] && return 0 || return 1
    elif [[ "$operator" == '!=' ]]; then
        [[ "$lhs" != "$rhs" ]] && return 0 || return 1
    elif [[ "$operator" == '>' ]]; then
        cmp_flags='-gt'
    elif [[ "$operator" == '<' ]]; then
        cmp_flags='-lt'
    elif [[ "$operator" == '>=' ]]; then
        cmp_flags='-ge'
    elif [[ "$operator" == '<=' ]]; then
        cmp_flags='-le'
    fi

    [[ "$cmp_flags" == 'Cyka!' ]] && die "There is a problem in the code! (HINT: Cyka)"

    seg_1_lhs="$(echo "$lhs" | cut -f1 -d '.')"
    seg_1_rhs="$(echo "$rhs" | cut -f1 -d '.')"

    if [[ "$seg_1_lhs" == "$seg_1_rhs" ]]; then
        seg_2_lhs="$(echo "$lhs" | cut -f2 -d '.')"
        seg_2_rhs="$(echo "$rhs" | cut -f2 -d '.')"

        eval "[[ \"${seg_2_lhs}\" ${cmp_flags} \"${seg_2_rhs}\" ]]" && return 0 || return 1
    elif eval "[[ \"${seg_1_lhs}\" ${cmp_flags} \"${seg_1_rhs}\" ]]"; then
        return 0
    else
        return 1
    fi
}

# Subcommand handling.
if [[ "$1" != "" ]]; then
    if [[ "$1" == "latest-compat" ]]; then
        echo "v$(end_compat_dir 1)"
    
        exit 0
    elif [[ "$1" == "earliest-compat" ]]; then
        echo "v$(end_compat_dir 0)"
    
        exit 0
    else
        die "Invalid subcommand!"
    fi
fi

# This variable is a constant. If this is changed, there are more places that need to be changed too.
tmp_dir="/tmp/oglo-hyprland-rice-compat-files"

# Setup
[[ -d "$tmp_dir" ]] && rm -rf "$tmp_dir"
[[ -d "$tmp_dir" ]] && die "Failed to remove old temporary directory! ('${tmp_dir}')"
mkdir -p "$tmp_dir" || die "Failed to create temporary directory! ('${tmp_dir}')"

hyprland_ver="$(hyprland_version)"
hyprland_ver_major="$(hyprland_version | sed 's/\..$//')"

needs_latest () {
    if cmp_vers '>' "$hyprland_ver_major" "$(end_compat_dir 1)"; then
        return 0
    else
        return 1
    fi
}

compat_dir="$compat_dirs/${hyprland_ver_major}"

echo -en "\n"

if [[ -d "$compat_dir" ]]; then
    echo "Found existing compatibility directory! (No further searching required...)"
else
    echo "Could not find compatibility directory... searching for closest to use as fallback..."

    closest_compat="$(end_compat_dir 1)"

    needs_latest || closest_compat="$(end_compat_dir 0)"

    compat_dir="$compat_dirs/${closest_compat}"

    echo "  v${hyprland_ver_major} -> v${closest_compat}"
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

hyprctl reload > /dev/null 2>&1
