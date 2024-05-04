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
    "kotlin-language-server",
    "lua-language-server",
    "typescript-language-server",
    "yaml-language-server",

    -- formatters
    "fixjson",
    "gofumpt",
    "goimports-reviser",
    "golines",
    "google-java-format",
    "ktlint",
    "prettierd",
    "xmlformatter",
    "yamlfix",

    -- linters / code actions
    "checkstyle",
    "detekt",
    "eslint_d",
  }
}

return config

