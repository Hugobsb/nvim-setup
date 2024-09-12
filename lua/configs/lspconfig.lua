-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local navic = require "nvim-navic"

local util = require "lspconfig/util"

local function mergeTables(dest, src)
  for key, value in pairs(src) do
    if type(value) == "table" and type(dest[key]) == "table" then
      mergeTables(dest[key], value)
    else
      dest[key] = value
    end
  end
end

local servers = {
  ['bashls'] = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh" }
  },
  ['cssls'] = {
    fileTypes = { "css" }
  },
  ['docker_compose_language_service'] = {
    rootDir = util.root_pattern("docker-compose.yaml", "docker-compose.yml"),
    filetypes = { "yaml", "yml" }
  },
  ['dockerls'] = {
    filetypes = { "dockerfile" }
  },
  ['gopls'] = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    rootDir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
        }
      }
    }
  },
  ['html'] = {
    filetypes = { "html" }
  },
  -- ['jdtls'] = {
  --   rootDir = util.root_pattern({ ".gradlew", ".git", "mvnw" }),
  --   cmd = {
  --     os.getenv("HOME") .. "/.local/share/nvim/mason/bin/jdtls",
  --     "--jvm-arg=-javaagent:" .. os.getenv("HOME") .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
  --     "--jvm-arg=-Xbootclasspath/a:" .. os.getenv("HOME") .. "/.config/nvim/plugins/jdtls/lombok.jar"
  --   },
  --   contentProvider = { preferred = "fernflower" },
  --   settings = {
  --     java = {
  --       signatureHelp = { enabled = true },
  --     },
  --   },
  --   filetypes = { "java" },
  -- },
  ['jsonls'] = {
    fileTypes = { "json", "jsonc" },
    settings = {
      json = {
        schemas = {
          {
            fileMatch = { "package.json" },
            url = "https://json.schemastore.org/package.json"
          },
          {
            fileMatch = { "tsconfig*.json" },
            url = "https://json.schemastore.org/tsconfig.json"
          }
        },
      },
    },
  },
  ['kotlin_language_server'] = {
    rootDir = util.root_pattern({ ".gradlew", ".git", "mvnw" }),
    fileTypes = { "kt", "kts" },
    cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/kotlin-language-server" },
  },
  ['lua_ls'] = {
    filetypes = { "lua" },
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using
          -- (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {
            'vim',
            'require'
          },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
  ['rust_analyzer'] = {
    filetypes = { "rust" },
    settings = {
      ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
        }
      }
    },
  },
  ['sqls'] = {
    cmd = { "sqls" },
    filetypes = { "sql", "mysql" }
  },
  ['tsserver'] = {
    cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
  },
  ['yamlls'] = {
    filetypes = { "yaml", "yml" }
  }
}

for lsp, config in pairs(servers) do
  local setup_config = {
    capabilities = capabilities,

    on_init = function(client, bufnr)
      -- Forcefully enable semantic tokens - NvChad disables it

      local semanticTokensProvider = client.server_capabilities.semanticTokensProvider

      on_init(client, bufnr)

      client.server_capabilities.semanticTokensProvider = semanticTokensProvider
    end,
    on_attach = function(client, bufnr)
      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end

      on_attach(client, bufnr)

      vim.keymap.del({ "n", "v" }, "<leader>ca", { buffer = bufnr })

      vim.keymap.set(
        { "n", "v" },
        "<leader>ca",
        "<cmd> Lspsaga code_action <CR>",
        { buffer = bufnr, desc = "LSP Code action", noremap = true }
      )
    end,
  }

  mergeTables(setup_config, config)

  lspconfig[lsp].setup(setup_config)
end
