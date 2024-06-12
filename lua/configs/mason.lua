local config = {
  ensure_installed = {
    -- servers
    "bash-language-server",
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
    "gofumpt",
    "goimports-reviser",
    "golines",
    "google-java-format",
    "ktlint",
    "prettierd",
    "sql-formatter",
    "yamlfix",

    -- linters / code actions
    "checkstyle",
    "detekt",
    "eslint_d",

    -- debug adapters
    "java-debug-adapter"
  }
}

return config

