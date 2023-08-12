local config = {
  -- Ree-enabling Netrw to be able to perform `:GBrowse`
  disable_netrw = false,

  ensure_installed = {
    "c",
    "dart",
    "dockerfile",
    "go",
    "java",
    "json",
    "jsdoc",
    "jsonc",
    "kotlin",
    "lua",
    "markdown",
    "mermaid",
    "query",
    "sql",
    "todotxt",
    "toml",
    "tsx",
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

  autotag = {
    enable = true
  }
}

return config

