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

      table.insert(modules, 10, get_tab_spaces())
      table.insert(modules, 12, get_line_break_encoding())
    end
  },
}

M.mappings = require "custom.mappings"

M.plugins = "custom.plugins"

return M

