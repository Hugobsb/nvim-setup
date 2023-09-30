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

  statusline = {
    theme = "vscode_colored",
    overriden_modules = function(modules)
      local function get_breadcrumb()
        local is_navic_loaded, navic = xpcall(
          require,
          function() return false end,
          'nvim-navic'
        )

        if not is_navic_loaded then return "" end

        local location = navic.get_location()
        local minimum_screen_size = 200

        if (vim.o.columns > minimum_screen_size) then
          if (string.len(location) > 80) then
            return "%#StText#" .. string.sub(location, 1, 80) .. "..."
          end

          return "%#StText#" .. location
        end
      end


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

      table.insert(modules, 7, get_breadcrumb())

      table.insert(modules, 11, get_tab_spaces())
      table.insert(modules, 13, get_line_break_encoding())
    end
  },
}

M.mappings = require "custom.mappings"

M.plugins = "custom.plugins"

return M

