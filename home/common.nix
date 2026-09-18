{ config, ... }:

# Home Manager settings shared by every host. Per-host package choices live in
# home/profiles/<hostname>.nix, which imports this file.
#
#   home/packages/*.nix  what is installed (cli, dev, desktop, apps)
#   home/dotfiles.nix    ~/.config symlinks into config/
#   home/shell.nix       bash aliases and prompt
#   home/neovim.nix      editor
#   home/theming.nix     cursor, GTK, Qt, dark mode
#   home/apps.nix        web-app desktop entries, default applications
{
  imports = [
    ./packages/cli.nix
    ./packages/dev.nix
    ./packages/desktop.nix
    ./packages/apps.nix
    ./dotfiles.nix
    ./shell.nix
    ./neovim.nix
    ./theming.nix
    ./apps.nix
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
