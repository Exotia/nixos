return {
  -- On NixOS, nvim-treesitter's auto-install often fails.
  -- We use a function for opts to ensure we overwrite the default ensure_installed list.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.auto_install = false
      opts.ensure_installed = {}
    end,
  },

  -- Disable Mason entirely to avoid binary errors on NixOS.
  { "mason.nvim", enabled = false },
  { "mason-lspconfig.nvim", enabled = false },
}
