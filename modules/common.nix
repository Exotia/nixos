{ pkgs, ... }:

# Settings shared by every machine in this repo. Anything that depends on a
# particular board, bootloader or peripheral belongs in hosts/<name>/ instead.
{
  hardware.graphics.enable = true;

  # --- Networking ---
  # The hostname itself is set per host by mkHost in flake.nix.
  networking.networkmanager.enable = true; # Enables NetworkManager for easy WiFi/Ethernet configuration

  # --- Localization ---
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

  # PipeWire Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # --- Desktop Environment ---
  programs.hyprland = {
    enable = true; # Enables the Hyprland Wayland compositor
    xwayland.enable = true; # Enables XWayland to support legacy X11 applications that aren't native to Wayland yet
    withUWSM = true; # Uses Universal Wayland Session Manager for proper process and environment variable management
  };

  # Never let a hung unit hold a reboot for longer than this.
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
  users.users.oso = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # 'wheel' grants you sudo privileges, 'networkmanager' lets you change wifi without password
    packages = with pkgs; [ ]; # User-specific packages are managed in home/ instead of here
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
}
