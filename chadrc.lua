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
  },
}

M.mappings = require "custom.mappings"

M.plugins = "custom.plugins"

return M
