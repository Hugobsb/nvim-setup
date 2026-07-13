require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

-- add yours here

pcall(function() nomap({ "n", "i" }, "<C-s>") end)
nomap("n", "<leader>fb")

map("n", ";", ":", { desc = "CMD enter command mode" })

-- hjkl movement

map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", function()
  local copilot_key = vim.fn['copilot#Accept']()

  if copilot_key ~= "" then
    -- Accept Copilot suggestion
    vim.fn.feedkeys(copilot_key, '')
    return
  end

  -- Move to the right
  vim.api.nvim_command('normal! l')
end, { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

-- Lspsaga

map("n", "K", "<cmd> Lspsaga hover_doc <CR>", { desc = "Open LSP Saga hover" })
map("n", "<leader>o", "<cmd> Lspsaga outline <CR>", { desc = "Toggle LSP Saga outline" })
map("n", "<leader>wd", "<cmd> Lspsaga show_workspace_diagnostics <CR>", { desc = "Show LSP Saga workspace diagnostics" })
map("n", "<leader>f", "<cmd> Lspsaga show_cursor_diagnostics <CR>", { desc = "Show LSP Saga cursor diagnostics", noremap = true })
map("n", "<leader>ld", "<cmd> Lspsaga show_line_diagnostics <CR>", { desc = "Show LSP Saga line diagnostics" })
map("n", "<leader>zd", "<cmd> Lspsaga show_buf_diagnostics <CR>", { desc = "Show LSP Saga current buffer diagnostics" })
map("n", "<leader>fd", "<cmd> Lspsaga finder <CR>", { desc = "Open LSP Saga finder" })
map("n", "<leader>ic", "<cmd> Lspsaga incoming_calls <CR>", { desc = "Open LSP Saga incoming calls" })
map("n", "<leader>oc", "<cmd> Lspsaga outgoing_calls <CR>", { desc = "Open LSP Saga outgoing calls" })
map("n", "gp", "<cmd> Lspsaga peek_definition <CR>", { desc = "Open LSP Saga definition peek" })
map("n", "gP", "<cmd> Lspsaga peek_type_definition <CR>", { desc = "Open LSP Saga type definition peek" })

-- Neogit

map("n", "<leader>ng", "<cmd> Neogit  <CR>", { desc =  "Open Neogit" })

-- Git signs

map("n", "<leader>gB", "<cmd> Gitsigns blame<CR>", { desc = "Toggle Gitsigns blame" })
map("n", "<leader>gb", "<cmd> Gitsigns blame_line <CR>", { desc = "Toggle Gitsigns blame line" })
map("n", "]h", "<cmd> Gitsigns next_hunk<CR>", { desc = "Go to next Git hunk" })
map("n", "[h", "<cmd> Gitsigns prev_hunk <CR>", { desc = "Go to previous Git hunk" })
map("n", "<leader>gh", "<cmd> Gitsigns preview_hunk <CR>", { desc = "Preview the Git hunk of the current line" })
map("n", "<leader>gs", "<cmd> Gitsigns stage_hunk <CR>", { desc = "Stage Git hunk of the current line" })
map("n", "<leader>gu", "<cmd> Gitsigns undo_stage_hunk <CR>", { desc = "Unstage Git hunk of the current line" })
map("n", "<leader>gr", "<cmd> Gitsigns reset_hunk <CR>", { desc = "Reset Git hunk of the current line" })

-- Dap

map("n", "<F5>", "<cmd> lua require'dap'.continue() <CR>", { desc = "Debug controls | Continue" })
map("n", "<F10>", "<cmd> lua require'dap'.step_over() <CR>", { desc = "Debug controls | Step over" })
map("n", "<F11>", "<cmd> lua require'dap'.step_into() <CR>", { desc = "Debug controls | Step into" })
map("n", "<F12>", "<cmd> lua require'dap'.step_out() <CR>", { desc = "Debug controls | Step out" })
map("n", "<leader>bp", "<cmd> lua require'dap'.toggle_breakpoint() <CR>", { desc = "Toggle line breakpoint" })
map("n", "<leader>BP", "<cmd> lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) <CR>", { desc = "Set line conditional breakpoint" })
map("n", "<leader>lp", "<cmd> lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) <CR>", { desc = "Set line conditional breakpoint for logging" })
map("n", "<leader>dr", "<cmd> lua require'dap'.repl.open() <CR>", { desc = "Open REPL" })

-- Dap interface

map("n", "<leader>dpu", "<cmd> lua require'dap-view'.toggle(true) <CR>", { desc = "Toggle debugger hiding the terminal" })
map("n", "<leader>dpU", "<cmd> lua require'dap-view'.toggle(false) <CR>", { desc = "Toggle debugger keeping the terminal" })

-- Preserve C-i jump forward (avoid tab remap conflict)
-- See https://vimhelp.org/motion.txt.html#jump-motions
map("n", "<C-i>", "<C-i>", { desc = "Go forwardly in jumplist", noremap = true })

-- Diffview

map("n", "<leader>dv", "<cmd> DiffviewOpen <CR>", { desc = "Open diff view menu" })
map("n", "<leader>dvh", "<cmd> DiffviewFileHistory <CR>", { desc = "Open diff view file history menu" })
map("n", "<leader>dV", "<cmd> DiffviewClose <CR>", { desc = "Close diff view menu" })

-- Telescope

map("n", "<leader>fwa", "<cmd> lua require'telescope'.extensions.live_grep_args.live_grep_args() <CR>", { desc = "Live grep with custom arguments" })
map("n", "<leader>fb", "<cmd> TelescopeCustomBufferFind <CR>", { desc = "Find buffer - ovewritten" })

-- Line movement mappings

-- Without line selection
map({ "n", "i" }, "<A-Up>", "<cmd> m-2 <cr>", { desc = "Move line upwards" })
map({ "n", "i" }, "<A-Down>", "<cmd> m+ <cr>", { desc = "Move line downwards" })
map({ "n", "i" }, "<A-k>", "<cmd> m-2 <CR>", { desc = "Move line upwards" })
map({ "n", "i" }, "<A-j>", "<cmd> m+ <CR>", { desc = "Move line downwards" })

-- With line selection
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move line(s) upwards" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move line(s) downwards" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line(s) upwards" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line(s) downwards" })

-- Font mappings

map({ "n", "i" }, "<A-=>", "<cmd> RestoreFontSize <CR>", { desc = "Restore font size" })
map({ "n", "i" }, "<C-=>", "<cmd> IncreaseFontSize <CR>", { desc = "Increase font size" })
map({ "n", "i" }, "<C-->", "<cmd> DecreaseFontSize <CR>", { desc = "Decrease font size" })

-- Dropbar mappings

map("n", "<leader>db", "<cmd> lua require'dropbar.api'.pick() <CR>", { desc = "Enter dropbar interactive pick mode" })

-- DBee

map({ "n", "v" }, "<leader>dbe", "<cmd> lua require'dbee'.toggle() <CR>", { desc = "DBee toggle UI" })

-- Neotest mappings

map("n", "<leader>ts", "<cmd> Neotest summary <CR>", { desc = "Open tests summary" })
map("n", "<leader>to", "<cmd> lua require'neotest'.output_panel.toggle() <CR>", { desc = "Toggle test output panel" })

map("n", "<leader>tt", "<cmd> lua require'neotest'.run.run(vim.fn.expand('%')) <CR>", { desc = "Run test file" })
map("n", "<leader>tD", "<cmd> lua require'neotest'.run.run({ vim.fn.expand('%'), strategy = 'dap' }) <CR>", { desc = "Debug all tests" })
map("n", "<leader>tr", "<cmd> lua require'neotest'.run.run() <CR>", { desc = "Run nearest test" })
map("n", "<leader>td", "<cmd> lua require'neotest'.run.run({ strategy = 'dap' }) <CR>", { desc = "Debug nearest test" })


-- Harpoon mappings

nomap("n", "<C-j>")
nomap("n", "<C-k>")
nomap("n", "<leader>h")

map("n", "<leader>a", "<cmd> lua require'harpoon':list():add() <CR>", { desc = "Harpoon add entry", noremap = true })
map("n", "<leader>ar", "<cmd> lua require'harpoon':list():remove() <CR>", { desc = "Harpoon remove entry", noremap = true })
map("n", "<leader>h", "<cmd> lua require'harpoon'.ui:toggle_quick_menu(require'harpoon':list()) <CR>", { desc = "Harpoon open list", noremap = true })

-- Package Info mappings

map("n", "<leader>ps", "<cmd> lua require'package-info'.show() <CR>", { desc = "Show dependency versions", silent = true, noremap = true })

map("n", "<leader>ph", "<cmd> lua require'package-info'.hide() <CR>", { desc = "Hide dependency versions", silent = true, noremap = true })

map("n", "<leader>pt", "<cmd> lua require'package-info'.toggle() <CR>", { desc = "Toggle dependency versions", silent = true, noremap = true })

map("n", "<leader>pu", "<cmd> lua require'package-info'.update() <CR>", { desc = "Update dependency on the line", silent = true, noremap = true })

map("n", "<leader>pd", "<cmd> lua require'package-info'.delete() <CR>", { desc = "Delete dependency on the line", silent = true, noremap = true })

map("n", "<leader>pi", "<cmd> lua require'package-info'.install() <CR>", { desc = "Install a new dependency", silent = true, noremap = true })

map("n", "<leader>pc", "<cmd> lua require'package-info'.change_version() <CR>", { desc = "Install a different dependency version", silent = true, noremap = true })

-- Harpoon navigation
map("n", "<C-k>", "<cmd> lua require'harpoon':list():prev() <CR>", { desc = "Harpoon previous buffer" })
map("n", "<C-j>", "<cmd> lua require'harpoon':list():next() <CR>", { desc = "Harpoon next buffer" })

map("n", "<leader>hh", "<cmd> HarpoonTelescope <CR>", { desc = "Harpoon open Telescope window", noremap = true })

-- Kulala

-- Setup the following keys:
-- map("n", "<leader>Rs", "<cmd> lua require'kulala'.run() <CR>", { desc = "Send request" })
-- map("n", "<leader>Ra", "<cmd> lua require'kulala'.run_all() <CR>", { desc = "Send all requests" })
-- map("n", "<leader>Ro", "<cmd> lua require'kulala'.open() <CR>", { desc = "Open Kulala view" })
-- map("n", "<leader>Rc", "<cmd> lua require'kulala'.close() <CR>", { desc = "Close Kulala view" })
