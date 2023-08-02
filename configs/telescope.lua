local previewers = require('telescope.previewers')
local builtin = require('telescope.builtin')

local config = {}

local delta = previewers.new_termopen_previewer {
  get_command = function(entry)
    -- this is for status
    -- You can get the AM things in entry.status. So we are displaying file if entry.status == '??' or 'A '
    -- just do an if and return a different command
    if entry.status == '??' or 'A ' then
      return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value }
    end

    -- note we can't use pipes
    -- this command is for git_commits and git_bcommits
    return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value .. '^!' }

  end
}

Delta_my_git_commits = function(opts)
  opts = opts or {}
  opts.previewer = delta

  builtin.git_commits(opts)
end

Delta_my_git_bcommits = function(opts)
  opts = opts or {}
  opts.previewer = delta

  builtin.git_bcommits(opts)
end

Delta_my_git_status = function(opts)
  opts = opts or {}
  opts.previewer = delta

  builtin.git_status(opts)
end

vim.api.nvim_set_keymap("n", "<leader>dcm", "<cmd>lua Delta_my_git_commits()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dbcm", "<cmd>lua Delta_my_git_bcommits()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dgt", "<cmd>lua Delta_my_git_status()<CR>", { noremap = true })

config.defaults = {}
config.extensions_list = { "live_grep_args" }

return config

