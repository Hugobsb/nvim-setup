local M = {}

-- Lazy Git

local OpenLazyGit = { ["<leader>lg"] = { "<cmd> LazyGit <CR>" , "Open LazyGit" } }

M.lazygit = {
  n = OpenLazyGit,
  t = OpenLazyGit
}

-- Dap

M.dap = {
  n = {
    ["<F5>"] = { "<cmd> lua require'dap'.continue()<CR>" },
    ["<F10>"] = { "<cmd> lua require'dap'.step_over()<CR>" },
    ["<F11>"] = { "<cmd> lua require'dap'.step_into()<CR>" },
    ["<F12>"] = { "<cmd> lua require'dap'.step_out()<CR>" },
    ["<leader>bp"] = { "<cmd> lua require'dap'.toggle_breakpoint()<CR>" },
    ["<leader>BP"] = { "<cmd> lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>" },
    ["<leader>lp"] = { "<cmd> lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>" },
    ["<leader>dr"] = { "<cmd> lua require'dap'.repl.open()<CR>" },
  }
}

M.dapui = {
  n = {
    ["<leader>dpu"] = { "<cmd> lua require'dapui'.open()<CR>" },
  }
}

-- Tabufline

M.tabufline = {
  n = {
    ["<leader>bm"] = { "<cmd> lua require'nvchad_ui.tabufline'.move_buf(1)<CR>" },
    ["<leader>bM"] = { "<cmd> lua require'nvchad_ui.tabufline'.move_buf(-1)<CR>" },
  }
}

M.telescope = {
  n = {
    ["<leader>fwa"] = { "<cmd> lua require'telescope'.extensions.live_grep_args.live_grep_args()<CR>" }
  }
}

return M

