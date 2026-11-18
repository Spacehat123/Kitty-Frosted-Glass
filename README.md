# Kitty Froste... Glass? ﹏

A frosted-glass Kitty terminal setup with a sleepy midnight palette, transparent windows, and just enough blur to look *almost* futuristic.

## Easy install

On Linux, with Kitty and Hyprland installed, download this repo and run the installer:

```bash
curl -fsSL https://raw.githubusercontent.com/Spacehat123/Kitty-Frosted-Glass/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

The installer creates `kitty.conf` and the Hyprland extra only if they don't already exist. It backs up your `hyprland.conf` before adding a `source` line, and won't overwrite your existing Kitty or Hyprland configs. You can also download `install.sh` and run it from your file manager/terminal.

The optional `(Extra only)Hyprland.lua` is copied into your Hyprland config folder if missing. It is not automatically loaded: standard Hyprland uses `hyprland.conf`, so the installer connects the native config extra instead.

## What's in here

- `kitty.conf` — midnight colors, transparency, comfy padding, tabs, keybinds, and more
- `(Extras only)Hyprland.conf` — blur, rounded corners, borders, shadows, and animations
- `(Extra only)Hyprland.lua` — an optional extra for setups that already load that Lua config format
- `install.sh` — the one-file installer

You'll want JetBrainsMono Nerd Font for the intended look. The Kitty config also uses Fish at `/usr/bin/fish`; edit that line in `kitty.conf` if Fish lives somewhere else (or you use a different shell).

After installing, reload Kitty with `Ctrl+Shift+F5` and Hyprland with `hyprctl reload`.

## Heads-up

This config uses newer Hyprland options such as `rounding_power`, blur vibrancy, and `resize_on_border`; compatibility depends on your Hyprland version. The installer does not replace existing configs, so if you already have one, the new Kitty settings won't be applied automatically. Backups of `hyprland.conf` are saved as `hyprland.conf.kitty-frosted-glass-backup` when the installer adds its source line.

No license file yet, so ask before assuming you can do whatever with it.
