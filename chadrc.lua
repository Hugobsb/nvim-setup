---@diagnostic disable: undefined-global, inject-field, undefined-doc-name
---@diagnostic disable-next-line: undefined-doc-name

---@type ChadrcConfig 
local M = {}

M.ui = {
  theme = "chadracula",
  theme_toggle = { "chadracula", "one_light" },

  nvdash = {
    load_on_startup = true,

    header = {
      [[ ██░ ██  █    ██      ▄████  ▒█████      ██▒   █▓ ██▓ ███▄ ▄███▓]],
      [[▓██░ ██▒ ██  ▓██▒    ██▒ ▀█▒▒██▒  ██▒   ▓██░   █▒▓██▒▓██▒▀█▀ ██▒]],
      [[▒██▀▀██░▓██  ▒██░   ▒██░▄▄▄░▒██░  ██▒    ▓██  █▒░▒██▒▓██    ▓██░]],
      [[░▓█ ░██ ▓▓█  ░██░   ░▓█  ██▓▒██   ██░     ▒██ █░░░██░▒██    ▒██ ]],
      [[░▓█▒░██▓▒▒█████▓    ░▒▓███▀▒░ ████▓▒░      ▒▀█░  ░██░▒██▒   ░██▒]],
      [[ ▒ ░░▒░▒░▒▓▒ ▒ ▒     ░▒   ▒ ░ ▒░▒░▒░       ░ ▐░  ░▓  ░ ▒░   ░  ░]],
      [[ ▒ ░▒░ ░░░▒░ ░ ░      ░   ░   ░ ▒ ▒░       ░ ░░   ▒ ░░  ░      ░]],
      [[ ░  ░░ ░ ░░░ ░ ░    ░ ░   ░ ░ ░ ░ ▒          ░░   ▒ ░░      ░   ]],
      [[ ░  ░  ░   ░              ░     ░ ░           ░   ░         ░   ]],
      [[                                             ░                  ]],
    },

    buttons = {
      { "  Find File", "Spc f f", "Telescope find_files" },
      { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
      { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
      { "󱑜  Save session", "Spc s s", "SessionSave" },
      { "󰁯  Restore last session", "Spc s r", "SessionRestore" },
      { "  Find sessions", "Spc f s", "'auto-session.session-lens'.search_session()" },
      { "󰂽  Bookmarks", "Spc m a", "Telescope marks" },
      { "  Themes", "Spc t h", "Telescope themes" },
      { "  Mappings", "Spc c h", "NvCheatsheet" },
    },
  },

  extended_integrations = {
    "dap",
    "navic",
    "notify",
    "trouble",
  },

  hl_add = {
    DevIconEncryptedFiles = {
      fg = "#ffa500",
      bg = "none",
    },
    DevIconHttpFiles = {
      fg = "#ffa500",
      bg = "none",
    }
  },

  hl_override = {
    -- Statusline highlights
    ["St_cwd"] = { bg = "statusline_bg", fg = "#ffae00" },

    -- NvDash highlights
    ["NvDashAscii"] = { fg = "#bd93f9", bg = "none" },
    ["NvDashButtons"] = { fg = "#f8f8f2", bg = "none" },

    -- Diff highlights
    ["DiffAdd"] = { bg = "#22863a", fg = "none" },
    ["DiffDelete"] = { bg = "none", fg = "#b31d28" },
    ["DiffChange"] = { bg = "#1f2231", fg = "none" },
    ["DiffText"] = { bg = "#394b70", fg = "none" },

    -- Semantic highlights
    -- references
    -- https://neovim.io/doc/user/lsp.html#lsp-semantic-highlight
    -- https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
    ["@lsp.type.namespace"] = { link = "@namespace" },
    ["@lsp.type.type"] = { link = "@type" },
    ["@lsp.type.class"] = { link = "@type" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.interface"] = { link = "@type" },
    ["@lsp.type.struct"] = { link = "@structure" },
    ["@lsp.type.parameter"] = { link = "@parameter" },
    ["@lsp.type.variable"] = { link = "@variable" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.enumMember"] = { link = "@constant" },
    ["@lsp.type.function"] = { link = "@function" },
    ["@lsp.type.method"] = { link = "@method" },
    ["@lsp.type.macro"] = { link = "@macro" },
    ["@lsp.type.decorator"] = { link = "@function" },
  },

  lsp_semantic_tokens = true, -- needs nvim v0.9, just adds highlight groups for lsp semantic tokens

  statusline = {
    theme = "vscode_colored",
    overriden_modules = function(modules)
      local function get_tab_spaces()
        return "%#StText#Spaces: " .. vim.opt.tabstop:get() .. "  "
      end

      local function get_line_break_encoding()
        local encoding = vim.api.nvim_buf_get_option(0, 'fileformat')

        if (encoding == "unix") then
          return "LF  "
        end

        if (encoding == "dos") then
          return "CRLF  "
        end

        return encoding .. "  "
      end

      local function git()
        local has_buffer_branch = string.len(modules[3]) > 0

        if not has_buffer_branch then
          local directory_branch = vim.fn.system("git branch --show-current 2>/dev/null")

          -- Remove the empty character ^@ from the end of the function
          directory_branch = string.sub(directory_branch, 1, -2)

          if string.len(directory_branch) > 0 then
            return "  " .. directory_branch .. "  "
          end
        end

        return ""
      end

      table.insert(modules, 10, get_tab_spaces())
      table.insert(modules, 12, get_line_break_encoding())
      table.insert(modules, 4, git())

      -- Add an extra space to cwd ending
      table.insert(modules, 17, " ")
    end
  },

  cmp = {
    style = "atom_colored"
  },
}

M.mappings = require "custom.mappings"

M.plugins = "custom.plugins"

return M

