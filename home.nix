{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    hypr = "hypr";
    nvim = "nvim";
    wofi = "wofi";
    rofi = "rofi";
    waybar = "waybar";
    kitty = "kitty";
  };
in
{
  imports = [
    ./modules/theme.nix
  ];

  home.username = "ole";
  home.homeDirectory = "/home/ole";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    NIXOS_PATH = "${config.home.homeDirectory}/nixos-dotfiles/config";
  };

  home.sessionPath = [
    "$HOME/.config/scripts"
  ];

  home.file.".local/share/fonts/omarchy.ttf".source = ./config/nixos/omarchy.ttf;

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use hyprland btw";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
      vim = "nvim";
    };
    initExtra = ''
      export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ '
      export PATH="$HOME/.config/scripts:$PATH"
      nitch
    '';
  };

  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    wofi
    rofi
    pcmanfm
    alacritty
    kitty
    walker
    uwsm
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

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

}
