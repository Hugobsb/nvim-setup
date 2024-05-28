---@diagnostic disable: undefined-global, inject-field, undefined-doc-name
---@diagnostic disable-next-line: undefined-doc-name

---@type ChadrcConfig 
local M = {}

M.ui = {
  theme = "chadracula",
  theme_toggle = { "chadracula", "one_light" },

  transparency = vim.g.neovide == nil,

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

    -- Telescope highlights

    -- Sets the highlight for selected items within the picker.
    ["TelescopeSelection"] = { link = "Visual" },
    ["TelescopeSelectionCaret"] = { link = "TelescopeSelection" },
    ["TelescopeMultiSelection"] = { link = "Type" },
    ["TelescopeMultiIcon"] = { link = "Identifier" },

    -- "Normal" in the floating windows created by telescope.
    ["TelescopeNormal"] = { link = "Normal" },
    ["TelescopePreviewNormal"] = { link = "TelescopeNormal" },
    ["TelescopePromptNormal"] = { link = "TelescopeNormal" },
    ["TelescopeResultsNormal"] = { link = "TelescopeNormal" },

    -- Border highlight groups.
    --   Use TelescopeBorder to override the default.
    --   Otherwise set them specifically
    ["TelescopeBorder"] = { link = "TelescopeNormal" },
    ["TelescopePromptBorder"] = { link = "TelescopeBorder" },
    ["TelescopeResultsBorder"] = { link = "TelescopeBorder" },
    ["TelescopePreviewBorder"] = { link = "TelescopeBorder" },

    -- Title highlight groups.
    --   Use TelescopeTitle to override the default.
    --   Otherwise set them specifically
    ["TelescopeTitle"] = { link = "TelescopeBorder" },
    ["TelescopePromptTitle"] = { link = "TelescopeTitle" },
    ["TelescopeResultsTitle"] = { link = "TelescopeTitle" },
    ["TelescopePreviewTitle"] = { link = "TelescopeTitle" },

    ["TelescopePromptCounter"] = { link = "NonText" },

    -- Used for highlighting characters that you match.
    ["TelescopeMatching"] = { link = "Special" },

    -- Used for the prompt prefix
    ["TelescopePromptPrefix"] = { link = "Identifier" },

    -- Used for highlighting the matched line inside Previewer. Works only for (vim_buffer_ previewer)
    ["TelescopePreviewLine"] = { link = "Visual" },
    ["TelescopePreviewMatch"] = { link = "Search" },

    ["TelescopePreviewPipe"] = { link = "Constant" },
    ["TelescopePreviewCharDev"] = { link = "Constant" },
    ["TelescopePreviewDirectory"] = { link = "Directory" },
    ["TelescopePreviewBlock"] = { link = "Constant" },
    ["TelescopePreviewLink"] = { link = "Special" },
    ["TelescopePreviewSocket"] = { link = "Statement" },
    ["TelescopePreviewRead"] = { link = "Constant" },
    ["TelescopePreviewWrite"] = { link = "Statement" },
    ["TelescopePreviewExecute"] = { link = "String" },
    ["TelescopePreviewHyphen"] = { link = "NonText" },
    ["TelescopePreviewSticky"] = { link = "Keyword" },
    ["TelescopePreviewSize"] = { link = "String" },
    ["TelescopePreviewUser"] = { link = "Constant" },
    ["TelescopePreviewGroup"] = { link = "Constant" },
    ["TelescopePreviewDate"] = { link = "Directory" },
    ["TelescopePreviewMessage"] = { link = "TelescopePreviewNormal" },
    ["TelescopePreviewMessageFillchar"] = { link = "TelescopePreviewMessage" },

    -- Used for Picker specific Results highlighting
    ["TelescopeResultsClass"] = { link = "Function" },
    ["TelescopeResultsConstant"] = { link = "Constant" },
    ["TelescopeResultsField"] = { link = "Function" },
    ["TelescopeResultsFunction"] = { link = "Function" },
    ["TelescopeResultsMethod"] = { link = "Method" },
    ["TelescopeResultsOperator"] = { link = "Operator" },
    ["TelescopeResultsStruct"] = { link = "Struct" },
    ["TelescopeResultsVariable"] = { link = "SpecialChar" },

    ["TelescopeResultsLineNr"] = { link = "LineNr" },
    ["TelescopeResultsIdentifier"] = { link = "Identifier" },
    ["TelescopeResultsNumber"] = { link = "Number" },
    ["TelescopeResultsComment"] = { link = "Comment" },
    ["TelescopeResultsSpecialComment"] = { link = "SpecialComment" },

    -- Used for git status Results highlighting
    ["TelescopeResultsDiffChange"] = { link = "DiffChange" },
    ["TelescopeResultsDiffAdd"] = { link = "DiffAdd" },
    ["TelescopeResultsDiffDelete"] = { link = "DiffDelete" },
    ["TelescopeResultsDiffUntracked"] = { link = "NonText" },

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

  tabufline = {
    enabled = false,
  },

  statusline = {
    theme = "vscode_colored",

    order = {
      "mode",
      "file",
      "git",
      "%=",
      "lsp_msg",
      "whitespace",
      "unsaved_buffer",
      "diagnostics",
      "tab_spaces",
      "line_break_encoding",
      "custom_lsp",
      "cursor",
      "cwd"
    },

    modules = {
      tab_spaces = function()
        return " %#StText#Spaces: " .. vim.opt.tabstop:get() .. "  "
      end,

      line_break_encoding = function()
        local encoding = vim.api.nvim_buf_get_option(0, 'fileformat')

        if (encoding == "unix") then
          return "LF  "
        end

        if (encoding == "dos") then
          return "CRLF  "
        end

        return encoding .. "  "
      end,

      unsaved_buffer = function ()
        if vim.api.nvim_buf_get_option(0, 'modified') then
          return ' • Modified '
        end

        return ""
      end,

      custom_lsp = function()
        local current_buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)

        local function get_lsp()
          local fallback = ""

          if rawget(vim, "lsp") and vim.version().minor >= 10 then
            for _, client in ipairs(vim.lsp.get_clients()) do
              if client.name == "null-ls" or client.name == "GitHub Copilot" then
                fallback = client.name
                goto continue
              end

              if client.attached_buffers[current_buf] then
                return (vim.o.columns > 100 and "   LSP ~ " .. client.name .. " ") or "   LSP "
              end

              ::continue::
            end
          end

          return fallback
        end

        return "%#St_Lsp#" .. get_lsp()
      end,

      whitespace = function() return " " end,
    },
  },

  cmp = {
    style = "atom_colored"
  },
}

return M
