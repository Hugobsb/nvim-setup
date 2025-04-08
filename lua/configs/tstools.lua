local config = {};

local on_attach = require("nvchad.configs.lspconfig").on_attach

config.on_attach = function(client, bufnr)
  on_attach(client, bufnr)

  pcall(
    function()
      vim.keymap.del({ "n", "v" }, "<leader>ca", { buffer = bufnr })
    end
  )

  vim.keymap.set(
    { "n", "v" },
    "<leader>ca",
    "<cmd> Lspsaga code_action <CR>",
    { buffer = bufnr, desc = "LSP Code action", noremap = true }
  )
end

config.settings = {
  tsserver_plugins = {
    -- for TypeScript v4.9+
    "@styled/typescript-styled-plugin",
    -- or for older TypeScript versions
    -- "typescript-styled-plugin",
  },
}

require("typescript-tools").setup(config)

return config

