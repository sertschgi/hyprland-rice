#!/usr/bin/env bash

cd ~

prev_custom_conf_sha512sum=""

while [[ 1 == 1 ]]; do
  # Volume cap.
  if [[ -f ~/.hyprland_rice/disable_vol_cap ]]; then
    echo "Volume cap disabled."
  else
    cd ~/.config/hypr/eww

    if [[ $(./scripts/get_output_volume) -gt 100 ]]; then
      ./scripts/set_output_volume 100%
    fi

    cd ~
  fi

  # Restart Waybar if it crashes.
  pgrep waybar > /dev/null 2>&1 || $HOME/.config/hypr/waybar/start

  # Kill newest Waybar instance if there is more than one.
  if [[ $(pgrep waybar | wc -l) -gt 1 ]]; then
    pkill -n waybar
  fi

  chmod +x ~/.hyprland_rice/loop
  ~/.hyprland_rice/loop

  [[ -f ~/.hyprland_rice/custom.conf ]] || cp ~/.config/hypr/custom_template.conf ~/.hyprland_rice/custom.conf

  prev_custom_conf_check="$prev_custom_conf_sha512sum"
  custom_conf_sha512sum="$(sha512sum ~/.hyprland_rice/custom.conf)"

  [[ "$prev_custom_conf_sha512sum" == "" ]] && prev_custom_conf_check="$custom_conf_sha512sum"

  if [[ "$prev_custom_conf_check" != "$custom_conf_sha512sum" ]]; then
    notify-send "Reloading Hyprland..." "The custom configuration file has changed..."

    hyprctl reload
  fi

  prev_custom_conf_sha512sum="$custom_conf_sha512sum"

  # Reset and sleep.
  cd ~
  sleep 1
done
