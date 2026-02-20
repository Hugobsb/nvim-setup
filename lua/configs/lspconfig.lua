local nvchad_config = require("nvchad.configs.lspconfig")

local navic = require "nvim-navic"


local function mergeTables(dest, src)
  for key, value in pairs(src) do
    if type(value) == "table" and type(dest[key]) == "table" then
      mergeTables(dest[key], value)
    else
      dest[key] = value
    end
  end
end

local data_dir = vim.fn.stdpath("data")

local servers = {
  ['bashls'] = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh", "bash", "zsh", "ksh" }
  },
  ['cssls'] = {
    filetypes = { "css" }
  },
  ['docker_compose_language_service'] = {
    root_markers = { 'docker-compose.yaml', 'docker-compose.yml', 'compose.yaml', 'compose.yml' },
    filetypes = { 'yaml.docker-compose' },
    single_file_support = true,
  },
  ['dockerls'] = {
    filetypes = { "dockerfile" }
  },
  ['gopls'] = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    settings = {
      gopls = {
        completeUnimported = true,
        gofumpt = true,
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
  ['jsonls'] = {
    filetypes = { "json", "jsonc" },
    settings = {
      json = {
        validate = {
          enable = true,
        },
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
    root_markers = { ".gradlew", ".git", "mvnw" },
    filetypes = { "kt", "kts" },
    cmd = { data_dir .. "/mason/bin/kotlin-language-server" },
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
          library = { vim.env.VIMRUNTIME },
          checkThirdParty = false,
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
  ['yamlls'] = {
    filetypes = { "yaml", "yml" }
  }
}

for lsp, config in pairs(servers) do
  local setup_config = {
    capabilities = nvchad_config.capabilities,

    on_init = function(client, bufnr)
      -- Forcefully enable semantic tokens - NvChad disables it

      local semanticTokensProvider = client.server_capabilities.semanticTokensProvider

      nvchad_config.on_init(client, bufnr)

      client.server_capabilities.semanticTokensProvider = semanticTokensProvider
    end,
    on_attach = function(client, bufnr)
      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end

      nvchad_config.on_attach(client, bufnr)

      require("utils").override_code_action_with_lspsaga(bufnr)
    end,
  }

  mergeTables(setup_config, config)

  vim.lsp.config(lsp, setup_config)
  vim.lsp.enable(lsp)
end

