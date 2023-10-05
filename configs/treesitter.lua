local config = {
  ensure_installed = {
    "c",
    "dart",
    "dockerfile",
    "go",
    "http",
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

  highlight = {
    enable = true,
    disable = {
      "NeogitConsole",
      "NeogitStatus",
      "NeogitGitCommandHistory",
      "NeogitMergeMessage",
      "NeogitCommitMessage",
      "NeogitCommitSelectView",
      "NeogitCommitView",
      "NeogitLogView",
      "NeogitRebaseTodo",
      "NeogitReflogView",
      "NeogitStatusNew",
      "NeogitPopup"
    }
  },

  autotag = {
    enable = true
  }
}

return config

