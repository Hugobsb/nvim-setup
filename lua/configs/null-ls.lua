local null_ls = require "null-ls"

local utils = require "utils"

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

local CODE_QUALITY_CHECKSTYLE_PATH = utils.get_first_existing_path({
  "./.code_quality/checkstyle_rules.xml",
  "./config/checkstyle/checkstyle.xml"
})

local CODE_QUALITY_PMD_PATH = utils.get_first_existing_path({
  "./config/pmd/pmd.xml",
  "./.code_quality/pmd_rules.xml"
})

local pmd_debug_notified = false

local sources = {
  formatting_beautysh,
  formatting_eslint_d,
  formatting.gofumpt,
  formatting.goimports,
  formatting.google_java_format.with {
    extra_args = {
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

  utils.with_optional_activation(
    "CODE_QUALITY_CHECKSTYLE",
    diagnostics.checkstyle.with {
      timeout = 20000,
      filetypes = { "java" },
      args = utils.with_file_verification(
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
  utils.with_optional_activation(
    "COMMITLINT_CONFIG_PATH",
    diagnostics.commitlint.with {
      extra_args = {
        "--config",
        vim.fn.getenv("COMMITLINT_CONFIG_PATH")
      }
    }
  ),
  diagnostics_eslint_d.with { filter = function(diagnostic) return diagnostic.code ~= nil end },
  diagnostics.pmd.with {
    timeout = 20000,
    filetypes = { "java" },
    args = utils.with_file_verification(
      {
        "check",
        "-f", "json",
        "-d", "$FILENAME",
        "-R", CODE_QUALITY_PMD_PATH,
        "--no-progress",
        "--no-cache",
      },
      CODE_QUALITY_PMD_PATH
    ),
    filter = function(diagnostic)
      if not pmd_debug_notified then
        pmd_debug_notified = true
        vim.notify(
          "There might be errors in the PMD file. Message: " .. diagnostic.message,
          vim.log.levels.WARN
        )
      end
      return diagnostic.code ~= "stderr"
    end,
  },
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

