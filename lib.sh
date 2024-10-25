#!/usr/bin/env bash

cache_theme_path="$HOME/.cache/hyprland_rice/theme"

symlinks=(
    "alacritty:$HOME/.config/alacritty"
    "kitty:$HOME/.config/kitty"
    "rofi:$HOME/.config/rofi"
)

get_current_wallpaper_path () {
    file_extension="png"

    extension_path="$cache_theme_path/wallpaper_extension.txt"

    if [[ -f "$extension_path" ]]; then
        file_extension="$(cat "$extension_path")"
    fi

    echo "${cache_theme_path}/wallpaper.${file_extension}"
}

set_wallpaper () {
    swww_filter="Lanczos3"
    swww_animation="grow"

    [[ "$2" == "" ]] || swww_filter="$2"
    [[ "$3" == "" ]] || swww_animation="$3"

    echo "Setting wallpaper..."
    echo "Filter: ${swww_filter}"
    echo "Animation: ${swww_animation}"
    echo "Wallpaper Path: '$1'"

	swww img "$1" --filter "$swww_filter" -t "$swww_animation" --transition-pos center || return 1
}

set_wallpaper_themed () {
    wallpaper_animation="$1"
    wallpaper_filter="" # Empty means default. :-)

    wallpaper_info_dir_path="${cache_theme_path}/wallpaper_info"

    if [[ -d "$wallpaper_info_dir_path" ]]; then
        [[ -f "${wallpaper_info_dir_path}/filter" ]] && wallpaper_filter="$(cat "${wallpaper_info_dir_path}/filter")"
    else
        echo "Wallpaper info directory does not exist... assuming defaults..."
    fi

    set_wallpaper "$(get_current_wallpaper_path)" "$wallpaper_filter" "$wallpaper_animation"
}

run_hook () {
    chmod +x "$HOME/.hyprland_rice/autostart_$1"
    $HOME/.hyprland_rice/autostart_$1
}

eww-rice () {
	eww --config ~/.config/hypr/eww/ $*
}

abs_path () {
    new_path="$1"

    home_sed="$(echo "$HOME" | sed 's/\//\\\//g')"

    [[ "$new_path" == "~"* ]] && new_path="$(echo $new_path | sed "s/^~/$home_sed/")"

    echo "$new_path"
}
