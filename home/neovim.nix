{ pkgs, ... }:

# Neovim. The LazyVim config itself lives in config/nvim (symlinked by dotfiles.nix).
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # Do not write ~/.config/nvim/init.lua: ~/.config/nvim is a symlink into the
    # dotfiles repo (LazyVim owns it); home-manager sideloads its init instead.
    sideloadInitLua = true;

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
}
