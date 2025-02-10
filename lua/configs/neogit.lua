local M = {}

M.setup = function(opts)
  opts.console_timeout = 10000

  require("neogit").setup(opts)

  -- Custom highlight groups
  -- AFAIK these cannot be set in NvChad `hl_override` due to its lifecycle

  vim.api.nvim_set_hl(0, "NeogitDiffAdd", { bg = "#62693e" })
  vim.api.nvim_set_hl(0, "NeogitDiffDelete", { bg = "#722529" })

  vim.api.nvim_set_hl(0, "NeogitDiffHeaderHighlight", { fg = "#fe8019", bg = "#404040" })
  vim.api.nvim_set_hl(0, "NeogitDiffHeader", { fg = "#8ec07c", bg = "#404040" })
  vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight", { fg = "#fb4934", bg = "#722529" })
  vim.api.nvim_set_hl(0, "NeogitDiffContextHighlight", { bg = "#363636" })
  vim.api.nvim_set_hl(0, "NeogitDiffContext", { bg = "#2c2c2c" })
  vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight", { fg = "#b8bb26", bg = "#62693e" })
end

return M
