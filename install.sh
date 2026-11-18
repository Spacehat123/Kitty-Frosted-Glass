#!/usr/bin/env bash
set -Eeuo pipefail

REPO_URL="https://raw.githubusercontent.com/Spacehat123/Kitty-Frosted-Glass/main"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
KITTY_DIR="$CONFIG_HOME/kitty"
HYPR_DIR="$CONFIG_HOME/hypr"
KITTY_DEST="$KITTY_DIR/kitty.conf"
HYPR_LUA="$HYPR_DIR/hyprland.lua"
BEGIN_MARKER="-- >>> Kitty Frosted Glass: managed block >>>"
END_MARKER="-- <<< Kitty Frosted Glass: managed block <<<"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf -- "$TMP_DIR"; }
trap cleanup EXIT

for command_name in curl install cp mv awk grep date mkdir chmod; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        printf 'Error: required command not found: %s\n' "$command_name" >&2
        exit 1
    fi
done

# Prefer files beside this installer (cloned/downloaded repository); otherwise
# fetch the two required files from the repository's main branch.
get_file() {
    local repo_file="$1"
    local output_name="$2"
    local local_file="$SCRIPT_DIR/$repo_file"
    if [[ -f "$local_file" ]]; then
        cp -- "$local_file" "$TMP_DIR/$output_name"
    else
        local encoded_path
        case "$repo_file" in
            "(Extra only)Hyprland.lua") encoded_path="%28Extra%20only%29Hyprland.lua" ;;
            *) encoded_path="$repo_file" ;;
        esac
        curl --fail --location --silent --show-error \
            "$REPO_URL/$encoded_path" --output "$TMP_DIR/$output_name"
    fi
    [[ -s "$TMP_DIR/$output_name" ]] || {
        printf 'Error: downloaded/source file is empty: %s\n' "$repo_file" >&2
        exit 1
    }
}

get_file "kitty.conf" "kitty.conf"
get_file "(Extra only)Hyprland.lua" "hyprland-extra.lua"

if [[ ! -f "$HYPR_LUA" ]]; then
    printf 'Error: %s does not exist.\n' "$HYPR_LUA" >&2
    printf 'This installer appends to your existing Lua entry point; it will not create or replace one.\n' >&2
    exit 1
fi

mkdir -p -- "$KITTY_DIR" "$HYPR_DIR"
backup_file() {
    local path="$1"
    if [[ -e "$path" ]]; then
        local backup="${path}.kitty-frosted-glass-backup.$(date +%Y%m%d-%H%M%S)-$$"
        cp -p -- "$path" "$backup"
        printf 'Backup created: %s\n' "$backup"
    fi
}

# Validate that the managed Lua markers are either both absent or both present
# before changing either destination.
begin_count="$(grep -Fxc -- "$BEGIN_MARKER" "$HYPR_LUA" || true)"
end_count="$(grep -Fxc -- "$END_MARKER" "$HYPR_LUA" || true)"
if [[ "$begin_count" != "$end_count" ]] || [[ "$begin_count" -gt 1 ]]; then
    printf 'Error: managed block markers in %s are incomplete or duplicated.\n' "$HYPR_LUA" >&2
    printf 'No files were changed. Repair/remove the old marker block and rerun.\n' >&2
    exit 1
fi

# Install Kitty's supplied config. Preserve any pre-existing user config first.
backup_file "$KITTY_DEST"
install -m 644 -- "$TMP_DIR/kitty.conf" "$TMP_DIR/kitty.conf.new"
mv -f -- "$TMP_DIR/kitty.conf.new" "$KITTY_DEST"
printf 'Installed Kitty config: %s\n' "$KITTY_DEST"

# Preserve the user's Lua config while replacing only this installer's block.
if [[ "$begin_count" == "1" ]]; then
    awk -v begin="$BEGIN_MARKER" -v end="$END_MARKER" '
        $0 == begin { skip=1; next }
        $0 == end { skip=0; next }
        !skip { print }
    ' "$HYPR_LUA" > "$TMP_DIR/hyprland.lua.base"
else
    cp -- "$HYPR_LUA" "$TMP_DIR/hyprland.lua.base"
fi

backup_file "$HYPR_LUA"
{
    cat "$TMP_DIR/hyprland.lua.base"
    printf '\n%s\n' "$BEGIN_MARKER"
    cat "$TMP_DIR/hyprland-extra.lua"
    printf '\n%s\n' "$END_MARKER"
} > "$TMP_DIR/hyprland.lua.new"

# Keep the original file's mode where possible; default to 0644 otherwise.
chmod_mode="644"
if command -v stat >/dev/null 2>&1; then
    existing_mode="$(stat -c '%a' "$HYPR_LUA" 2>/dev/null || true)"
    [[ -n "$existing_mode" ]] && chmod_mode="$existing_mode"
fi
install -m "$chmod_mode" -- "$TMP_DIR/hyprland.lua.new" "$TMP_DIR/hyprland.lua.installed"
mv -f -- "$TMP_DIR/hyprland.lua.installed" "$HYPR_LUA"
printf 'Updated Lua config: %s\n' "$HYPR_LUA"

cat <<MSG

Kitty Frosted Glass installed.
- Kitty config: $KITTY_DEST
- Hyprland Lua: $HYPR_LUA
- No hyprland.conf changes were made.

Reload Kitty with Ctrl+Shift+F5 (or restart it).
Reload Hyprland with: hyprctl reload

Existing configs were backed up before replacement/modification.
MSG
