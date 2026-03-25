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
  };
in
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
    LIBVA_DRIVER_NAME = "nvidia"; # Enables hardware acceleration for video playback
    XDG_SESSION_TYPE = "wayland"; # Informs apps that you are running a Wayland session
    GBM_BACKEND = "nvidia-drm"; # Required for many applications to render correctly on NVIDIA
    __GLX_VENDOR_LIBRARY_NAME = "nvidia"; # Ensures apps use the NVIDIA implementation of GLX
    NVD_BACKEND = "direct"; # Improves VA-API (video acceleration) performance on NVIDIA
  };

  # Adds your custom scripts directory to the system PATH so you can run them directly from any terminal
  home.sessionPath = [
    "$HOME/.config/scripts"
  ];

  # Symlink your custom icons folder to hicolor structure to allow simple names and avoid cursor conflicts
  home.file.".local/share/icons/hicolor/scalable/apps".source = create_symlink "${dotfiles}/icons";

  # --- Bash Shell Configuration ---
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use hyprland btw";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos --update"; # The main alias for applying system updates
      vim = "nvim";
      wifi = "nmtui"; # Easy terminal-based WiFi management
      lookup = "find /etc/profiles/per-user/ole/share/applications /run/current-system/sw/share/applications ~/.local/share/applications";
    };
    initExtra = ''
      export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ ' # Custom terminal prompt colors
      export PATH="$HOME/.config/scripts:$PATH"
      nitch # Lightweight system fetch tool shown every time you open a new terminal
      eval "$(starship init bash)" # Initializes the rich Starship prompt
    '';
  };

  # --- Neovim Configuration ---
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Includes common dependencies
    withNodeJs = true;
    withPython3 = true;
    withRuby = false;
    withPerl = false;

    # Ensure Treesitter has the necessary parsers by installing them via Nix
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
    ];
  };

  # --- User Packages ---
  home.packages = with pkgs; [
    # --- Development & CLI Tools ---
    ripgrep # Fast search tool (modern grep alternative)
    fd # Fast, user-friendly alternative to 'find' (used by Telescope)
    nil # Nix language server (provides code completion for Nix files in Neovim)
    nixpkgs-fmt # Formatter for Nix code
    nodejs # JavaScript runtime
    python3 # Python interpreter
    unzip # Required for some Neovim plugins to extract files
    gnumake # Build tool (sometimes needed for Neovim plugins)
    lazygit # Terminal UI for Git version control
    starship # Highly customizable terminal prompt
    btop # Terminal-based system resource monitor (CPU/RAM/Network)
    tmux # Terminal multiplexer (allows multiple split panes in one terminal window)
    fastfetch # Detailed system information tool (like neofetch)
    nitch # Minimal system information tool
    fzf # Command-line fuzzy finder
    jq # Command-line JSON processor

    # --- Language Servers & Formatters ---
    lua-language-server
    stylua
    bash-language-server
    shfmt
    shellcheck
    vscode-langservers-extracted # HTML, CSS, JSON, ESLint
    yaml-language-server
    pyright
    nixd # Another Nix LSP (often more feature-rich than nil)
    nodePackages.prettier # Multi-language formatter
    nodePackages.svelte-language-server
    nodePackages.eslint_d
    python312Packages.pylint
    python312Packages.isort
    python312Packages.black
    emmet-ls

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

    # --- Graphical Applications ---
    pcmanfm # Lightweight file manager
    localsend # Tool for sharing files over local network securely
    rink # Advanced unit conversion tool/calculator
    brave # Privacy-focused web browser
    imv # Minimalist image viewer
    mpv # Lightweight, highly capable media player
    vlc # Feature-rich media player (set as default for video)
    vesktop # Custom Discord client (supports screen sharing on Wayland and Vencord plugins)
    wasistlos # Unofficial WhatsApp client
    obsidian # Markdown-based note-taking application
    spotify # Music streaming client

    # --- Multimedia & Screen Capture ---
    pulsemixer # Command-line audio mixer (used by SUPER+CTRL+A)
    grim # Screenshot utility for Wayland
    slurp # Tool to select a specific region on screen (used with grim)
    satty # Screenshot annotation tool (allows you to draw on screenshots)
    gpu-screen-recorder # Hardware-accelerated screen recorder
    ffmpeg # Swiss-army knife framework for audio/video processing
    v4l-utils # Video4Linux utilities (provides webcam support)

    # --- Custom Scripts ---
    # A custom script to search for Nix packages from the command line using 'ns'
    (pkgs.writeShellApplication {
      name = "ns";
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

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  # --- Theming (Force Dark Mode) ---
  # This ensures that GTK, Qt, and browser-based apps detect a system-wide dark mode preference.
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  # Tells GNOME/GTK apps (via dconf) that you prefer dark mode. 
  # This is what browsers like Brave/Chromium look for.
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Ensures Qt applications (like VLC or some tools) also use the GTK theme for consistency
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  # Create standalone app entries for specific websites (shortcuts to main browser)
  xdg.desktopEntries = {
    github = {
      name = "GitHub";
      exec = "brave https://github.com";
      icon = "github";
      terminal = false;
      categories = [ "Development" ];
    };
    youtube = {
      name = "YouTube";
      exec = "brave https://youtube.com";
      icon = "youtube";
      terminal = false;
      categories = [ "Video" ];
    };
  };

  # Set default applications for specific file types (MIME types)
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "video/mp4" = [ "vlc.desktop" ];
      "video/mpeg" = [ "vlc.desktop" ];
      "video/ogg" = [ "vlc.desktop" ];
      "video/quicktime" = [ "vlc.desktop" ];
      "video/webm" = [ "vlc.desktop" ];
      "video/x-matroska" = [ "vlc.desktop" ];
      "video/x-ms-wmv" = [ "vlc.desktop" ];
      "video/x-flv" = [ "vlc.desktop" ];
      "video/x-msvideo" = [ "vlc.desktop" ];
      "video/avi" = [ "vlc.desktop" ];
    };
  };

  # Generate ~/.config/ symlinks for all defined applications in the 'configs' list above
  xdg.configFile = (builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
    })
    configs) // {
    "starship.toml".source = create_symlink "${dotfiles}/starship.toml";
  };

}
