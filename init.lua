vim.g.mapleader = " " -- space key

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    import = "plugins/core",
    lazy = false,
    config = function()
      require "options"
    end,
  },
  {
    import = "plugins",
  },
}, lazy_config)

vim.schedule(function()
  require "mappings"
end)

