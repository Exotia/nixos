{ config, ... }:

# Live symlinks from ~/.config into this repo. Edits under config/ apply without a rebuild.
let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # ~/.config/<name>  ->  config/<subpath>
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
    theme = "theme";
    mpv = "mpv";
    mako = "theme";
  };
in
{
  xdg.configFile = (builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
    })
    configs) // {
    "starship.toml".source = create_symlink "${dotfiles}/starship.toml";
  };

  # Custom icons in the hicolor structure so simple icon names resolve
  home.file.".local/share/icons/hicolor/scalable/apps".source = create_symlink "${dotfiles}/icons";

  # Put the scripts directory on PATH
  home.sessionPath = [ "$HOME/.config/scripts" ];
}
