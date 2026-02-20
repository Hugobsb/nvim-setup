require("diffview").setup({
  enhanced_diff_hl = true,
})

-- Custom highlight groups
-- These cannot be set in NvChad `hl_override` due to its lifecycle
vim.api.nvim_set_hl(0, "DiffviewDiffAddAsDelete", { bg = "#d73a49" })
vim.api.nvim_set_hl(0, "DiffviewDiffDelete", { link = "DiffDelete" })
