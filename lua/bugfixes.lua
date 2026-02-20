-- Treesitter markdown highlights query corruption from LSP hover
--
-- When Lspsaga hover_doc (or Neovim's LSP floating preview) renders markdown,
-- it calls vim.treesitter.query.set("markdown", "highlights", ...) with a
-- minimal conceal-only query. Since query.set() operates at the language level
-- (not buffer level), this globally replaces the highlights query for ALL
-- markdown buffers, breaking syntax highlighting until Neovim is restarted.
--
-- Fix: intercept query.set() and block replacements that would strip away the
-- real markdown highlights, leaving only conceal captures.

do
  local original_query_set = vim.treesitter.query.set

  vim.treesitter.query.set = function(lang, query_name, text)
    if lang == "markdown" and query_name == "highlights" and type(text) == "string" then
      if not text:match("@markup") then
        return
      end
    end

    return original_query_set(lang, query_name, text)
  end
end

-- Neogit message filetype

vim.api.nvim_create_augroup("neogit-additions", {})

vim.api.nvim_create_autocmd("FileType", {
  group = "neogit-additions",
  pattern = "NeogitCommitMessage",
  command = "silent! set filetype=gitcommit",
})

-- Copilot tab key

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

-- Neovide alt key for MacOS

vim.g.neovide_input_macos_alt_is_meta = true

-- Fix ugly highlight groups
vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
vim.api.nvim_set_hl(0, "DapUINormalNC", { bg = "NONE" })
