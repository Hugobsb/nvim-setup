local config = {}

config.on_attach = function(client, bufnr)
  require("nvchad.configs.lspconfig").on_attach(client, bufnr)
  require("utils").override_code_action_with_lspsaga(bufnr)
end

config.settings = {
  -- Some projects I'm working on with React are pure javascript
  jsx_close_tag = {
    enable = true,
    filetypes = { "javascript" },
  },

  tsserver_plugins = {
    -- for TypeScript v4.9+
    "@styled/typescript-styled-plugin",
    -- or for older TypeScript versions
    -- "typescript-styled-plugin",
  },
}

require("typescript-tools").setup(config)

return config

