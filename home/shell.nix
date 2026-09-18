{ pkgs, ... }:

# Bash: aliases, history, prompt, and ble.sh for syntax highlighting + autosuggestions
{
  home.packages = [ pkgs.blesh ];

  programs.bash = {
    enable = true;
    historySize = 100000;
    historyFileSize = 200000;
    historyControl = [ "ignoredups" "erasedups" ];
    shellOptions = [ "histappend" "checkwinsize" "extglob" "globstar" ];
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#oso-air"; # The main alias for applying system updates
      vim = "nvim";
      wifi = "nmtui"; # Easy terminal-based WiFi management
      lookup = "find /etc/profiles/per-user/$USER/share/applications /run/current-system/sw/share/applications ~/.local/share/applications";
    };
    initExtra = ''
      # ble.sh: syntax highlighting, autosuggestions, and prefix history (type "git", press Up).
      # Loaded first with --attach=none, attached at the very end (ble.sh convention).
      [[ $- == *i* ]] && source "$(blesh-share)/ble.sh" --attach=none

      export PATH="$HOME/.config/scripts:$PATH"
      nitch # Lightweight system fetch tool shown every time you open a new terminal
      eval "$(starship init bash)" # Initializes the rich Starship prompt

      [[ ''${BLE_VERSION-} ]] && ble-attach
    '';
  };

  # yazi terminal file manager. `y` opens it and cd's to the directory you quit in.
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    shellWrapperName = "y";
  };

  # Ctrl-R fuzzy history search, Ctrl-T file picker, Alt-C directory jump.
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
}
