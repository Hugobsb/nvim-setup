local config = {
  ensure_installed = {
    -- servers
    "css-lsp",
    "docker-compose-language-service",
    "dockerfile-language-server",
    "gopls",
    "html-lsp",
    "json-lsp",
    "typescript-language-server",
    "yaml-language-server",

    -- formatters
    "gofumpt",
    "goimports-reviser",
    "golines",
    "prettierd",
    "xmlformatter",
    "yamlfix",

    -- code actions
    "eslint_d",
  }
}

return config

