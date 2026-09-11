{ config, ... }:

# Home Manager entry point. Each concern lives in its own module under home/.
#   home/packages/*.nix  what is installed (cli, dev, desktop, apps)
#   home/dotfiles.nix    ~/.config symlinks into config/
#   home/shell.nix       bash aliases and prompt
#   home/neovim.nix      editor
#   home/theming.nix     cursor, GTK, Qt, dark mode
#   home/apps.nix        web-app desktop entries, default applications
{
  imports = [
    ./home/packages/cli.nix
    ./home/packages/dev.nix
    ./home/packages/desktop.nix
    ./home/packages/apps.nix
    ./home/dotfiles.nix
    ./home/shell.nix
    ./home/neovim.nix
    ./home/theming.nix
    ./home/apps.nix
  ];

  home.username = "oso";
  home.homeDirectory = "/home/oso";
  home.stateVersion = "26.05"; # Do not change this unless explicitly migrating to a new NixOS version

  # Environment variables available to all applications in your graphical session
  home.sessionVariables = {
    NIXOS_PATH = "${config.home.homeDirectory}/nixos-dotfiles/config";
    XDG_TERMINAL_EXEC = "alacritty"; # Sets the default terminal emulator for scripts and desktop apps
    XDG_SESSION_TYPE = "wayland"; # Informs apps that you are running a Wayland session
  };
}
