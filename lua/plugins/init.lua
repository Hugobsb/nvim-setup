return {
  {
    "stevearc/conform.nvim",

    -- event = 'BufWritePre' -- uncomment for format on save

    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",

    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      "SmiteshP/nvim-navic"
    },

    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
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

    config = require "configs.lspsaga",
  },

  {
    "jose-elias-alvarez/null-ls.nvim",

    event = "BufEnter",

    dependencies = {
      "nvim-lua/plenary.nvim"
    },

    config = function()
      require "configs.null-ls"
    end
  },

  {
    "williamboman/mason.nvim",

    opts = require "configs.mason"
  },

  {
    "nvim-telescope/telescope.nvim",

    dependencies = {
      "nvim-telescope/telescope-live-grep-args.nvim",
    },

    opts = require "configs.telescope",
  },

  {
    "mfussenegger/nvim-dap",

    event = "BufEnter",

    config = function()
      require "configs.dap"
    end
  },

  {
    "rcarriga/nvim-dap-ui",

    event = "BufEnter",

    dependencies = {
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap"
    },

    config = function()
      require "dapui".setup(
        require "configs.dapui"
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
        require "configs.dap-virtual-text"
      )
    end
  },

  {
    "mxsdev/nvim-dap-vscode-js",

    event = {
      "BufEnter *.ts",
      "BufEnter *.tsx",
      "BufEnter *.js",
      "BufEnter *.jsx",
    },

    dependencies = {
      "nvim-dap"
    },

    config = function()
      require "dap"
      require "dap.utils"
      require "dap-vscode-js"
      require "configs.dap-vscode"
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
    "fwcd/kotlin-debug-adapter",

    event = {
      "BufEnter *.kt",
      "BufEnter *.kts"
    },

    build = "./gradlew :adapter:installDist",

    config = false,
  },

  {
    "kylechui/nvim-surround",

    version = "*",

    event = "VeryLazy",

    config = function()
      require "nvim-surround".setup(
        require "configs.nvim-surround"
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

    config = require "configs.nvim-ts-autotag"
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

    opts = require "configs.nvimtree"
  },

  {
    "nvim-treesitter/nvim-treesitter",

    opts = require "configs.treesitter"
  },

  {
    "L3MON4D3/LuaSnip",

    version = "2.*",

    dependencies = { "rafamadriz/friendly-snippets" },

    config = require "configs.luasnip",

    build = "make install_jsregexp"
  },

  {
    "Hugobsb/presence.nvim",

    lazy = false,

    config = require "configs.presence"
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

    config = require "configs.trouble"
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
      require "configs.diffview"
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

    config = require "configs.gitsigns"
  },

  {
    "petertriho/nvim-scrollbar",

    version = "*",

    event = "BufEnter",

    dependencies = {
      "kevinhwang91/nvim-hlslens",
      "lewis6991/gitsigns.nvim"
    },

    config = require "configs.nvim-scrollbar"
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

    opts = require "configs.codewindow",
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
      require "configs.neogit"
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
      require "configs.notify"
    end
  },

  {
    "rmagatti/auto-session",

    version = "*",

    lazy = false,

    config = require "configs.auto-session"
  },

  {
    "stevearc/dressing.nvim",

    version = "*",

    lazy = false,

    config = require "configs.dressing"
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

    config = require "configs.jester"
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
    "vhyrro/luarocks.nvim",

    config = function()
      require("luarocks").setup({})
    end
  },

  {
    "rest-nvim/rest.nvim",

    version = "*",

    ft = "http",

    dependencies = { "luarocks.nvim" },

    config = function()
      require "configs.rest"
    end
  },

  {
    "0x100101/lab.nvim",

    version = "*",


    event = {
      "BufEnter *.js",
      "BufEnter *.jsx",
      "BufEnter *.ts",
      "BufEnter *.tsx",
      "BufEnter *.py",
      "BufEnter *.lua"
    },

    build = "cd js && npm ci",

    dependencies = { "nvim-lua/plenary.nvim" },

    config = true
  },
}

