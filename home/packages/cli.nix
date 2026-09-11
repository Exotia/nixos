{ pkgs, ... }:

# Command-line tools and the `ns` package search helper.
{
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
}
