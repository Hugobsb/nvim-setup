require "nvchad.options"

local utils = require "utils"

----------------------------------- globals ----------------------------------------

vim.g.neovide_cursor_vfx_mode = 'pixiedust'

--------------------------------- manual sets --------------------------------------

-- Enable diagnostic severity sort
-- without it, functionalities like Lspsaga show_line_diagnostics does not work
vim.diagnostic.config({
  severity_sort = true,
})

-- Disable line wrapping
vim.opt.wrap = false

-- Set `session options` for the `auto-session` plugin
vim.opt.sessionoptions:append({ "winpos", "terminal", "folds" })

-- Set / as diff character
vim.opt.fillchars:append { diff = "╱" }

-- Disable behavior of automatically adding/removing a newline at the end of file when saving
vim.opt.fixeol = false

local is_wsl = false
if vim.fn.has("unix") == 1 and vim.fn.filereadable("/proc/version") == 1 then
  local f = io.open("/proc/version", "r")
  if f then
    is_wsl = f:read("*a"):find("WSL") ~= nil
    f:close()
  end
end

if is_wsl then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = true,
  }
end

------------------------------------ fonts -----------------------------------------

local default_font = os.getenv("NVIM_FONT") or 'FiraCode Nerd Font'
local default_font_size = 10

if vim.fn.has('gui_running') then
  if vim.fn.has('unix') then
    vim.opt.guifont = { default_font, ':h' .. default_font_size }
  else
    vim.opt.guifont = { default_font, 'h' .. default_font_size }
  end
end

----------------------------------- neovide ----------------------------------------

vim.opt.linespace = 6

vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0

vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_antialiasing = true

vim.g.neovide_floating_blur_amount_x = 5.0

vim.g.neovide_font_hinting = 'none'
vim.g.neovide_font_edging = 'subpixelantialias'

vim.g.neovide_transparency = 0.9

------------------------------ gui font commands -----------------------------------

if vim.fn.has('gui_running') then
  local new_cmd = vim.api.nvim_create_user_command

  new_cmd('IncreaseFontSize', function(cmd)
    local increase_by = tonumber(cmd.args)

    if increase_by ~= nil then
      return utils.resize_font_size(math.abs(increase_by))
    end

    return utils.resize_font_size(1)
  end, { nargs = "?" })

  new_cmd('DecreaseFontSize', function(cmd)
    local decrease_by = tonumber(cmd.args)

    if decrease_by ~= nil then
      return utils.resize_font_size(-math.abs(decrease_by))
    end

    return utils.resize_font_size(-1)
  end, { nargs = "?" })

  new_cmd('RestoreFontSize', function()
    return utils.resize_font_size(default_font_size, true)
  end, {})
end

--------------------------------- load modules -------------------------------------

require "commands"
require "bugfixes"
