# NixOS Setup Cleanup Log

## Removed Unnecessary Scripts
The following custom scripts were removed as they were specific to another setup (Omarchy) or redundant:
- `nix-cmd-first-run`
- `nix-drive-select`
- `nix-update`
- `nix-version`
- `nix-launch-wifi`
- `nix-launch-audio`
- `nix-launch-bluetooth`

## Configuration Updates
- **Hyprland Autostart:** Removed `nix-cmd-first-run` from `config/default/hypr/autostart.conf`.
- **Hyprland Bindings:** Replaced `nix-launch-*` script bindings in `config/default/hypr/bindings/utilities.conf` with direct terminal commands (`alacritty -e pulsemixer` and `alacritty -e nmtui`).
- **Waybar:** Updated network and audio modules in `config/waybar/config.jsonc` to use `alacritty -e nmtui` and `alacritty -e pulsemixer` instead of the removed `nix-launch-*` scripts.
- **Fastfetch:** Simplified `config/fastfetch/config.jsonc` by replacing custom script-based modules (`nix-version`) with the built-in `os` module and removing the broken `update` module.

## Removed Launch Wrapper Scripts
To further simplify without losing functionality, several over-engineered launch wrapper scripts were removed. We replaced them with direct standard commands in Hyprland configs:
- Removed `nix-launch-browser` and replaced it with direct `uwsm-app -- brave` commands.
- Removed `nix-launch-editor` and replaced it with `uwsm-app -- alacritty -e nvim`.
- Removed `nix-launch-tui`, `nix-launch-or-focus-tui`, and `launch-webapp` wrappers. Replaced TUI launchers with standard `alacritty --class TUI.float -e [cmd]` and web apps with `uwsm-app -- brave --app=[url]`.
- Removed `nix-launch-floating-terminal-with-presentation` and `nix-launch-or-focus-webapp` which were largely redundant.

## Window Rule Cleanups
- Removed legacy `org.arch.*` class rules from `config/default/hypr/apps/system.conf`. TUI apps that need to float now directly use the `TUI.float` class applied by Alacritty.
- Removed unused `org.arch.screensaver` checks from the `nix-lock-screen` script.
## Helper Script Cleanup
Removed several tiny bash scripts that only wrapped standard bash tools or printed text, replacing them directly in the config where needed:
- Removed `nix-pkg-add` and `nix-pkg-remove` (text helpers that just echoed instructions to edit home.nix).
- Removed `nix-cmd-present` (replaced its usages directly with standard `command -v`).
- Removed `nix-notification-dismiss` (replaced its usage in `mako/core.ini` directly with `makoctl dismiss`).

## Removed Service Restart Wrappers
Removed a series of overly complex wrapper scripts used for restarting basic services, substituting them with simple `pkill` and direct execute commands where they were actually used:
- Removed `nix-restart-app`, `nix-restart-waybar`, `nix-restart-hypridle`, `nix-restart-hyprsunset`, and `nix-restart-swayosd`.

## Pending/Suggested Cleanups
- **Theme/Background Scripts:** Some of the `nix-theme-*` and `nix-background-*` scripts might be overly complex if you prefer a simpler, static setup.
- **Bash Aliases:** Review `home.nix` and bash configurations for any other aliases that rely on removed scripts.
