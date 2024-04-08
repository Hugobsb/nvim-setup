local config = {
  ensure_installed = {
    -- servers
    "css-lsp",
    "docker-compose-language-service",
    "dockerfile-language-server",
    "gopls",
    "html-lsp",
    "jdtls",
    "json-lsp",
    "lua-language-server",
    "typescript-language-server",
    "yaml-language-server",

    -- formatters
    "fixjson",
    "gofumpt",
    "goimports-reviser",
    "golines",
    "google-java-format",
    "prettierd",
    "xmlformatter",
    "yamlfix",

    -- code actions
    "checkstyle",
    "eslint_d",
  }
}

return config

