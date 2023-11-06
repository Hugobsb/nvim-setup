local M = {}

-- General

M.general = {
  n = {
    -- Tab remapping conflicts with C-I key binding that jumps forwardly in the jump history
    -- Disabling this key mapping pointing it to itself fixes this issue
    -- Note: this solution is not universal and only works for GUI or terminals that support modifyOtherKeys
    -- See more at https://vimhelp.org/motion.txt.html#jump-motions
    ["<C-i>"] = { "<C-i>", "Go forwardly in jumplist", { noremap = true } },
  }
}

-- Lsp saga

M.lspsaga = {
  n = {
    ["<leader>ca"] = { "<cmd> Lspsaga code_action <CR>", "Open LSP Saga code action" },
    ["<leader>o"] = { "<cmd> Lspsaga outline <CR>", "Toggle LSP Saga outline" },
    ["<leader>wd"] = { "<cmd> Lspsaga show_workspace_diagnostics <CR>", "Show LSP Saga workspace diagnostics" },
    ["<leader>f"] = { "<cmd> Lspsaga show_cursor_diagnostics <CR>", "Show LSP Saga cursor diagnostics", { noremap = true } },
    ["<leader>ld"] = { "<cmd> Lspsaga show_line_diagnostics <CR>", "Show LSP Saga line diagnostics" },
    ["<leader>zd"] = { "<cmd> Lspsaga show_buf_diagnostics <CR>", "Show LSP Saga current buffer diagnostics" },
    ["<leader>fd"] = { "<cmd> Lspsaga finder <CR>", "Open LSP Saga finder" },
    ["<leader>ic"] = { "<cmd> Lspsaga incoming_calls <CR>", "Open LSP Saga incoming calls" },
    ["<leader>oc"] = { "<cmd> Lspsaga incoming_calls <CR>", "Open LSP Saga outcoming calls" },
    ["gp"] = { "<cmd> Lspsaga peek_definition <CR>", "Open LSP Saga definition peek" },
    ["gP"] = { "<cmd> Lspsaga peek_type_definition <CR>", "Open LSP Saga type definition peek" }
  }
}

-- Neogit

M.neogit = {
  n = {
    ["<leader>ng"] = { "<cmd> Neogit  <CR>" , "Open Neogit" }
  }
}

-- Dap

M.dap = {
  n = {
    ["<F5>"] = { "<cmd> lua require'dap'.continue() <CR>", "Debug controls | Continue" },
    ["<F10>"] = { "<cmd> lua require'dap'.step_over() <CR>", "Debug controls | Step over" },
    ["<F11>"] = { "<cmd> lua require'dap'.step_into() <CR>", "Debug controls | Step into" },
    ["<F12>"] = { "<cmd> lua require'dap'.step_out() <CR>", "Debug controls | Step out" },
    ["<leader>bp"] = { "<cmd> lua require'dap'.toggle_breakpoint() <CR>", "Toggle line breakpoint" },
    ["<leader>BP"] = { "<cmd> lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) <CR>", "Set line conditional breakpoint" },
    ["<leader>lp"] = { "<cmd> lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) <CR>", "Set line conditional breakpoint for logging" },
    ["<leader>dr"] = { "<cmd> lua require'dap'.repl.open() <CR>", "Open REPL" },
  }
}

M.dapui = {
  n = {
    ["<leader>dpu"] = { "<cmd> lua require'dapui'.open() <CR>", "Open debugger" },
    ["<leader>dpU"] = { "<cmd> lua require'dapui'.close() <CR>", "Close debugger" },
    ["<leader>dpuk"] = { "<cmd> lua require'dapui'.eval() <CR>", "Evaluate expression" },
  }
}

-- Tabufline

M.tabufline = {
  n = {
    ["<leader>bm"] = { "<cmd> lua require'nvchad.tabufline'.move_buf(1) <CR>", "Move tab forward" },
    ["<leader>bM"] = { "<cmd> lua require'nvchad.tabufline'.move_buf(-1) <CR>", "Move tab backward" },
  }
}

-- Diffview

M.diffview = {
  n = {
    ["<leader>dv"] = { "<cmd> DiffviewOpen <CR>", "Open diff view menu" },
    ["<leader>dvh"] = { "<cmd> DiffviewFileHistory <CR>", "Open diff view file history menu" },
    ["<leader>dV"] = { "<cmd> DiffviewClose <CR>", "Close diff view menu" }
  }
}

-- Telescope

M.telescope = {
  n = {
    ["<leader>fwa"] = {
      "<cmd> lua require'telescope'.extensions.live_grep_args.live_grep_args() <CR>",
      "Live grep with custom arguments"
    },
    ["<leader>fs"] = {
      "<cmd> lua require'auto-session.session-lens'.search_session() <CR>",
      "Search for sessions from `auto-session` plugin",
    },
  }
}

-- Line movement mappings

M.linemovement = {
  n = {
    ["<A-Up>"] = { "<cmd> m-2 <CR>", "Move line upwards" },
    ["<A-Down>"] = { "<cmd> m+ <CR>", "Move line downwards" },
    ["<A-k>"] = { "<cmd> m-2 <CR>", "Move line upwards" },
    ["<A-j>"] = { "<cmd> m+ <CR>", "Move line downwards" }
  },
  i = {
    ["<A-Up>"] = { "<Esc> <cmd> m-2 <CR>i", "Move line upwards" },
    ["<A-Down>"] = { "<Esc> <cmd> m+ <CR>i", "Move line downwards" },
    ["<A-k>"] = { "<Esc> <cmd> m-2 <CR>i", "Move line upwards" },
    ["<A-j>"] = { "<Esc> <cmd> m+ <CR>i", "Move line downwards" }
  }
}

-- NvChad does not set Marks in visual mode or something like that

vim.keymap.set('v', '<A-Up>', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<A-Down>', ":m '>+1<CR>gv=gv")

vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv")

-- Selection mappings

M.selection = {
  n = {
    ["<leader>a"] = { "ggVG", "Select all" }
  },
}

-- Font mappings

M.font = {
  n = {
    ["<A-=>"] = { "<cmd> RestoreFontSize <CR>", "Restore font size" },
    ["<C-=>"] = { "<cmd> IncreaseFontSize <CR>", "Increase font size" },
    ["<C-->"] = { "<cmd> DecreaseFontSize <CR>", "Decrease font size" }
  },
  i = {
    ["<A-=>"] = { "<cmd> RestoreFontSize <CR>", "Restore font size" },
    ["<C-=>"] = { "<cmd> IncreaseFontSize <CR>", "Increase font size" },
    ["<C-->"] = { "<cmd> DecreaseFontSize <CR>", "Decrease font size" }
  }
}

M.autosession = {
  n = {
    ["<leader>ss"] = { "<cmd> SessionSave <CR>", "Save a session" },
    ["<leader>sr"] = { "<cmd> SessionSave <CR>", "Restore the last session" },
  }
}

return M

