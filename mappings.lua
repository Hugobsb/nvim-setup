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

return M

