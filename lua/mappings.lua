require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Tab remapping conflicts with C-I key binding that jumps forwardly in the jump history
-- Disabling this key mapping pointing it to itself fixes this issue
-- Note: this solution is not universal and only works for GUI or terminals that support modifyOtherKeys
-- See more at https://vimhelp.org/motion.txt.html#jump-motions
map("n", "<C-i>", "<C-i>", { desc = "Go forwardly in jumplist", noremap = true })

-- Lsp saga

map("n", "<leader>ca",  "<cmd> Lspsaga code_action <CR>", { desc =  "Open LSP Saga code action" })
map("n", "<leader>ca", "<cmd> Lspsaga code_action <CR>", { desc = "Open LSP Saga code action" })
map("n", "<leader>o", "<cmd> Lspsaga outline <CR>", { desc = "Toggle LSP Saga outline" })
map("n", "<leader>wd", "<cmd> Lspsaga show_workspace_diagnostics <CR>", { desc = "Show LSP Saga workspace diagnostics" })
map("n", "<leader>f", "<cmd> Lspsaga show_cursor_diagnostics <CR>", { desc = "Show LSP Saga cursor diagnostics", noremap = true })
map("n", "<leader>ld", "<cmd> Lspsaga show_line_diagnostics <CR>", { desc = "Show LSP Saga line diagnostics" })
map("n", "<leader>zd", "<cmd> Lspsaga show_buf_diagnostics <CR>", { desc = "Show LSP Saga current buffer diagnostics" })
map("n", "<leader>fd", "<cmd> Lspsaga finder <CR>", { desc = "Open LSP Saga finder" })
map("n", "<leader>ic", "<cmd> Lspsaga incoming_calls <CR>", { desc = "Open LSP Saga incoming calls" })
map("n", "<leader>oc", "<cmd> Lspsaga incoming_calls <CR>", { desc = "Open LSP Saga outcoming calls" })
map("n", "gp", "<cmd> Lspsaga peek_definition <CR>", { desc = "Open LSP Saga definition peek" })
map("n", "gP", "<cmd> Lspsaga peek_type_definition <CR>", { desc = "Open LSP Saga type definition peek" })

-- Neogit

map("n", "<leader>ng", "<cmd> Neogit  <CR>", { desc =  "Open Neogit" })

-- Dap

map("n", "<F5>", "<cmd> lua require'dap'.continue() <CR>", { desc = "Debug controls | Continue" })
map("n", "<F10>", "<cmd> lua require'dap'.step_over() <CR>", { desc = "Debug controls | Step over" })
map("n", "<F11>", "<cmd> lua require'dap'.step_into() <CR>", { desc = "Debug controls | Step into" })
map("n", "<F12>", "<cmd> lua require'dap'.step_out() <CR>", { desc = "Debug controls | Step out" })
map("n", "<leader>bp", "<cmd> lua require'dap'.toggle_breakpoint() <CR>", { desc = "Toggle line breakpoint" })
map("n", "<leader>BP", "<cmd> lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) <CR>", { desc = "Set line conditional breakpoint" })
map("n", "<leader>lp", "<cmd> lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) <CR>", { desc = "Set line conditional breakpoint for logging" })
map("n", "<leader>dr", "<cmd> lua require'dap'.repl.open() <CR>", { desc = "Open REPL" })

-- Dapui

map("n", "<leader>dpu", "<cmd> lua require'dapui'.open() <CR>", { desc = "Open debugger" })
map("n", "<leader>dpU", "<cmd> lua require'dapui'.close() <CR>", { desc = "Close debugger" })
map("n", "<leader>dpuk", "<cmd> lua require'dapui'.eval() <CR>", { desc = "Evaluate expression" })

-- Tabufline

map("n", "<leader>bm", "<cmd> lua require'nvchad.tabufline'.move_buf(1) <CR>", { desc = "Move tab forward" })
map("n", "<leader>bM", "<cmd> lua require'nvchad.tabufline'.move_buf(-1) <CR>", { desc = "Move tab backward" })

-- Diffview

map("n", "<leader>dv", "<cmd> DiffviewOpen <CR>", { desc = "Open diff view menu" })
map("n", "<leader>dvh", "<cmd> DiffviewFileHistory <CR>", { desc = "Open diff view file history menu" })
map("n", "<leader>dV", "<cmd> DiffviewClose <CR>", { desc = "Close diff view menu" })

-- Telescope

map("n", "<leader>fwa", "<cmd> lua require'telescope'.extensions.live_grep_args.live_grep_args() <CR>", { desc = "Live grep with custom arguments" })
map("n", "<leader>fs", "<cmd> lua require'auto-session.session-lens'.search_session() <CR>", { desc = "Search for sessions from `auto-session` plugin", })

-- Line movement mappings

map({ "n", "i" }, "<A-Up>", "<cmd> m-2 <CR>", { desc = "Move line upwards" })
map({ "n", "i" }, "<A-Down>", "<cmd> m+ <CR>", { desc = "Move line downwards" })
map({ "n", "i" }, "<A-k>", "<cmd> m-2 <CR>", { desc = "Move line upwards" })
map({ "n", "i" }, "<A-j>", "<cmd> m+ <CR>", { desc = "Move line downwards" })

-- NvChad does not set Marks in visual mode or something like that

vim.keymap.set('v', '<A-Up>', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<A-Down>', ":m '>+1<CR>gv=gv")

vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv")

-- Selection mappings

map("n", "<leader>a", "ggVG", { desc = "Select all" })

-- Font mappings

map({ "n", "i" }, "<A-=>", "<cmd> RestoreFontSize <CR>", { desc = "Restore font size" })
map({ "n", "i" }, "<C-=>", "<cmd> IncreaseFontSize <CR>", { desc = "Increase font size" })
map({ "n", "i" }, "<C-->", "<cmd> DecreaseFontSize <CR>", { desc = "Decrease font size" })

-- Autosession mappings

map("n", "<leader>ss", "<cmd> SessionSave <CR>", { desc = "Save a session" })
map("n", "<leader>sr", "<cmd> SessionSave <CR>", { desc = "Restore the last session" })

-- GitHub Copilot mappings

map(
  "i",
  "<C-l>",
  function()
    vim.fn.feedkeys(vim.fn['copilot#Accept'](), '')
  end,
  {
    desc = "Copilot accept suggestion",
    replace_keycodes = true,
    nowait = true,
    silent = true,
    expr = true,
    noremap = true
  }
)

-- Jester mappings

-- Run only
map("n", "<leader>jc", "<cmd> lua require'jester'.run() <CR>", { desc = "Run nearest test(s) under the cursor" })
map("n", "<leader>jf", "<cmd> lua require'jester'.run_file() <CR>", { desc = "Run test(s) in the current file" })
map("n", "<leader>jl", "<cmd> lua require'jester'.run_last() <CR>", { desc = "Run last test(s)" })

-- Run and debug
map("n", "<leader>jdc", "<cmd> lua require'jester'.debug() <CR>", { desc = "Debug nearest test(s) under the cursor" })
map("n", "<leader>jdf", "<cmd> lua require'jester'.debug_file() <CR>", { desc = "Debug test(s) in the current file" })
map("n", "<leader>jdl", "<cmd> lua require'jester'.debug_last() <CR>", { desc = "Debug last test(s)" })

-- Rest mappings

map("n", "<leader>rr", "<cmd> lua require'rest-nvim'.run() <CR>", { desc = "Run HTTP request" })
map("n", "<leader>rp", "<cmd> lua require'rest-nvim'.run(true) <CR>", { desc = "Preview HTTP request" })
map("n", "<leader>rl", "<cmd> lua require'rest-nvim'.last() <CR>", { desc = "Run last HTTP request" })
-- Currently the file run is glitched and cannot be run twice, but it's a plugin issue
map("n", "<leader>rf", "<cmd> lua require'rest-nvim'.last() <CR>", { desc = "Select HTTP request file to run" })

-- Dropbar mappings

map("n", "<leader>db", "<cmd> lua require'dropbar.api'.pick() <CR>", { desc = "Enter dropbar interactive pick mode" })

