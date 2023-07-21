local M = {}

M.disabled = {
  n = {
    ["<leader>gt"] = "",
    ["<leader>cm"] = ""
  }
}

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
    ["<leader>b"] = { "<cmd> lua require'dap'.toggle_breakpoint()<CR>" },
    ["<leader>B"] = { "<cmd> lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>" },
    ["<leader>lp"] = { "<cmd> lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>" },
    ["<leader>dr"] = { "<cmd> lua require'dap'.repl.open()<CR>" },
  }
}

M.dapui = {
  n = {
    ["<leader>dpu"] = { "<cmd> lua require'dapui'.open()<CR>" }
  }
}

return M

