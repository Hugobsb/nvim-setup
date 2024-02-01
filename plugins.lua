local plugins = {
  {
    "neovim/nvim-lspconfig",

    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      "SmiteshP/nvim-navic"
    },

    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },

  {
    'nvim-tree/nvim-web-devicons',

    opts = {
      override_by_filename = {
        ['cpt'] = {
          icon = '',
          name = 'EncryptedFiles',
        },
        ['http'] = {
          icon = '',
          name = 'HttpFiles'
        }
      },
    },
  },

  {
    'nvimdev/lspsaga.nvim',

    event = 'LspAttach',

    dependencies = {
      'nvim-treesitter/nvim-treesitter',  -- optional
      'nvim-tree/nvim-web-devicons',      -- optional
      'neovim/nvim-lspconfig'             -- optional
    },

    config = require "custom.configs.lspsaga",
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

    opts = require "custom.configs.mason"
  },

  {
    "nvim-telescope/telescope.nvim",

    dependencies = {
      "nvim-telescope/telescope-live-grep-args.nvim",
    },

    opts = require "custom.configs.telescope",
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
        require "custom.configs.dapui"
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

    event = {
      "BufEnter *.js",
      "BufEnter *.js",
      "BufEnter *.jsx",
      "BufEnter *.ts",
      "BufEnter *.tsx"
    },

    dependencies = {
      "nvim-dap"
    },

    build = "rm -rf dist out && npm ci --cache .npm && npx gulp vsDebugServerBundle && mv dist out"
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

    opts = require "custom.configs.nvimtree"
  },

  {
    "nvim-treesitter/nvim-treesitter",

    opts = require "custom.configs.treesitter"
  },

  {
    "L3MON4D3/LuaSnip",

    version = "2.*",

    dependencies = { "rafamadriz/friendly-snippets" },

    config = require "custom.configs.luasnip",

    build = "make install_jsregexp"
  },

  {
    "andweeb/presence.nvim",

    lazy = false,

    config = require "custom.configs.presence"
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

    build = "cd app && yarn install --frozen-lockfile",

    ft = "markdown",

    event = {
      "BufEnter *.md"
    },

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

    config = function ()
      require "custom.configs.diffview"
    end
  },

  {
    "kevinhwang91/nvim-hlslens",

    version = "*",

    event = "BufEnter",

    config = true
  },

  {
    "lewis6991/gitsigns.nvim",

    version = "*",

    config = require "custom.configs.gitsigns"
  },

  {
    "petertriho/nvim-scrollbar",

    version = "*",

    event = "BufEnter",

    dependencies = {
      "kevinhwang91/nvim-hlslens",
      "lewis6991/gitsigns.nvim"
    },

    config = require "custom.configs.nvim-scrollbar"
  },

  {
    "gorbit99/codewindow.nvim",

    version = "*",

    event = "BufEnter",

    config = function(_, opts)
      local codewindow = require "codewindow"
      codewindow.setup(opts)
      codewindow.apply_default_keybinds()
    end,

    opts = require "custom.configs.codewindow",
  },

  {
    'Bekaboo/dropbar.nvim',

    version = "*",

    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim'
    },

    event = "BufEnter",

    config = true
  },

  {
    'NeogitOrg/neogit',

    lazy = false,

    dependencies = {
      'nvim-lua/plenary.nvim',         -- required
      'nvim-telescope/telescope.nvim', -- optional
      'sindrets/diffview.nvim',        -- optional
      'ibhagwan/fzf-lua',              -- optional
    },

    config = function()
      require "custom.configs.neogit"
    end
  },

  {
    "rcarriga/nvim-notify",

    version = "*",

    dependencies = {
      "nvim-treesitter/nvim-treesitter",  -- optional
    },

    event = "BufEnter",

    config = function()
      require "custom.configs.notify"
    end
  },

  {
    "rmagatti/auto-session",

    version = "*",

    lazy = false,

    config = require "custom.configs.auto-session"
  },

  {
    "stevearc/dressing.nvim",

    version = "*",

    lazy = false,

    config = require "custom.configs.dressing"
  },

  {
    "hrsh7th/nvim-cmp",

    opts = {
      preselect = "none",
      completion = {
        autocomplete = false
      }
    },
  },

  {
    "junegunn/fzf.vim",

    version = "*",

    lazy = false
  },

  {
    "David-Kunz/jester",

    version = "*",

    event = {
      "BufEnter *.js",
      "BufEnter *.jsx",
      "BufEnter *.ts",
      "BufEnter *.tsx"
    },

    config = require "custom.configs.jester"
  },

  {
    "Hugobsb/ccryptor.nvim",

    version = "*",

    event = "BufEnter",

    opts = {
      dir_path = os.getenv('NVIM_SAFE_DIR') or os.getenv('HOME') .. '/Projects/safe/'
    }
  },

  {
    "rest-nvim/rest.nvim",

    version = "*",

    event = "BufEnter",

    config = require "custom.configs.rest"
  },
}

return plugins

