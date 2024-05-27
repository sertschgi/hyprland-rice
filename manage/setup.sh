#!/usr/bin/env bash

source "$HOME/.config/hypr/lib.sh"

abort_on_existing () {
    fail_msg="Found existing file/directory, aborting... ($1)"

    if [[ -d "$1" ]]; then
        echo "$fail_msg"

        exit 1
    fi

    if [[ -f "$1" ]]; then
        echo "$fail_msg"

        exit 1
    fi
}

verify_dir () {
    [[ -d "$1" ]] || mkdir -p "$1"
}

# Verify availability for configuration.
abort_on_existing "$HOME/.config/hypr"

for i in ${symlinks[@]}; do
    check_path="$(echo "$i" | cut -f2 -d ':')"

    abort_on_existing "$check_path"
done

verify_dir "$HOME/.config"
cd "$HOME/.config"
if git clone https://gitlab.com/Oglo12/hyprland-rice.git hypr; then
    echo "Downloaded Hyprland configuration!"
else
    echo "Failed to download Hyprland configuration!"

    exit 1
fi

cd "$HOME"

for i in ${symlinks[@]}; do
    l_name="$(echo "$i" | cut -f1 -d ':')"
    real_path="$HOME/.config/hypr/symlinks/${l_name}"
    symlink_path="$(echo "$i" | cut -f2 -d ':')"

    echo "Symlinking '${l_name}' to: '${symlink_path}'"

    if ln -s "$real_path" "$symlink_path"; then
        echo "Successfully symlinked: '${l_name}'"
    else
        echo "Failed to symlink: '${l_name}'"

        exit 1
    fi
done

cd "$HOME"

echo "Installing Nerd Fonts..."

nerd_font="JetBrainsMono"
nerd_font_version="3.0.1"

mkdir -p $HOME/.fonts
cd $HOME/.fonts

wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v${nerd_font_version}/${nerd_font}.zip"

unzip "${nerd_font}.zip"

rm OFL.txt
rm readme.md
rm "${nerd_font}.zip"

fc-cache

echo " "

cd "$HOME"

echo "Done!"
