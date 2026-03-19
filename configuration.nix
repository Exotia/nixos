{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Includes the results of the hardware scan (disk layout, kernel modules, etc.)
      ./hardware-configuration.nix
    ];

  # --- Boot & Hardware ---
  # Bootloader configuration (systemd-boot for modern UEFI systems)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Networking ---
  networking.hostName = "nixos";
  networking.networkmanager.enable = true; # Enables NetworkManager for easy WiFi/Ethernet configuration

  # --- Localization ---
  # Timezone and Locale settings
  time.timeZone = "Europa/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";
  
  # X11 Keymap (also applies to Wayland/Hyprland by default)
  services.xserver.xkb.layout = "de";

  # --- Services ---
  # Display Manager (The login screen)
  services.displayManager.ly.enable = true; # Ly is a fast, lightweight terminal-based display manager

  # Bluetooth
  hardware.bluetooth.enable = true; # Enables Bluetooth hardware support
  services.blueman.enable = true; # Provides a nice GUI for managing Bluetooth connections

  # Power Management
  services.power-profiles-daemon.enable = true; # Manages power profiles (performance, balanced, power-saver) to save battery

  # --- Desktop Environment ---
  # Window Manager / Desktop Environment setup
  programs.hyprland = {
    enable = true; # Enables the Hyprland Wayland compositor
    xwayland.enable = true; # Enables XWayland to support legacy X11 applications that aren't native to Wayland yet
    withUWSM = true; # Uses Universal Wayland Session Manager for proper process and environment variable management
  };

  # --- Programs ---
  # Gaming
  programs.steam.enable = true; # Enables Steam and automatically opens necessary firewall ports

  # --- Users ---
  # User Configuration
  users.users.ole = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # 'wheel' grants you sudo privileges, 'networkmanager' lets you change wifi without password
    packages = with pkgs; []; # User-specific packages are managed in home.nix instead of here
  };

  # --- System Packages ---
  # System-wide Packages (Installed for all users on the system)
  environment.systemPackages = with pkgs; [
    vim # Basic text editor
    wget # Network downloader
    git # Version control
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

  # Allow proprietary software (like Steam, specific drivers, etc.)
  nixpkgs.config.allowUnfree = true;

  # System-level configuration files
  environment.etc = {
    # Symlinks your local theme policy so Brave/Chromium can read the theme colors without requiring sudo
    "brave/policies/managed/color.json".source = "/home/ole/nixos-dotfiles/config/theme/brave-policy.json";
    "chromium/policies/managed/color.json".source = "/home/ole/nixos-dotfiles/config/theme/brave-policy.json";
  };

  # State version (Do not change this! It ensures backwards compatibility with databases created when you installed NixOS)
  system.stateVersion = "25.05";
}