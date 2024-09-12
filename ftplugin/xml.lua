local bufnr = vim.api.nvim_get_current_buf()
local bufname = vim.api.nvim_buf_get_name(bufnr)
local basename = vim.fn.fnamemodify(bufname, ':t')

if basename == "pom.xml" then
  vim.o.tabstop = 4
  vim.o.softtabstop = 4
  vim.o.shiftwidth = 4
end
