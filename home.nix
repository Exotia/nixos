{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  
  # List of configuration directories to symlink to ~/.config/
  configs = {
    hypr = "hypr";
    nvim = "nvim";
    waybar = "waybar";
    alacritty = "alacritty";
    imv = "imv";
    lazygit = "lazygit";
    swayosd = "swayosd";
    fuzzel = "fuzzel";
    fastfetch = "fastfetch";
    git = "git";
    btop = "btop";
    tmux = "tmux";
    scripts = "scripts";
    default = "default";
    theme = "theme";
    mpv = "mpv";
    mako = "theme";
    };in
{
imports = [
];

home.username = "ole";
home.homeDirectory = "/home/ole";
home.stateVersion = "25.05"; # Do not change this unless explicitly migrating to a new NixOS version

# Environment variables available to all applications in your graphical session
home.sessionVariables = {
  NIXOS_PATH = "${config.home.homeDirectory}/nixos-dotfiles/config";
  XDG_TERMINAL_EXEC = "alacritty"; # Sets the default terminal emulator for scripts and desktop apps
};

# Adds your custom scripts directory to the system PATH so you can run them directly from any terminal
home.sessionPath = [
  "$HOME/.config/scripts"
];

# Symlink your custom icons folder
home.file.".local/share/icons".source = create_symlink "${dotfiles}/icons";

# --- Bash Shell Configuration ---
programs.bash = {  
  enable = true;
  shellAliases = {
    btw = "echo i use hyprland btw";
    nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos"; # The main alias for applying system updates
    vim = "nvim";
    lookup = "find /etc/profiles/per-user/ole/share/applications /run/current-system/sw/share/applications ~/.local/share/applications";
  };
  initExtra = ''
    export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ ' # Custom terminal prompt colors
    export PATH="$HOME/.config/scripts:$PATH"
    nitch # Lightweight system fetch tool shown every time you open a new terminal
    eval "$(starship init bash)" # Initializes the rich Starship prompt
  '';
};

# --- User Packages ---
home.packages = with pkgs; [
  # --- Development & CLI Tools ---
  neovim          # Advanced text editor
  ripgrep         # Fast search tool (modern grep alternative)
  nil             # Nix language server (provides code completion for Nix files in Neovim)
  nixpkgs-fmt     # Formatter for Nix code
  nodejs          # JavaScript runtime
  lazygit         # Terminal UI for Git version control
  starship        # Highly customizable terminal prompt
  btop            # Terminal-based system resource monitor (CPU/RAM/Network)
  tmux            # Terminal multiplexer (allows multiple split panes in one terminal window)
  fastfetch       # Detailed system information tool (like neofetch)
  nitch           # Minimal system information tool
  fzf             # Command-line fuzzy finder
  jq              # Command-line JSON processor

  # --- Desktop Environment Core (Hyprland Ecosystem) ---
  alacritty       # GPU-accelerated terminal emulator
  fuzzel          # Wayland application launcher (opened with SUPER+SPACE)
  swaybg          # Wallpaper utility for Wayland
  mako            # Wayland notification daemon (shows popups in the corner)
  lxqt.lxqt-policykit # Polkit authentication agent (handles GUI password prompts for sudo actions)
  hyprlock        # Screen locker for Hyprland
  hypridle        # Idle daemon (handles sleeping/locking the screen after inactivity)
  waybar          # Highly customizable status bar at the top of your screen
  swayosd         # On-screen display for volume/brightness popups
  xdg-terminal-exec # Standardized tool to launch your default terminal
  hyprpicker      # Color picker utility for Wayland
  wl-clipboard    # Command-line clipboard utilities (wl-copy, wl-paste)

  # --- System Integration & Under-the-hood Dependencies ---
  python3         # Python interpreter (required by your custom app launcher script)
  libnotify       # Library that allows scripts to send desktop notifications (notify-send)
  glib            # Core application library (provides gsettings)
  gsettings-desktop-schemas # Standard schemas for GTK applications
  dconf           # Configuration backend system for GNOME/GTK apps (themes, fonts, etc.)
  networkmanagerapplet # GUI applet for managing network connections (nm-applet in Waybar)
  xdg-utils       # Tools for standard desktop operations (like xdg-open)
  shared-mime-info # Database of file types (helps apps know what program should open a specific file)
  brightnessctl   # Tool to control laptop backlight brightness
  upower          # Tool to query power/battery status
  playerctl       # Command-line utility to control media players (play/pause/next via hotkeys)

  # --- Graphical Applications ---
  pcmanfm         # Lightweight file manager
  localsend       # Tool for sharing files over local network securely
  gnome-calculator# Standard calculator
  rink            # Advanced unit conversion tool/calculator
  brave           # Privacy-focused web browser
  imv             # Minimalist image viewer
  mpv             # Lightweight, highly capable media player
  vesktop         # Custom Discord client (supports screen sharing on Wayland and Vencord plugins)
  wasistlos       # Unofficial WhatsApp client
  obsidian        # Markdown-based note-taking application
  spotify         # Music streaming client

  # --- Multimedia & Screen Capture ---
  grim            # Screenshot utility for Wayland
  slurp           # Tool to select a specific region on screen (used with grim)
  satty           # Screenshot annotation tool (allows you to draw on screenshots)
  gpu-screen-recorder # Hardware-accelerated screen recorder
  ffmpeg          # Swiss-army knife framework for audio/video processing
  v4l-utils       # Video4Linux utilities (provides webcam support)

  # --- Custom Scripts ---
  # A custom script to search for Nix packages from the command line using 'ns'
  (pkgs.writeShellApplication {    name = "ns";
    runtimeInputs = with pkgs; [
      fzf
      (nix-search-tv.overrideAttrs (old: {
        env.GOEXPERIMENT = "jsonv2";
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.removeReferencesTo ];
        postFixup = (old.postFixup or "") + ''
          remove-references-to -t ${pkgs.go} $out/bin/nix-search-tv
        '';
      }))
    ];
    text = ''exec "${pkgs.nix-search-tv.src}/nixpkgs.sh" "$@"'';
  })
];

# Create standalone app entries for specific websites (Web Apps)
xdg.desktopEntries = {
  github = {
    name = "GitHub";
    exec = "brave --app=https://github.com";
    icon = "github";
    terminal = false;
    categories = [ "Development" ];
  };
  youtube = {
    name = "YouTube";
    exec = "brave --app=https://youtube.com";
    icon = "youtube";
    terminal = false;
    categories = [ "Video" ];
  };
};

# Generate ~/.config/ symlinks for all defined applications in the 'configs' list above
xdg.configFile = (builtins.mapAttrs  (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
  })
  configs) // {
    "starship.toml".source = create_symlink "${dotfiles}/starship.toml";
  };

}
