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

    event = "BufEnter",

    dependencies = {
      "nvim-lua/plenary.nvim"
    },

    config = function()
      require "custom.configs.null-ls"
    end
  },

  {
    "williamboman/mason.nvim",

    opts = require "custom.configs.mason-c"
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
    end
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

    event = "BufEnter",

    config = function()
      require "custom.configs.dap"
    end
  },

  {
    "rcarriga/nvim-dap-ui",

    event = "BufEnter",

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

    event = "BufEnter",

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

    event = {
      "BufEnter *.ts",
      "BufEnter *.tsx",
      "BufEnter *.js",
      "BufEnter *.jsx"
    },

    dependencies = {
      "nvim-dap"
    },

    config = function()
      require "dap"
      require "dap.utils"
      require "dap-vscode-js"
      require "custom.configs.dap-vscode"
    end
  },

  {
    "microsoft/vscode-js-debug",

    event = "BufEnter",

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

    event = {
      "BufEnter *.html",
      "BufEnter *.tsx",
      "BufEnter *.jsx"
    },

    dependencies = {
      "nvim-treesitter/nvim-treesitter"
    },

    config = require "custom.configs.nvim-ts-autotag"
  },

  {
    "tpope/vim-fugitive",

    lazy = false,

    config = false
  },

  {
    "tpope/vim-rhubarb",

    event = "BufEnter",

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
  },

  {
    "wakatime/vim-wakatime",

    lazy = false,

    config = false
  },

  {
    "folke/trouble.nvim",

    event = "BufEnter",

    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = require "custom.configs.trouble"
  },

  {
    "iamcco/markdown-preview.nvim",

    build = "cd app && npm install",

    ft = "markdown",

    config = false
  },

  {
    "akinsho/git-conflict.nvim",

    version = "*",

    event = "BufEnter",

    config = true
  },

  {
    "simrat39/symbols-outline.nvim",

    version = "*",

    event = "BufEnter",

    config = true
  },

  {
    "github/copilot.vim",

    version = "*",

    event = "BufEnter",

    config = false
  },

  {
    "sindrets/diffview.nvim",

    version = "*",

    event = "BufEnter",

    config = true
  }
}

return plugins

