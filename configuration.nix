{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Includes the results of the hardware scan (disk layout, kernel modules, etc.)
      ./hardware-configuration.nix
    ];

  # --- Boot & Hardware (Apple Silicon M2 Air) ---
  # Asahi support: kernel, GPU driver, peripheral firmware and speakers/mic DSP
  hardware.asahi = {
    enable = true;
    peripheralFirmwareDirectory = ./firmware; # must be tracked by git so the flake can see it
    setupAsahiSound = true;
  };

  # Bootloader configuration (systemd-boot behind Asahi's m1n1/U-Boot)
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5; # the Asahi EFI partition is small
  boot.loader.efi.canTouchEfiVariables = false; # U-Boot does not expose EFI variables
  ## Kernel level of logging (disable the message from the LY login at startup)
  boot.consoleLogLevel = 3;
  boot.kernelParams = [ "quiet" ];

  hardware.graphics.enable = true;

  # --- Networking ---
  networking.hostName = "oso-air";
  networking.networkmanager.enable = true; # Enables NetworkManager for easy WiFi/Ethernet configuration
  networking.networkmanager.wifi.backend = "iwd"; # iwd is the working Wi-Fi backend on Asahi (Broadcom)

  # --- Localization ---
  # Timezone and Locale settings
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  # X11 Keymap (also applies to Wayland/Hyprland by default)
  services.xserver.xkb.layout = "de";

  # --- Services ---
  # Display Manager (The login screen)
  services.displayManager.ly.enable = true; # Ly is a fast, lightweight terminal-based display manager
  # Ly scans /etc/ly/custom-sessions at startup and shows "failed to crawl session directories"
  # above the password field if it does not exist. The NixOS module does not create it, so we do.
  systemd.tmpfiles.rules = [ "d /etc/ly/custom-sessions 0755 root root -" ];

  # Bluetooth
  hardware.bluetooth.enable = true; # Enables Bluetooth hardware support
  services.blueman.enable = true; # Provides a nice GUI for managing Bluetooth connections

  # Power Management
  services.power-profiles-daemon.enable = true; # Manages power profiles (performance, balanced, power-saver) to save battery

  # PipeWire Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # --- Desktop Environment ---
  # Window Manager / Desktop Environment setup
  programs.hyprland = {
    enable = true; # Enables the Hyprland Wayland compositor
    xwayland.enable = true; # Enables XWayland to support legacy X11 applications that aren't native to Wayland yet
    withUWSM = true; # Uses Universal Wayland Session Manager for proper process and environment variable management
  };

  # wireplumber does not exit on SIGTERM at shutdown (Asahi audio driver), so systemd waited the default
  # 90 s before killing it on every reboot. A 5 s stop timeout makes reboot immediate; the kill is harmless.
  systemd.user.services.wireplumber = {
    overrideStrategy = "asDropin";
    serviceConfig.TimeoutStopSec = "5s";
  };
  # Never let any other hung unit hold a reboot for longer than this either.
  # systemd.extraConfig / systemd.user.extraConfig were removed from nixpkgs; the
  # structured settings options replace them.
  systemd.settings.Manager.DefaultTimeoutStopSec = "15s";
  systemd.user.settings.Manager.DefaultTimeoutStopSec = "15s";

  # hyprlock must be allowed to verify your password, otherwise the lock screen cannot be unlocked
  security.pam.services.hyprlock = { };

  # XDG Portals (crucial for theme detection, file picking, etc. on Wayland)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "hyprland" "gtk" ];
  };

  # --- Users ---
  # User Configuration
  users.users.oso = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # 'wheel' grants you sudo privileges, 'networkmanager' lets you change wifi without password
    packages = with pkgs; [ ]; # User-specific packages are managed in home.nix instead of here
  };

  # --- System Packages ---
  # System-wide Packages (Installed for all users on the system)
  environment.systemPackages = with pkgs; [
    vim # Basic text editor
    wget # Network downloader
    git # Version control
    gcc
    gemini-cli # Gemini AI CLI tool
  ];

  # --- Fonts ---
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono # Provides the terminal font and all the icons needed for Waybar, Fuzzel, and your prompt
  ];

  # --- Nix Package Manager Settings ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Enables modern Nix commands and Flakes

  # System Optimizations
  nix.settings.auto-optimise-store = true; # Saves disk space by automatically hardlinking identical files in /nix/store
  nix.gc = {
    automatic = true; # Enables automatic garbage collection
    dates = "weekly"; # Runs weekly
    options = "--delete-older-than 14d"; # Deletes old build files and unused configurations older than 2 weeks to prevent disk bloat
  };

  # Enables compressed RAM swap for better memory management without wearing out your SSD
  zramSwap.enable = true;

  # Allow proprietary software (like Brave, Obsidian, etc.)
  nixpkgs.config.allowUnfree = true;

  # System-level configuration files
  environment.etc = {
    # Symlinks your local theme policy so Brave/Chromium can read the theme colors without requiring sudo
    "brave/policies/managed/color.json".source = "/home/oso/nixos-dotfiles/config/theme/brave-policy.json";
    "chromium/policies/managed/color.json".source = "/home/oso/nixos-dotfiles/config/theme/brave-policy.json";
  };


  # State version (Do not change this! It ensures backwards compatibility with databases created when you installed NixOS)
  system.stateVersion = "26.05";
}
