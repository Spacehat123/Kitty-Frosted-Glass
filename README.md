# Kitty Froste... Glass? ﹏

A frosted-glass Kitty terminal setup with a sleepy midnight palette, transparent windows, and just enough blur to make it look *almost* futuristic.

Also includes an optional Hyprland config for anyone on a slightly stronger Linux setup (Hyprland enjoyers, assemble).

## What this does

- Makes Kitty translucent with `background_opacity 0.5`
- Gives the terminal a midnight-purple color scheme
- Adds rounded Kitty windows and blur with the Hyprland Lua config
- Uses JetBrains Mono Nerd Font
- Starts Fish in the terminal
- Adds comfy padding, top tabs, and a scrollback of 20,000 lines
- Includes keyboard shortcuts for tabs, windows, copying, pasting, and font size

## Files

- `kitty.conf` — the main Kitty configuration
- `(Extra only)Hyprland.lua` — optional extra blur and window rules for Hyprland

## Install

Back up whatever Kitty currently has going on:

```bash
cp ~/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf.backup
```

Then copy this config:

```bash
mkdir -p ~/.config/kitty
cp kitty.conf ~/.config/kitty/kitty.conf
```

Restart Kitty or reload the config with:

```text
Ctrl+Shift+F5
```

## Optional: Hyprland extra

This repo's Lua file is **extra only**. It enables Hyprland blur and applies a frosted treatment specifically to windows named `kitty`.

Where you place it depends on your Hyprland setup, but it should generally live somewhere your Hyprland Lua configuration loads.

Keep the Kitty config too — they do different jobs:

- Kitty handles the terminal appearance
- Hyprland handles compositor blur and window decoration

## You'll probably want these

- [Kitty](https://sw.kovidgoyal.net/kitty/) terminal
- [Fish](https://fishshell.com/) shell
- [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads)
- Hyprland, if using `(Extra only)Hyprland.lua`

## Little notes

- The shell path is `/usr/bin/fish`, so change it if Fish lives elsewhere.
- The blur in the Lua file needs compositor support.
- Dynamic opacity is enabled, so Kitty can be transparent when the mood strikes.

## License

No license file has been added yet. If you want to let people freely reuse, modify, or share this theme, consider adding one.
