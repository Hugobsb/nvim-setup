local utils = require "utils"

local plugins = {
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
      "nvimtools/none-ls.nvim",
      "SmiteshP/nvim-navic"
    },

    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",

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
    "nvimdev/lspsaga.nvim",

    event = 'LspAttach',

    dependencies = {
      'nvim-treesitter/nvim-treesitter',  -- optional
      'nvim-tree/nvim-web-devicons',      -- optional
      'neovim/nvim-lspconfig'             -- optional
    },

    opts = require "configs.lspsaga",
  },

  {
    "nvimtools/none-ls.nvim",

    event = "BufEnter",

    dependencies = {
      "nvimtools/none-ls-extras.nvim",
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
    "igorlfs/nvim-dap-view",

    event = "BufEnter",

    dependencies = {
      "mfussenegger/nvim-dap"
    },

    config = function()
      require "configs.dap-interface"
    end
  },

  {
    "theHamsta/nvim-dap-virtual-text",

    event = "BufEnter",

    dependencies = {
      "mfussenegger/nvim-dap"
    },

    config = function()
      require "nvim-dap-virtual-text".setup(
        require "configs.dap-virtual-text"
      )
    end
  },

  {
    "leoluz/nvim-dap-go",

    version = "*",

    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "go-delve/delve",
        build = "go build github.com/go-delve/delve/cmd/dlv"
      },
    },

    BufEnter = {
      "*.go"
    },

    config = function()
      require("configs.dap-go")
    end
  },

  {
    "microsoft/java-debug",

    version = "*",

    build = "./mvnw clean install",
  },

  {
    "microsoft/vscode-java-test",

    version = "*",

    build = "npm ci && npm run build-plugin"
  },

  {
    "mfussenegger/nvim-jdtls",

    event = {
      "BufEnter *.java",
      "BufEnter *.class",
      "BufEnter *.jar"
    },

    dependencies = {
      "mfussenegger/nvim-dap",
      "neovim/nvim-lspconfig"
    },

    config = function()
      require "configs.nvim-jdtls"
    end,
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
    "github/copilot.vim",

    version = "v1.57.0",

    event = "VeryLazy",

    config = false
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",

    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },

    version = "*",

    event = "VeryLazy",

    build = "make tiktoken",

    opts = require "configs.copilotchat",
  },

  {
    "xTacobaco/cursor-agent.nvim",

    version = "*",

    event = "BufEnter",

    config = require "configs.cursor-agent"
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
    "Bekaboo/dropbar.nvim",

    version = "*",

    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim'
    },

    event = "BufEnter",

    config = true
  },

  {
    "NeogitOrg/neogit",

    lazy = false,

    dependencies = {
      'nvim-lua/plenary.nvim',         -- required
      'nvim-telescope/telescope.nvim', -- optional
      'sindrets/diffview.nvim',        -- optional
      'ibhagwan/fzf-lua',              -- optional
    },

    config = function(_, opts)
      require("configs.neogit").setup(opts)
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
    "hrsh7th/nvim-cmp",

    dependencies = {
      {
        "MattiasMTS/cmp-dbee",
        dependencies = {
          {"kndndrj/nvim-dbee"}
        },
        ft = "sql",
        config = function()
          require("cmp-dbee").setup({})
        end
      },
    },

    config = function(_, opts)
      table.insert(opts.sources, 5, { name = "cmp-dbee" })

      opts.preselect = "none";
      opts.completion.autocomplete = false

      require("cmp").setup(opts)
    end,
  },

  {
    "junegunn/fzf.vim",

    version = "*",

    lazy = false
  },

  -- {
  --   "David-Kunz/jester",
  --
  --   version = "*",
  --
  --   event = {
  --     "BufEnter *.js",
  --     "BufEnter *.jsx",
  --     "BufEnter *.ts",
  --     "BufEnter *.tsx"
  --   },
  --
  --   config = require "configs.jester"
  -- },

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

  {
    "axkirillov/hbac.nvim",

    lazy = false,

    opts = {
      autoclose = true,
      threshold = 100,
      close_buffers_with_windows = false,
    },
  },

  {
    "pwntester/octo.nvim",

    lazy = false,

    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      -- OR 'ibhagwan/fzf-lua',
      'nvim-tree/nvim-web-devicons',
    },

    opts = {
      suppress_missing_scope = {
        projects_v2 = true,
      },
      ssh_aliases = {
        ["github.com-personal"] = "github.com",
        ["github.com-emu"] = "github.com"
      }
    },
  },

  {
    "nvim-neotest/neotest",

    event = {
      "BufEnter *.go",
      "BufEnter *.java",
    },

    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },

    config = function()
      require("configs.neotest")
    end,
  },

  {
    "rcasia/neotest-java",

    version = "v0.23.8",

    event = {
      "BufEnter *.java"
    },

    dependencies = {
      "nvim-neotest/neotest",
      "mfussenegger/nvim-jdtls",
      "mfussenegger/nvim-dap",
    },
  },

  {
    "fredrikaverpil/neotest-golang",

    version = "*",

    event = {
      "BufEnter *.go"
    },

    dependencies = {
      "nvim-neotest/neotest",
      "leoluz/nvim-dap-go",
    },
  },

  {
    "nvim-neotest/neotest-jest",

    version = "*",

    event = {
      "BufEnter *.js",
      "BufEnter *.jsx",
      "BufEnter *.ts",
      "BufEnter *.tsx"
    },

    dependencies = {
      "nvim-neotest/neotest",
    },
  },

  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },

  {
    "pmizio/typescript-tools.nvim",

    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },

    event = {
      "BufEnter *.ts",
      "BufEnter *.tsx",
      "BufEnter *.js",
      "BufEnter *.jsx",
    },

    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.tstools"
    end
  },

  {
    "Darazaki/indent-o-matic",

    event = "BufEnter",

    config = function()
      require('indent-o-matic').setup {
        -- The values indicated here are the defaults

        -- Number of lines without indentation before giving up (use -1 for infinite)
        max_lines = 2048,

        -- Space indentations that should be detected
        standard_widths = { 2, 4, 8 },

        -- Skip multi-line comments and strings (more accurate detection but less performant)
        skip_multiline = true,
      }
    end
  },

  {
    "ethersync/ethersync-nvim",
    keys = { 
      { "<leader>ej", "<cmd>EthersyncJumpToCursor<cr>" },
      { "<leader>ef", "<cmd>EthersyncFollow<cr>" },
      { "<esc>", mode = { "n" }, "<cmd>EthersyncUnfollow<cr>" },
    },
    lazy = false,
    enabled = utils.with_optional_activation("ENABLE_ETHERSYNC", true) or false,
  },

  {
    "vuki656/package-info.nvim",

    dependencies = {
      "MunifTanjim/nui.nvim"
    },

    event = {
      "BufEnter package.json",
    },

    config = function()
      require("package-info").setup()
    end,
  }
}

utils.mutate_lazy_plugins_list_with_ssh_prefix(plugins)

return plugins

