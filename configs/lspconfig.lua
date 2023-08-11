local lspconfig = require "lspconfig"

local on_attach = require "plugins.configs.lspconfig".on_attach
local capabilities = require "plugins.configs.lspconfig".capabilities

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
  ['tsserver'] = {
    cmd = { "/home/hugo/.local/share/nvim/mason/bin/typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
  },
  ['yamlls'] = {
    filetypes = { "yaml", "yml" }
  }
}

for lsp, config in pairs(servers) do
  local setup_config = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  mergeTables(setup_config, config)

  lspconfig[lsp].setup(setup_config)
end

