local config = {
  -- Ree-enabling Netrw to be able to perform `:GBrowse`
  disable_netrw = false,

  ensure_installed = {
    "dart",
    "dockerfile",
    "go",
    "java",
    "json",
    "jsonc",
    "jsondoc",
    "kotlin",
    "lua",
    "markdown",
    "mermaid",
    "sql",
    "toml",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  },

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },
}

return config

