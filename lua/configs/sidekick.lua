local config = {
  opts = {
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
      context = {
        gitstaged = function()
          return vim.fn.systemlist("git diff --staged")
        end,
      },
      prompts = {
        Changelog = "Analyze the latest changes and the following changelog file to write the latest " ..
                    "details using the \"Keep a Changelog\" format. Changelog file: {file}",

        JavaDoc   = "Write me a Java doc for the selected function: {selection}",

        Commit    = "Generate commit message with commitizen convention from staged changes. " ..
                    "I do not want line numbers, it must be easy to copy-paste. Do respond me " ..
                    "in raw text without any prettification. Staged changes: {gitstaged}",
      },
    },
    nes = {
      enabled = false,
    },
  },
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<A-.>",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function() require("sidekick.cli").select() end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      function() require("sidekick.cli").close() end,
      desc = "Detach a CLI Session",
    },
    {
      "<leader>at",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>af",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Send File",
    },
    {
      "<leader>av",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    {
      "<leader>ac",
      function() require("sidekick.cli").toggle({ name = "cursor", focus = true }) end,
      desc = "Sidekick Toggle Cursor",
    },
  },
}

return config
