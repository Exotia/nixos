# Gemini CLI Project Context: NixOS Hyprland Dotfiles

This file contains critical information about the project's architecture, recent fixes, and ongoing maintenance for the NixOS-based Hyprland setup.

## 🛠 Recent Critical Fixes (March 18, 2026)

### 1. Custom App Launcher Reliability & Favorites Sync
- **Case-Sensitivity Fix:** Resolved an issue where "LocalSend" was missing from favorites due to a case-sensitive mismatch (`Localsend` vs `LocalSend`).
- **Dynamic Favorites:** Updated `nix-menu-apps-favorites` to automatically respect the `defaults` list in `config/fuzzel/custom-launcher.json`, removing the need for double-entry in the script.
- **PCManFM Alias:** Fixed a JSON syntax error and corrected the PCManFM alias from the "Preferences" entry to the main file manager entry ("Explorer").

### 2. Modern Launcher UI (Placeholder System)
- **Auto-Disappearing Text:** Migrated all Fuzzel-based scripts (`nix-app-launcher.py`, `nix-menu-*`) from using `--prompt` for labels to the `--placeholder` flag.
- **Clean Interface:** Set the prompt to empty (`-p ""`) across all menus, ensuring labeling text disappears instantly when typing begins.

### 3. Advanced Waybar Functionality
- **Interactive Weather:** Added a custom weather module using `wttr.in`. Clicking the weather now opens the full forecast in a standalone Brave app window.
- **Clickable Calendar:** Added a date module (Day. Month) that launches Google Calendar in Brave as a standalone app on click.
- **Helper Scripts:** Created `nix-weather-get` and `nix-launch-calendar` in `config/scripts/` to handle background data and application launching.

### 4. Hyprland "Floating" Aesthetic
- **Rounded Corners:** Standardized 10px rounding across all windows to match the Waybar/Fuzzel aesthetic.
- **Deep Shadows:** Implemented an elevated floating effect using `shadow.range = 35` and a vertical offset, giving windows a distinct sense of depth.
- **Optimized Spacing:** Reduced inner gaps (`gaps_in = 4`) while maintaining outer gaps for a cohesive, modern layout.

## 🛠 Recent Critical Fixes (March 17, 2026)

### 1. Massive Script De-bloating & Native Command Migration
- **Script Removal:** Deleted 20+ redundant/broken bash scripts from `config/scripts/` that were over-engineered wrappers or specific to old Arch setups.
- **Native Bindings:** Updated `hypr/bindings.conf` and `utilities.conf` to use direct commands for Browser, Editor, and TUI utilities.

### 2. Robust NixOS Process Management
- **Wrapped Binary Support:** Updated all scripts to use regex matching: `pkill -x 'name|\.name-wrapped'` to handle NixOS binary wrapping.
- **Reliable Service Spawning:** Switched to `hyprctl dispatch exec [cmd]` for background services to ensure native compositor management.

### 3. Application Launcher & Navigation Improvements
- **Shortcut Reliability:** Standardized on `SUPER + A` for the full app launcher and `SUPER + SPACE` for favorites.

## 🛠 Recent Critical Fixes (March 16, 2026)

### 1. Super + Space App Launcher Fix
- **Python3 Dependency:** Added `python3` to `home.nix` and fixed absolute paths for the custom launcher script.
- **Input Conflict Resolution:** Disabled `fcitx5` in Hyprland autostart to prevent interception of the launcher shortcut.

### 2. Custom App Launcher with Aliases & Priority
- **Python-based Launcher:** Implemented `nix-app-launcher.py` with support for aliases, priority sorting, and hidden apps via JSON config.

## 🏗 Project Architecture & Conventions

### Directory Structure
- `config/`: Main configuration files symlinked via Home Manager.
- `config/themes/`: Individual theme directories containing `colors.toml` and `backgrounds/`.
- `config/scripts/`: Custom bash/python scripts for system integration.

### Important Commands
- `nrs`: Alias for `sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos`.
- `nix-theme-set <name>`: Switches the system theme and updates all configs.
- `nix-menu-theming`: Opens the UI to change themes or backgrounds.
