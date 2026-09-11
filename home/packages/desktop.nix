{ pkgs, ... }:

# Hyprland ecosystem and the system-integration pieces it needs.
{
  home.packages = with pkgs; [
    # --- Desktop Environment Core (Hyprland Ecosystem) ---
    alacritty # GPU-accelerated terminal emulator
    fuzzel # Wayland application launcher (opened with SUPER+SPACE)
    swaybg # Wallpaper utility for Wayland
    mako # Wayland notification daemon (shows popups in the corner)
    lxqt.lxqt-policykit # Polkit authentication agent (handles GUI password prompts for sudo actions)
    hyprlock # Screen locker for Hyprland
    hypridle # Idle daemon (handles sleeping/locking the screen after inactivity)
    waybar # Highly customizable status bar at the top of your screen
    swayosd # On-screen display for volume/brightness popups
    xdg-terminal-exec # Standardized tool to launch your default terminal
    hyprpicker # Color picker utility for Wayland
    wl-clipboard # Command-line clipboard utilities (wl-copy, wl-paste)
    xclip # Clipboard utility for X11 applications
    xsel # Another clipboard utility for X11

    # --- System Integration & Under-the-hood Dependencies ---
    bibata-cursors
    libnotify # Library that allows scripts to send desktop notifications (notify-send)
    glib # Core application library (provides gsettings)
    gsettings-desktop-schemas # Standard schemas for GTK applications
    dconf # Configuration backend system for GNOME/GTK apps (themes, fonts, etc.)
    networkmanagerapplet # GUI applet for managing network connections (nm-applet in Waybar)
    bluez-tools # Bluetooth command-line tools (bt-device, bt-adapter, etc.)
    blueman # Graphical bluetooth manager (blueman-manager, blueman-applet)
    xdg-utils # Tools for standard desktop operations (like xdg-open)
    shared-mime-info # Database of file types (helps apps know what program should open a specific file)
    brightnessctl # Tool to control laptop backlight brightness
    upower # Tool to query power/battery status
    playerctl # Command-line utility to control media players (play/pause/next via hotkeys)
  ];
}
