#!/usr/bin/env bash
set -euo pipefail

REPO="https://raw.githubusercontent.com/Spacehat123/Kitty-Frosted-Glass/main"
KITTY_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kitty"
HYPR_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
KITTY_CONFIG="$KITTY_DIR/kitty.conf"
HYPR_MAIN="$HYPR_DIR/hyprland.conf"
HYPR_EXTRA="$HYPR_DIR/kitty-frosted-glass.conf"
HYPR_LUA="$HYPR_DIR/(Extra only)Hyprland.lua"

for tool in curl install; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "Missing required command: $tool" >&2
        exit 1
    fi
done

tmp_dir="$(mktemp -d)"
cleanup() { rm -rf "$tmp_dir"; }
trap cleanup EXIT

fetch() {
    curl --fail --location --silent --show-error "$REPO/$1" --output "$tmp_dir/$2"
}

fetch kitty.conf kitty.conf
fetch '(Extras%20only)Hyprland.conf' hyprland.conf
fetch '(Extra%20only)Hyprland.lua' hyprland.lua

mkdir -p "$KITTY_DIR" "$HYPR_DIR"

install_if_missing() {
    local source="$1" destination="$2"
    if [[ -e "$destination" ]]; then
        echo "Keeping your existing $destination"
    else
        install -m 644 "$source" "$destination"
        echo "Installed $destination"
    fi
}

install_if_missing "$tmp_dir/kitty.conf" "$KITTY_CONFIG"
install_if_missing "$tmp_dir/hyprland.conf" "$HYPR_EXTRA"
install_if_missing "$tmp_dir/hyprland.lua" "$HYPR_LUA"

# Hyprland's normal config is hyprland.conf. Back it up before adding our
# source line, and only add the line once. Existing user settings stay intact.
mkdir -p "$HYPR_DIR"
touch "$HYPR_MAIN"
SOURCE_LINE="source = $HYPR_EXTRA"
if ! grep -Fqx "$SOURCE_LINE" "$HYPR_MAIN"; then
    cp -p "$HYPR_MAIN" "$HYPR_MAIN.kitty-frosted-glass-backup"
    printf '\n# Kitty Frosted Glass extra\n%s\n' "$SOURCE_LINE" >> "$HYPR_MAIN"
    echo "Added the frosted-glass config to $HYPR_MAIN"
else
    echo "Frosted-glass config is already sourced by $HYPR_MAIN"
fi

echo
echo "All done. Kitty and Hyprland configs are in place."
echo "Reload Kitty with Ctrl+Shift+F5 and reload Hyprland with hyprctl reload."
echo "The Lua file is installed as an optional extra; it is not automatically loaded by standard Hyprland."
