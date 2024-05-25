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
    "beautysh",
    "fixjson",
    "gofumpt",
    "goimports-reviser",
    "golines",
    "google-java-format",
    "ktlint",
    "prettierd",
    "sql-formatter",
    "stylua",
    "xmlformatter",
    "yamlfix",

    -- linters / code actions
    "checkstyle",
    "detekt",
    "eslint_d",
  },

  PATH = "skip",

  ui = {
    icons = {
      package_pending = " ",
      package_installed = "󰄳 ",
      package_uninstalled = " 󰚌",
    },

    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
      cancel_installation = "<C-c>",
    },
  },

  max_concurrent_installers = 10,
}

return config

