local plugins = {
  {
    "neovim/nvim-lspconfig",

    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
    },

    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
     end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",

    dependencies = {
      "nvim-lua/plenary.nvim"
    },

    config = function()
      require "custom.configs.null-ls"
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

  {
    "nvim-telescope/telescope.nvim",

    dependencies = {
      "nvim-telescope/telescope-live-grep-args.nvim",
    },

    opts = require "custom.configs.telescope"
  },

  {
    "mfussenegger/nvim-dap",

    lazy = false,

    config = function()
      require "custom.configs.dap"
    end,
  },

  {
    "rcarriga/nvim-dap-ui",

    lazy = false,

    dependencies = {
      "mfussenegger/nvim-dap"
    },

    config = function()
      require "custom.configs.dapui"
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",

    lazy = false,

    dependencies = {
      "nvim-dap"
    },

    config = function()
      require "custom.configs.dap-virtual-text"
    end,
  },

  {
    "mxsdev/nvim-dap-vscode-js",

    lazy = false,

    dependencies = {
      "nvim-dap"
    },

    config = function()
      require "custom.configs.dap-vscode"
    end,
  },

  {
    "microsoft/vscode-js-debug",

    lazy = false,

    dependencies = {
      "nvim-dap"
    },

    build = "rm -rf dist out package-lock.json && npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
  }
}

return plugins
