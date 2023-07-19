local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

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
    -- configuration
  },
  ['docker_compose_language_service'] = {
    -- configuration
  },
  ['dockerls'] = {
    -- configuration
  },
  ['html'] = {
    -- configuration
  },
  ['tsserver'] = {
    cmd = { "/home/hugo/.local/share/nvim/mason/bin/typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
  },
  ['yamlls'] = {
    -- configuration
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

