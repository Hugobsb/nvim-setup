local null_ls = require "null-ls"
local helpers = require "null-ls.helpers"

local code_actions = null_ls.builtins.code_actions
local completion = null_ls.builtins.completion
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

-- none-ls-extras

-- eslint_d
local diagnostics_eslint_d = require("none-ls.diagnostics.eslint_d")
local formatting_eslint_d = require("none-ls.formatting.eslint_d")
local code_actions_eslint_d = require("none-ls.code_actions.eslint_d")

-- beauty_sh
local formatting_beautysh = require("none-ls.formatting.beautysh")

-- custom sources

local detekt = {
  name = "Detekt",
  meta = {
    url = "https://github.com/detekt/detekt",
    description = "Static code analysis for Kotlin",
  },
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { "kotlin" },
  generator = null_ls.generator({
    command = "detekt",
    args = { "--input", "$FILENAME" },
    from_stderr = true,
    format = "line",
    on_output = helpers.diagnostics.from_patterns({
      {
        pattern = [[.*:(%d+):(%d+): [%w-/]+ (.*)]],
        groups = { "row", "col", "message" }
      }
    })
  })
}

null_ls.register(detekt)

local sources = {
  formatting_beautysh,
  formatting_eslint_d,
  formatting.gofumpt,
  formatting.goimports_reviser,
  formatting.golines,
  formatting.google_java_format,
  formatting.ktlint,
  formatting.prettierd,
  formatting.sql_formatter,
  formatting.yamlfix,

  code_actions_eslint_d, -- none-ls-extras
  code_actions.refactoring,

  -- diagnostics
  diagnostics_eslint_d, -- none-ls-extras
  diagnostics.tidy,

  -- completion
  completion.spell,
}

local config = {
  debug = false,
  sources = sources,
}

null_ls.setup(config)

return config

