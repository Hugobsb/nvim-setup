local M = {}

M.disabled = {
  n = {
    ["<Tab>"] = ""
  }
}

-- General

M.general = {
  n = {
    -- Tab remapping conflicts with C-I key binding that jumps forwardly in the jump history
    -- Disabling this key mapping pointing it to itself fixes this issue
    -- Note: this solution is not universal and only works for GUI or terminals that support modifyOtherKeys
    -- See more at https://vimhelp.org/motion.txt.html#jump-motions
    ["<C-i>"] = { "<C-i>", { noremap = true } },
  }
}

-- Lazy Git

local OpenLazyGit = { ["<leader>lg"] = { "<cmd> LazyGit  <CR>" , "Open LazyGit" } }

M.lazygit = {
  n = OpenLazyGit,
  t = OpenLazyGit
}

-- Dap

M.dap = {
  n = {
    ["<F5>"] = { "<cmd> lua require'dap'.continue() <CR>" },
    ["<F10>"] = { "<cmd> lua require'dap'.step_over() <CR>" },
    ["<F11>"] = { "<cmd> lua require'dap'.step_into() <CR>" },
    ["<F12>"] = { "<cmd> lua require'dap'.step_out() <CR>" },
    ["<leader>bp"] = { "<cmd> lua require'dap'.toggle_breakpoint() <CR>" },
    ["<leader>BP"] = { "<cmd> lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) <CR>" },
    ["<leader>lp"] = { "<cmd> lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) <CR>" },
    ["<leader>dr"] = { "<cmd> lua require'dap'.repl.open() <CR>" },
  }
}

M.dapui = {
  n = {
    ["<leader>dpu"] = { "<cmd> lua require'dapui'.open() <CR>" },
    ["<leader>dpU"] = { "<cmd> lua require'dapui'.close() <CR>" },
    ["<leader>dpuk"] = { "<cmd> lua require'dapui'.eval() <CR>" },
  }
}

-- Tabufline

M.tabufline = {
  n = {
    ["<C-Tab>"] = { "<cmd> lua require'nvchad.tabufline'.tabuflineNext() <CR>" },
    ["<leader>bm"] = { "<cmd> lua require'nvchad.tabufline'.move_buf(1) <CR>" },
    ["<leader>bM"] = { "<cmd> lua require'nvchad.tabufline'.move_buf(-1) <CR>" },
  }
}

M.telescope = {
  n = {
    ["<leader>fwa"] = { "<cmd> lua require'telescope'.extensions.live_grep_args.live_grep_args() <CR>" }
  }
}

-- Line movement mappings

M.linemovement = {
  n = {
    ["<A-Up>"] = { "<cmd> m-2 <CR>" },
    ["<A-Down>"] = { "<cmd> m+ <CR>" },
    ["<A-k>"] = { "<cmd> m-2 <CR>" },
    ["<A-j>"] = { "<cmd> m+ <CR>" }
  },
  i = {
    ["<A-Up>"] = { "<Esc> <cmd> m-2 <CR>i" },
    ["<A-Down>"] = { "<Esc> <cmd> m+ <CR>i" },
    ["<A-k>"] = { "<Esc> <cmd> m-2 <CR>i" },
    ["<A-j>"] = { "<Esc> <cmd> m+ <CR>i" }
  }
}

-- NvChad does not set Marks in visual mode or something like that

vim.keymap.set('v', '<A-Up>', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<A-Down>', ":m '>+1<CR>gv=gv")

vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv")

-- Selection mappings

M.selec = {
  n = {
    ["<leader>a"] = { "ggVG" }
  },
}

-- Font mappings

M.font = {
  n = {
    ["<A-=>"] = { "<cmd> RestoreFontSize <CR> " },
    ["<C-=>"] = { "<cmd> IncreaseFontSize <CR> " },
    ["<C-->"] = { "<cmd> DecreaseFontSize <CR> " }
  },
  i = {
    ["<A-=>"] = { "<cmd> RestoreFontSize <CR> " },
    ["<C-=>"] = { "<cmd> IncreaseFontSize <CR> " },
    ["<C-->"] = { "<cmd> DecreaseFontSize <CR> " }
  }
}

return M

