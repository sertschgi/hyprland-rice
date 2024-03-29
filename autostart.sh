#!/usr/bin/env bash



source ~/.config/hypr/lib.sh



run_hook pre &

[[ -d ~/.hyprland_rice ]] || mkdir ~/.hyprland_rice
[[ -d ~/.cache/hyprland_rice ]] || mkdir ~/.cache/hyprland_rice

[[ -f ~/.hyprland_rice/themes.txt ]] || touch ~/.hyprland_rice/themes.txt

~/.config/hypr/scripts/load_brightness.sh &

rm -rf ~/.cache/swww > /dev/null 2>&1

swww init

swww img ~/.config/hypr/screen_pics/starting_rice.png -t none

[[ -f ~/.cache/hyprland_rice/theme_refreshed ]] || ~/.config/hypr/manage/refresh_theme.sh

if [[ -f ~/.cache/hyprland_rice/theme_refresh_id.txt ]]; then
  theme_refresh_id_old=$(cat ~/.cache/hyprland_rice/theme_refresh_id.txt)
  theme_refresh_id=$(cat ~/.config/hypr/templates/refresh_id)

  theme_path="$HOME/.config/hypr/themes/gruvbox_dark"

  if [[ -f ~/.cache/hyprland_rice/theme_path.txt ]]; then
    theme_path="$(cat $HOME/.cache/hyprland_rice/theme_path.txt)"
  fi

  [[ $theme_refresh_id == $theme_refresh_id_old ]] || ~/.config/hypr/scripts/change_theme.sh "$theme_path"
else
  theme_path="$HOME/.config/hypr/themes/gruvbox_dark"

  [[ $theme_refresh_id == $theme_refresh_id_old ]] || ~/.config/hypr/scripts/change_theme.sh "$theme_path"
fi

set_wallpaper ~/.cache/hyprland_rice/theme/wallpaper.png

~/.config/hypr/waybar/start
~/.config/hypr/swaync/start
~/.config/hypr/eww/start

nm-applet &
blueman-applet &

lxsession &

hypridle &

eval "sleep 2; hyprctl reload" &

eval "sleep 0.5; killall flameshot; pkill flameshot" &
eval "sleep 1; killall flameshot; pkill flameshot" &
eval "sleep 2; killall flameshot; pkill flameshot" &

run_hook post &
