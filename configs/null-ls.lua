local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions
local lint = null_ls.builtins.diagnostics
-- local completion = null_ls.builtins.completion

local sources = {
  formatting.prettierd,
  formatting.gofumpt,
  formatting.goimports_reviser,
  formatting.golines,

  code_actions.refactoring,
  code_actions.eslint_d,

  -- completion,
  lint.eslint_d,
}

local config = {
  debug = true,
  sources = sources,
}

null_ls.setup(config)

return {}

