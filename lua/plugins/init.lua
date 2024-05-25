return {
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

    event = "VeryLazy",

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

    config = function(_, opts)
      require("neogit").setup(opts)

      -- Custom highlight groups
      -- AFAIK these cannot be set in NvChad `hl_override` due to its lifecycle

      vim.api.nvim_set_hl(0, "NeogitDiffAdd", { bg = "#62693e" })
      vim.api.nvim_set_hl(0, "NeogitDiffDelete", { bg = "#722529" })

      vim.api.nvim_set_hl(0, "NeogitDiffHeaderHighlight", { fg = "#fe8019", bg = "#404040" })
      vim.api.nvim_set_hl(0, "NeogitDiffHeader", { fg = "#8ec07c", bg = "#404040" })
      vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight", { fg = "#fb4934", bg = "#722529" })
      vim.api.nvim_set_hl(0, "NeogitDiffContextHighlight", { bg = "#363636" })
      vim.api.nvim_set_hl(0, "NeogitDiffContext", { bg = "#2c2c2c" })
      vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight", { fg = "#b8bb26", bg = "#62693e" })
    end
  },

  {
    "rcarriga/nvim-notify",

    version = "*",

    dependencies = {
      "nvim-treesitter/nvim-treesitter",  -- optional
    },

    event = "BufEnter",

    opts = {
      background_colour = "#000000"
    },

    config = function(_, opts)
      local notify = require "notify"

      notify.setup(opts)

      vim.notify = notify
    end
  },

  {
    "stevearc/dressing.nvim",

    version = "*",

    lazy = false,

    config = require "configs.dressing"
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

    dependencies = {
      {
        "vhyrro/luarocks.nvim",
        priority = 1000,
        config = true,
        opts = {
          rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }
        }
      },
    },

    config = function()
      require("rest-nvim").setup()
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

  -- {
  --   "simrat39/rust-tools.nvim",
  --
  --   ft = "rust",
  --
  --   dependencies = "neovim/nvim-lspconfig",
  --
  --   opts = function(_, opts)
  --     require "rust-tools".setup(opts)
  --   end
  -- },

  {
    "kndndrj/nvim-dbee",

    dependencies = {
      "MunifTanjim/nui.nvim",
    },

    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      xpcall(
        ---@diagnostic disable-next-line: param-type-mismatch
        require("dbee").install(), -- Try to detect install method
        function()
          require("dbee").install("curl") -- Fallback to curl in case of errors
        end
      )
    end,

    config = true,
  },

  {
    "tpope/vim-obsession",

    lazy = false,

    config = function()
      require "configs.obsession"
    end
  },

  {
    "ThePrimeagen/harpoon",

    branch = "harpoon2",

    lazy = false,

    config = function()
      require("configs.harpoon")
    end,

    dependencies = { "nvim-lua/plenary.nvim" }
  },
}

