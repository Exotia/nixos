{ ... }:

# Bash: aliases and prompt
{
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use hyprland btw";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#oso-air"; # The main alias for applying system updates
      vim = "nvim";
      wifi = "nmtui"; # Easy terminal-based WiFi management
      lookup = "find /etc/profiles/per-user/$USER/share/applications /run/current-system/sw/share/applications ~/.local/share/applications";
    };
    initExtra = ''
      export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ ' # Custom terminal prompt colors
      export PATH="$HOME/.config/scripts:$PATH"
      nitch # Lightweight system fetch tool shown every time you open a new terminal
      eval "$(starship init bash)" # Initializes the rich Starship prompt
    '';
  };
}
