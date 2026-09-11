{ pkgs, ... }:

# Language servers, linters and formatters used by Neovim.
{
  home.packages = with pkgs; [
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
    prettier # Multi-language formatter
    svelte-language-server
    eslint_d
    python3Packages.pylint
    python3Packages.isort
    python3Packages.black
    emmet-ls
  ];
}
