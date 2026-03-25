return {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of main branch
    ft = "markdown",
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/Uni/Mathe", -- Adjust this to your actual vault path
        },
      },
    },
  },
}
