# nixos-dotfiles

NixOS + Home Manager configuration running Hyprland, shared across machines.

| Host | Machine |
|---|---|
| `oso-air` | MacBook Air M2, Asahi, aarch64 |
| `oso-pi` | Raspberry Pi 5, aarch64 |

Installing on a new machine, including adding a host of your own, is
documented in [docs/INSTALL.md](docs/INSTALL.md).

## Layout

```
flake.nix                 inputs and the mkHost helper; one call per machine
modules/common.nix        portable system config: locale, Hyprland, ly, audio, fonts, users, gc
hosts/oso-air/            MacBook Air: Asahi firmware, systemd-boot, iwd, power profiles
hosts/oso-pi/             Raspberry Pi 5: firmware partition, U-Boot, SSH, mDNS
home/common.nix           Home Manager entry point, only imports + identity
home/profiles/<host>.nix  which package sets that machine gets
home/
  packages/cli.nix        command-line tools, `ns` package search
  packages/dev.nix        language servers, linters, formatters
  packages/desktop.nix    Hyprland ecosystem + system integration
  packages/apps.nix       graphical apps, multimedia, screen capture
  packages/apps-heavy.nix large Electron apps, opted into per host
  dotfiles.nix            ~/.config/<name> -> config/<name> live symlinks
  shell.nix               bash aliases and prompt
  neovim.nix              editor
  theming.nix             cursor, GTK, Qt, dark mode
  apps.nix                web-app desktop entries, default applications
config/                   everything symlinked into ~/.config (edits apply live, no rebuild)
  hypr/hyprland.lua       only require() lines
  hypr/bindings/          apps, windows, system, clipboard, media
  hypr/rules/             one window-rule file per app, loaded by require("./rules/*.lua")
  hypr/*.lua              autostart, input, looknfeel, monitors, envs (Hyprland Lua config)
  hypr/*.conf             hypridle, hyprlock, hyprsunset, xdph (still hyprlang)
  scripts/                nix-* helper scripts, on PATH
  themes/<name>/          colors.toml, backgrounds/, generated files
  theme -> themes/<name>  the active theme (switch with nix-theme-set)
  templates/*.tpl         color templates rendered by nix-theme-update
  mako/core.ini           shared notification settings, included by every theme
  waybar/ alacritty/ fuzzel/ mako/ swayosd/ nvim/ ...  per-app configs
```

Rebuild with `nrs` (alias for `sudo nixos-rebuild switch --flake ~/nixos-dotfiles#$(hostname)`).
The flake attribute comes from the machine's hostname, so the same alias works
on every host. Only Nix files need a rebuild. Files under `config/` are live.

The repo must be cloned to exactly `~/nixos-dotfiles`: everything under
`config/` is symlinked live from that path.

## How to add things

**A package**
1. Add one line to the matching list in `home/packages/*.nix` (system-wide tools go in `modules/common.nix`).
2. `nrs`

To give a package to one machine only, put it in its own file under
`home/packages/` and import that from `home/profiles/<host>.nix`, the way
`apps-heavy.nix` is wired up.

**An app with a shortcut**
1. Package: one line in `home/packages/apps.nix`.
2. Shortcut: in `config/hypr/bindings/apps.lua` define `local myapp = "uwsm-app -- myapp"` and add `hl.bind("SUPER + X", hl.dsp.exec_cmd(myapp))`.
3. Optional window rule: create `config/hypr/rules/myapp.lua`. It is picked up automatically.
4. Optional web app or file association: `home/apps.nix`.
5. Add the shortcut to the list in `config/scripts/nix-menu-keybindings`.

**A shortcut**
Pick the file by modifier and add one `bind =` line:

| Modifier | File | Used for |
|---|---|---|
| SUPER + key | `bindings/apps.conf` | launch apps and web apps |
| SUPER + SHIFT / ALT | `bindings/windows.conf` | focus, move, resize, workspaces, tiling |
| SUPER + CTRL | `bindings/system.conf` | lock, idle, menus, panels, notifications, power |
| SUPER + C/V/X | `bindings/clipboard.conf` | copy, paste, cut |
| XF86 keys | `bindings/media.conf` | volume, brightness, playback |

Hyprland reloads on save. Check `hyprctl configerrors` if something does not work.

**A theme**
Copy an existing directory under `config/themes/`, edit `colors.toml`, put images in `backgrounds/`, then run `nix-theme-set <name>`.

## Notes

- SUPER is the Command key, ALT is Option.
- SUPER + 0 opens the theme and power menu, so workspace 10 has no switch key.
- SUPER + Escape powers off immediately.
- Caps Lock is a Compose key.
- The ly login screen needs `/etc/ly/custom-sessions` to exist. `modules/common.nix` creates it with a tmpfiles rule.
- A flake cannot see files Git does not track. `git add` new files before rebuilding.
- The Pi 5 uses Raspberry Pi's vendor kernel, which no binary cache carries. The first build compiles it.
