local null_ls = require "null-ls"
-- local helpers = require "null-ls.helpers"

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

local CODE_QUALITY_CHECKSTYLE_PATH = "./.code_quality/checkstyle_rules.xml"
-- local CODE_QUALITY_PMD_PATH = "/.code_quality/pmd_rules.xml"

local function with_file_verification(args, file_path)
  local file_exists = vim.fn.filereadable(file_path) == 1

  if not file_exists then
    return nil
  end

  return args
end

local function with_optional_activation(env_var, source)
  local is_activated = vim.fn.getenv(env_var) ~= "false"

  if is_activated then
    return source
  end

  return nil
end

-- custom sources

-- local detekt = {
--   name = "Detekt",
--   meta = {
--     url = "https://github.com/detekt/detekt",
--     description = "Static code analysis for Kotlin",
--   },
--   method = null_ls.methods.DIAGNOSTICS,
--   filetypes = { "kotlin" },
--   generator = null_ls.generator({
--     command = "detekt",
--     args = { "--input", "$FILENAME" },
--     from_stderr = true,
--     format = "line",
--     on_output = helpers.diagnostics.from_patterns({
--       {
--         pattern = [[.*:(%d+):(%d+): [%w-/]+ (.*)]],
--         groups = { "row", "col", "message" }
--       }
--     })
--   })
-- }
--
-- null_ls.register(detekt)

local sources = {
  formatting_beautysh,
  formatting_eslint_d,
  formatting.gofumpt,
  formatting.goimports,
  formatting.google_java_format.with {
    extra_args = {
      "--aosp",
      "--skip-sorting-imports",
      "--skip-removing-unused-imports",
    }
  },
  formatting.ktlint,
  formatting.prettierd,
  formatting.sql_formatter,
  formatting.yamlfix,

  code_actions_eslint_d, -- none-ls-extras
  code_actions.refactoring,

  with_optional_activation(
    "CODE_QUALITY_CHECKSTYLE",
    diagnostics.checkstyle.with {
      timeout = 20000,
      filetypes = { "java" },
      args = with_file_verification(
        function(params)
          return {
            "-f",
            "sarif",
            "-c",
            CODE_QUALITY_CHECKSTYLE_PATH,
            params.bufname
          }
        end,
        CODE_QUALITY_CHECKSTYLE_PATH
      )
    }
  ),
  diagnostics_eslint_d.with { filter = function(diagnostic) return diagnostic.code ~= nil end },
  -- diagnostics.ktlint,
  -- diagnostics.pmd.with {
  --   timeout = 20000,
  --   filetypes = { "java" },
  --   extra_args = with_file_verification(
  --     {
  --       "check",
  --       "--rulesets",
  --       CODE_QUALITY_PMD_PATH,
  --     },
  --     CODE_QUALITY_PMD_PATH
  --   ),
  -- },
  diagnostics.golangci_lint,
  diagnostics.tidy,

  completion.spell,
}

local config = {
  debug = false,
  sources = sources,
}

null_ls.setup(config)

return config

