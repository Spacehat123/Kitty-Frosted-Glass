# Kitty Frosted Glass

A frosted-glass Kitty terminal setup with a midnight palette, transparent windows, and Hyprland blur.

## Install

This installer is designed for a setup that already uses a Lua entry point at `~/.config/hypr/hyprland.lua` (or `$XDG_CONFIG_HOME/hypr/hyprland.lua`). It:

1. Installs this repository's `kitty.conf` to `~/.config/kitty/kitty.conf`.
2. Appends the Hyprland Lua extra to your existing `hyprland.lua` inside a clearly marked managed block.
3. Updates that managed block on subsequent runs instead of appending duplicates.
4. Makes timestamped backups of any existing Kitty config and the Lua config before changing them.
5. Does not modify `hyprland.conf`.

Run from a cloned/downloaded copy of this repository:

```bash
chmod +x install.sh
./install.sh
```

Or download and run the installer:

```bash
curl -fsSL https://raw.githubusercontent.com/Spacehat123/Kitty-Frosted-Glass/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

**Important:** `~/.config/hypr/hyprland.lua` must already exist and be the Lua configuration file loaded by your Hyprland setup. The installer deliberately refuses to create or replace it. If your Lua entry point is elsewhere or has another name, edit `HYPR_LUA` near the top of `install.sh` before running it.

After installation:

- Reload Kitty with `Ctrl+Shift+F5` or restart Kitty.
- Reload Hyprland with `hyprctl reload`.

## What's included

- `kitty.conf` — midnight colors, transparency, padding, tabs, keybindings, and shell integration.
- `(Extra only)Hyprland.lua` — Lua fragment for global blur and Kitty-specific rounded borders.
- `install.sh` — installer that copies the Kitty config and merges the Lua fragment into the existing Lua entry point.

The intended font is JetBrainsMono Nerd Font. Install it on Arch Linux with:

```bash
sudo pacman -S ttf-jetbrains-mono-nerd
```

The Kitty config selects Fish at `/usr/bin/fish`; edit that setting if Fish is installed elsewhere or you use another shell.

## Backups and reinstallation

Existing files are backed up alongside the originals with a suffix like `.kitty-frosted-glass-backup.YYYYMMDD-HHMMSS`. The Lua fragment is surrounded by `Kitty Frosted Glass: managed block` markers. Re-running the installer replaces only that marked block and preserves the rest of your Lua configuration.

The installer does not install Hyprland, Kitty, fonts, or a Lua configuration framework. It assumes your Hyprland Lua setup already provides the `hl` API used by the fragment.
