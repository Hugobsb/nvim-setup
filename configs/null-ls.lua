local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions
local lint = null_ls.builtins.diagnostics
-- local completion = null_ls.builtins.completion

local sources = {
  formatting.fixjson,
  formatting.gofumpt,
  formatting.goimports_reviser,
  formatting.golines,
  formatting.google_java_format,
  formatting.prettierd,
  formatting.xmlformat,
  formatting.yamlfix,

  code_actions.eslint_d,
  code_actions.refactoring,

  -- completion,
  lint.eslint_d,
  lint.checkstyle.with({
    extra_args = { "-c", "/google_checks.xml" } -- or "/sun_checks.xml" or path to self written rules
  }),
}

local config = {
  debug = false,
  sources = sources,
}

null_ls.setup(config)

return config

