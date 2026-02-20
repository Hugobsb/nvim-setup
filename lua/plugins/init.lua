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

    event = "BufReadPost",

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

    event = "VeryLazy",

    config = function()
      require "configs.dap"
    end
  },

  {
    "igorlfs/nvim-dap-view",

    event = "VeryLazy",

    dependencies = {
      "mfussenegger/nvim-dap"
    },

    config = function()
      require "configs.dap-interface"
    end
  },

  {
    "theHamsta/nvim-dap-virtual-text",

    event = "VeryLazy",

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

    ft = "go",

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

    ft = "java",

    dependencies = {
      "mfussenegger/nvim-dap",
      "neovim/nvim-lspconfig"
    },
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

    opts = require "configs.nvim-surround",

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

    event = "VeryLazy",

    config = false
  },

  {
    "nvim-tree/nvim-tree.lua",

    opts = require "configs.nvimtree"
  },

  {
    "nvim-treesitter/nvim-treesitter",

    branch = "main",

    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main"
      }
    },

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

    event = "VeryLazy",

    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = true
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

    event = "BufReadPost",

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
    "sindrets/diffview.nvim",

    version = "*",

    event = "VeryLazy",

    config = function ()
      require "configs.diffview"
    end
  },

  {
    "kevinhwang91/nvim-hlslens",

    version = "*",

    event = "BufReadPost",

    config = true
  },

  {
    "lewis6991/gitsigns.nvim",

    version = "*",

    opts = {}
  },

  {
    "petertriho/nvim-scrollbar",

    version = "*",

    event = "BufReadPost",

    dependencies = {
      "kevinhwang91/nvim-hlslens",
      "lewis6991/gitsigns.nvim"
    },

    opts = require "configs.nvim-scrollbar"
  },


  {
    "Bekaboo/dropbar.nvim",

    version = "*",

    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim'
    },

    event = "BufReadPost",

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

    event = "VeryLazy",

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

    config = true
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

  {
    "Hugobsb/ccryptor.nvim",

    version = "*",

    event = "VeryLazy",

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

    version = "0.34.1",

    event = {
      "BufEnter *.java"
    },

    dependencies = {
      "nvim-neotest/neotest",
      "mfussenegger/nvim-jdtls",
      "mfussenegger/nvim-dap",
    },

    build = function(plugin)
      require("patches").apply(plugin)
    end,
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

    event = "BufReadPost",

    config = true
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
  },

  {
    "folke/sidekick.nvim",

    event = "VeryLazy",

    opts = require "configs.sidekick".opts,

    keys = require "configs.sidekick".keys,
  }
}

utils.mutate_lazy_plugins_list_with_ssh_prefix(plugins)

return plugins
