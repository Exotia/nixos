{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
configs = {
  hypr = "hypr";
  nvim = "nvim";
  waybar = "waybar";
  alacritty = "alacritty";
  imv = "imv";
  lazygit = "lazygit";
  swayosd = "swayosd";
  walker = "walker";
  fcitx5 = "fcitx5";
  fastfetch = "fastfetch";
  git = "git";
  btop = "btop";
  tmux = "tmux";
  scripts = "scripts";
  default = "default";
  theme = "theme";
  mpv = "mpv";
};
in
{
imports = [
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

home.file.".local/share/icons".source = create_symlink "${dotfiles}/icons";

programs.bash = {  enable = true;
  shellAliases = {
    btw = "echo i use hyprland btw";
    nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
    vim = "nvim";
  };
  initExtra = ''
    export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ '
    export PATH="$HOME/.config/scripts:$PATH"
    nitch
    eval "$(starship init bash)"
  '';
};

home.packages = with pkgs; [
  neovim
  ripgrep
  nil
  nixpkgs-fmt
  nodejs
  pcmanfm
  alacritty
  walker
  uwsm
  brave
  imv
  mpv
  lazygit
  starship
  btop
  tmux
  fastfetch
  vesktop
  wasistlos
  nitch
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

xdg.configFile = (builtins.mapAttrs  (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  })
  configs) // {
    "starship.toml".source = create_symlink "${dotfiles}/starship.toml";
  };

}
