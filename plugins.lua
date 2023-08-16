local plugins = {
  {
    "neovim/nvim-lspconfig",

    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
    },

    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig-c"
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",

    dependencies = {
      "nvim-lua/plenary.nvim"
    },

    config = function()
      require "custom.configs.null-ls"
    end
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- servers
        "css-lsp",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "gopls",
        "html-lsp",
        "typescript-language-server",
        "yaml-language-server",

        -- formatters
        "gofumpt",
        "goimports-reviser",
        "golines",
        "prettierd",
        "xmlformatter",
        "yamlfix",

        -- code actions
        "eslint_d",
      }
    }
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
      require "custom.configs.lazygit-c"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",

    dependencies = {
      "nvim-telescope/telescope-live-grep-args.nvim",
    },

    opts = require "custom.configs.telescope-c",

    config = require "plugins.configs.telescope"
  },

  {
    "mfussenegger/nvim-dap",

    lazy = false,

    config = function()
      require "custom.configs.dap"
    end
  },

  {
    "rcarriga/nvim-dap-ui",

    lazy = false,

    dependencies = {
      "mfussenegger/nvim-dap"
    },

    config = function()
      require "dapui".setup(
        require "custom.configs.dapui-c"
      )
    end
  },

  {
    "theHamsta/nvim-dap-virtual-text",

    lazy = false,

    dependencies = {
      "nvim-dap"
    },

    config = function()
      require "nvim-dap-virtual-text".setup(
        require "custom.configs.dap-virtual-text"
      )
    end
  },

  {
    "mxsdev/nvim-dap-vscode-js",

    lazy = false,

    dependencies = {
      "nvim-dap"
    },

    config = function()
      require "custom.configs.dap-vscode"
    end
  },

  {
    "microsoft/vscode-js-debug",

    lazy = false,

    dependencies = {
      "nvim-dap"
    },

    build = "rm -rf dist out package-lock.json && npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
  },

  {
    "kylechui/nvim-surround",

    version = "*",

    event = "VeryLazy",

    config = function()
      require "nvim-surround".setup(
        require "custom.configs.nvim-surround"
      )
    end,

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
    }
  },

  {
    "windwp/nvim-ts-autotag",

    lazy = false,

    dependencies = {
      "nvim-treesitter/nvim-treesitter"
    },

    config = function()
      require "nvim-ts-autotag".setup(
        require "custom.configs.nvim-ts-autotag"
      )
    end
  },

  {
    "tpope/vim-fugitive",

    lazy = false,

    config = false
  },

  {
    "tpope/vim-rhubarb",

    lazy = false,

    config = false
  },

  {
    "nvim-tree/nvim-tree.lua",

    opts = require "custom.configs.nvimtree-c"
  },

  {
    "nvim-treesitter/nvim-treesitter",

    opts = require "custom.configs.treesitter-c"
  },

  {
    "L3MON4D3/LuaSnip",

    version = "2.*",

    dependencies = { "rafamadriz/friendly-snippets" },

    config = require "custom.configs.luasnip-c",

    build = "make install_jsregexp"
  },

  {
    "andweeb/presence.nvim",

    lazy = false,

    config = require "custom.configs.presence-c"
  }
}

return plugins
