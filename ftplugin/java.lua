vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

local ok, jdtls_config = pcall(require, "configs.nvim-jdtls")

if ok and jdtls_config.start then
  jdtls_config.start()
end
