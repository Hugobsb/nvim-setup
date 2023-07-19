local plugins = {
  {
    "neovim/nvim-lspconfig",

    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require "custom.configs.null-ls"
      end,
    },

    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
     end,
  },

  {
    "kdheepak/lazygit.nvim",

    lazy = false,

    dependencies = {
      "nvim-telescope/telescope.nvim",
      -- optional for floating window border decoration
      "nvim-lua/plenary.nvim",
    },

    config = function()
      require "custom.configs.lazygit"
    end,
  },

  -- {
  --   "nvim-telescope/telescope.nvim",
  --
  --   config = function()
  --     require "plugins.configs.telescope"
  --     require "custom.configs.telescope"
  --   end,
  -- }
}

return plugins
