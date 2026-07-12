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
    "terraform-ls",
    "typescript-language-server",
    "yaml-language-server",

    -- formatters
    "gofumpt",
    "goimports",
    "google-java-format",
    "ktlint",
    "prettierd",
    "sql-formatter",
    "terraform",
    "yamlfix",

    -- linters / code actions
    "checkstyle",
    "commitlint",
    "detekt",
    "eslint_d",
    "golangci-lint-langserver",

    -- debug adapters
    "codelldb",
    "js-debug-adapter",
    "java-debug-adapter",
    "go-debug-adapter"
  }
}

return config

