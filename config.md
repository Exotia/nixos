# NixOS System Configuration Overview

This document summarizes the architecture and configuration of the NixOS system for user **ole**.

## 🖥️ System Core
- **OS:** NixOS (State Version 25.05)
- **Hostname:** `nixos`
- **Package Management:** Nix Flakes enabled (`~/nixos-dotfiles#nixos`)
- **Display Manager:** `ly` (Terminal-based)
- **Compositor:** `Hyprland` (Wayland)
- **Session Manager:** `UWSM` (Universal Wayland Session Manager)
- **Nvidia Integration:** Stable proprietary drivers with modesetting enabled.

## 🛠️ User Environment (Home Manager)
- **Shell:** `bash` with `starship` prompt.
- **Terminal:** `alacritty` (GPU accelerated).
- **File Manager:** `pcmanfm`.
- **Editor:** `neovim` (configured via symlinks).
- **Application Launcher:** `fuzzel` driven by a custom Python script (`nix-app-launcher.py`).
- **Status Bar:** `waybar`.
- **Notifications:** `mako`.

## 🌐 Web & Applications
- **Primary Browser:** `Brave` (configured with system-level dark mode policies).
- **Webapps:** 
  - Managed via the custom `launch-webapp` script.
  - **YouTube:** Configured for Dark Mode (removed `--incognito` to persist settings; added `--force-dark-mode` and `--enable-features=WebUIDarkMode`).
  - **GitHub:** Integrated as a standalone desktop entry.
- **Social:** `vesktop` (Discord), `wasistlos` (WhatsApp).
- **Media:** `spotify`, `mpv`, `vlc`.

## 📜 Custom Scripts (~/nixos-dotfiles/config/scripts/)
Your system relies on a suite of custom automation scripts:
- `launch-webapp`: Launches websites as isolated browser apps with dark mode support.
- `nix-app-launcher.py`: A custom fuzzy-search menu for desktop applications.
- `nrs`: Alias for `sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos`.
- `nix-theme-*`: A set of scripts for system-wide theme synchronization (Brave, VSCode, GNOME).

## 🔧 Critical Fixes Applied (March 2026)
1. **Portable Shebangs:** Replaced all hardcoded `#!/bin/bash` with `#!/usr/bin/env bash` across all scripts to ensure compatibility with the Nix store.
2. **Webapp Dark Mode:** Refined `launch-webapp` to force dark mode flags and removed incognito mode for YouTube to allow the service to remember user appearance preferences.
3. **UWSM Integration:** Ensured all GUI applications are launched through `uwsm-app` for proper environment variable propagation on Nvidia/Wayland.

## ⌨️ Key Aliases
- `nrs`: Rebuild system and apply changes.
- `vim`: Opens `nvim`.
- `wifi`: Opens `nmtui` for network management.
- `lookup`: Search for desktop files across system and user profiles.
