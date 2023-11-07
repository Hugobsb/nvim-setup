---@diagnostic disable: undefined-global
---@diagnostic disable-next-line: undefined-doc-name
---@type ChadrcConfig 

local M = {}

M.ui = {
  theme = "chadracula",
  theme_toggle = { "chadracula", "one_light" },

  nvdash = {
    load_on_startup = true,
  },

  extended_integrations = { "navic" },

  hl_override = {
    ["St_cwd"] = {
      bg = "statusline_bg",
      fg = "#ffae00",
    },
  },

  lsp_semantic_tokens = true, -- needs nvim v0.9, just adds highlight groups for lsp semantic tokens

  statusline = {
    theme = "vscode_colored",
    overriden_modules = function(modules)
      local function get_tab_spaces()
        return "%#StText#Spaces: " .. vim.opt.tabstop:get() .. "  "
      end

      local function get_line_break_encoding()
        local encoding = vim.api.nvim_buf_get_option(0, 'fileformat')

        if (encoding == "unix") then
          return "LF  "
        end

        if (encoding == "dos") then
          return "CRLF  "
        end

        return encoding .. "  "
      end

      local function git()
        local has_buffer_branch = string.len(modules[3]) > 0

        if not has_buffer_branch then
          local directory_branch = vim.fn.system("git branch --show-current 2>/dev/null")

          -- Remove the empty character ^@ from the end of the function
          directory_branch = string.sub(directory_branch, 1, -2)

          if string.len(directory_branch) > 0 then
            return "  " .. directory_branch .. "  "
          end
        end

        return ""
      end

      table.insert(modules, 10, get_tab_spaces())
      table.insert(modules, 12, get_line_break_encoding())
      table.insert(modules, 4, git())

      -- Add an extra space to cwd ending
      table.insert(modules, 17, " ")
    end
  },

  cmp = {
    style = "atom_colored"
  },
}

M.mappings = require "custom.mappings"

M.plugins = "custom.plugins"

return M

