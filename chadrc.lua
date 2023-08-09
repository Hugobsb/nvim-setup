---@type ChadrcConfig 

local M = {}

M.ui = {
  theme = "github_light",
  theme_toggle = { "github_light", "one_light" },

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
