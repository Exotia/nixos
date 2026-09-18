{ pkgs, ... }:

# Graphical applications, multimedia and screen capture. Add a new app here.
# Large Electron applications live in apps-heavy.nix so that slower machines
# can leave them out.
{
  home.packages = with pkgs; [
    # --- Graphical Applications ---
    pcmanfm # Lightweight file manager
    localsend # Tool for sharing files over local network securely
    rink # Advanced unit conversion tool/calculator
    firefox # this replaced brave as a browser
    imv # Minimalist image viewer
    mpv # Lightweight, highly capable media player
    vlc # Feature-rich media player (set as default for video)
    keepassxc # Password Manager

    # --- Multimedia & Screen Capture ---
    pulsemixer # Command-line audio mixer (used by SUPER+CTRL+A)
    grim # Screenshot utility for Wayland
    slurp # Tool to select a specific region on screen (used with grim)
    satty # Screenshot annotation tool (allows you to draw on screenshots)
    gpu-screen-recorder # Hardware-accelerated screen recorder
    ffmpeg # Swiss-army knife framework for audio/video processing
    v4l-utils # Video4Linux utilities (provides webcam support)
  ];
}
