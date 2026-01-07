require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

local utils = require'utils'
local screenshot = require'modules.screenshot'

----------------------------------- globals ----------------------------------------

vim.g.neovide_cursor_vfx_mode = 'pixiedust'

--------------------------------- manual sets --------------------------------------

-- Enable diagnostic severity sort
-- without it, functionalities like Lspsaga show_line_diagnostics does not work
vim.diagnostic.config({
  severity_sort = true,
})

-- Disable line wrapping
vim.cmd("set nowrap")

-- Set `session options` for the `auto-session` plugin
vim.cmd("set sessionoptions+=winpos,terminal,folds")

-- Set / as diff character
vim.opt.fillchars:append { diff = "╱" }

-- Disable behavior of automatically adding/removing a newline at the end of file when saving
vim.opt.fixeol = false

local is_running_wsl = vim.fn.system("cat /proc/version 2>/dev/null | grep -F 'WSL'")

if is_running_wsl ~= '' and is_running_wsl ~= nil then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = true,
  }
end

------------------------------------ fonts -----------------------------------------

local default_font = os.getenv("NVIM_FONT") or 'FiraCode Nerd Font'
local default_font_size = 10

if vim.fn.has('gui_running') then
  if (vim.fn.has('unix')) then
    vim.opt.guifont = { default_font, ':h' .. default_font_size }
  else
    vim.opt.guifont = { default_font, 'h' .. default_font_size }
  end
end

----------------------------------- neovide ----------------------------------------

vim.opt.linespace = 6

vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0

vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_antialiasing = true

vim.g.neovide_floating_blur_amount_x = 5.0

vim.g.neovide_font_hinting = 'none'
vim.g.neovide_font_edging = 'subpixelantialias'

vim.g.neovide_transparency = 0.9

------------------------------- custom commands ------------------------------------

local new_cmd = vim.api.nvim_create_user_command

new_cmd('Base64Encode', function()
  local no_selection_found_message = 'A text must be selected to encode it.'

  local selection = utils.get_visually_selected_text(no_selection_found_message)

  if selection == nil then
    return
  end

  local ok, encoded_string = xpcall(
    utils.base64_encode,
    function(err)
      vim.notify(
        'Failed to encode the selected text: ' .. err,
        'error',
        { title = 'Base64Encode command' }
      )
      return false
    end,
    selection
  )

  if ok then
    utils.replace_selected_text(encoded_string)
  end

  -- Cleaning the visual selection
  vim.cmd('normal! gv')
end, { addr = 'lines', range = '%' })

new_cmd('Base64Decode', function()
  local no_selection_found_message = 'A text must be selected to decode it.'

  local selection = utils.get_visually_selected_text(no_selection_found_message)

  if selection == nil then
    return
  end

  local ok, decoded_string = xpcall(
    utils.base64_decode,
    function(err)
      vim.notify(
        'Failed to decode the selected text: ' .. err,
        'error',
        { title = 'Base64Decode command' }
      )
      return false
    end,
    selection
  )

  if ok then
    utils.replace_selected_text(decoded_string)
  end

  -- Cleaning the visual selection
  vim.cmd('normal! gv')
end, { addr = 'lines', range = '%' })

new_cmd('GenerateUUID', function()
  local ok, id = xpcall(
    utils.generate_uuid,
    function(err)
      vim.notify(
        'Failed to generate UUID: ' .. err,
        'error',
        { title = 'GenerateUUID command' }
      )
    end
  )

  if ok then
    utils.insert_text_before_cursor(id)
  end
end, {})

new_cmd('GenerateUUIDFromString', function()
  local no_selection_found_message = 'A text must be selected to generate the UUID from the string.'

  local selection = utils.get_visually_selected_text(no_selection_found_message)

  if selection == nil then
    return
  end

  local ok, id = xpcall(
    utils.generate_uuid_from_string,
    function(err)
      vim.notify(
        'Failed to generate UUID from string: ' .. err,
        'error',
        { title = 'GenerateUUIDFromString command' }
      )
    end,
    selection
  )

  if ok then
    vim.fn.setreg('"', id, 'v')

    -- Cleaning visual selection
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)

    vim.notify(
      'The UUID for the selected string was generated successfully and copied to the unnamed registry `"`.',
      'info',
      { title = 'GenerateUUIDFromString command' }
    )
  end
end, { addr = 'lines', range = '%' })

new_cmd('SortAlphabetically', function()
  local no_selection_found_message = 'A text must be selected to sort it.'

  local options = { 'Ascending', 'Descending' }

  vim.ui.select(options, { prompt = 'Choose the sort method: ' }, function(choice)
    if choice ~= options[1] and choice ~= options[2] then
      vim.notify(
        " " .. string.format("Invalid option. You must select between '%s' and %s.", options[1], options[2]),
        'warning',
        { title = 'SortAlphabetically command' }
      )
    else
      local ok, sorted_string = xpcall(
        utils.sort_alphabetically,
        function(err)
          vim.notify(
            'Failed to sort the selected text: ' .. err,
            'error',
            { title = 'SortAlphabetically command' }
          )
          return false
        end,
        choice, no_selection_found_message
      )

      if ok then
        utils.replace_selected_text_visually(sorted_string)
      end
    end

    -- Cleaning the visual selection
    vim.cmd('normal! gv')
  end)

end, { addr = 'lines', range = '%' })

new_cmd('GenerateISODate', function()
  local iso_date = utils.generate_iso_date()

  utils.insert_text_before_cursor(iso_date)
end, {})

new_cmd('ValidateUUID', function()
  local no_selection_found_message = 'A text must be selected to validate it.'

  local options = { 'v4' }

  vim.ui.select(options, { prompt = 'Choose the UUID version: ' }, function(choice)
    if choice ~= options[1] then
      vim.notify(
        " " .. string.format("Invalid option. You must select between the following options: ['%s']", options[1]),
        'warning',
        { title = 'CheckUUID command' }
      )
    else
      local selection = utils.get_visually_selected_text(no_selection_found_message)

      local ok, is_valid = xpcall(
        utils.is_uuid_valid,
        function(err)
          vim.notify(
            'Failed to validate the selected text: ' .. err,
            'error',
            { title = 'CheckUUID command' }
          )
          return false
        end,
        selection
      )

      if not ok then
        return
      end

      local message = is_valid and 'The selected text is a valid UUID.' or 'The selected text is not a valid UUID.'

      vim.notify(message, 'info', { title = 'CheckUUID command' })
    end

    -- Cleaning the visual selection
    vim.cmd('normal! gv')
  end)

end, { addr = 'lines', range = '%' })

------------------------------ custom gui commands ---------------------------------

if vim.fn.has('gui_running') then
  new_cmd('IncreaseFontSize', function(cmd)
    local increase_by = tonumber(cmd.args)

    if (increase_by ~= nil) then
      return utils.resize_font_size(math.abs(increase_by))
    end

    return utils.resize_font_size(1)
  end, { nargs = "?" })

  new_cmd('DecreaseFontSize', function(cmd)
    local decrease_by = tonumber(cmd.args)

    if (decrease_by ~= nil) then
      return utils.resize_font_size(-math.abs(decrease_by))
    end

    return utils.resize_font_size(-1)
  end, { nargs = "?" })

  new_cmd('RestoreFontSize', function()
    return utils.resize_font_size(default_font_size, true)
  end, {})
end

new_cmd('Screenshot', function()
  xpcall(
    screenshot,
    function (err)
        vim.notify(
          'Failed to take screenshot of the selected text:' .. err,
          'error',
          { title = 'Screenshot command' }
        )
      return false
    end
  )
end, { addr = 'lines', range = '%' })

new_cmd('RunSH', function()
  vim.fn.execute("set splitright | vnew | set filetype=sh | execute('read !sh #') | execute getline(1) == '' ? '1delete' : ''")
end, {})

new_cmd('HarpoonTelescope', function()
  local harpoon_files = require'harpoon':list()
  local conf = require("telescope.config").values

  local file_paths = {}

  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end, {})

new_cmd('TelescopeCustomBufferFind', function()
  local action_state = require('telescope.actions.state')

  local function get_buffers()
    require'telescope.builtin'.buffers{
      initial_mode = 'normal',
      attach_mappings = function(prompt_bufnr, map)
        local delete_buf = function()
          local current_picker = action_state.get_current_picker(prompt_bufnr)
          current_picker:delete_selection(function(selection)
            vim.api.nvim_buf_delete(selection.bufnr, { force = true })
          end)
        end

        map('n', '<c-e>', delete_buf)

        return true
      end
    }
  end

  get_buffers()
end, {})

new_cmd('GenerateTarballHash', function()
  local no_selection_found_message = 'A tarball URL must be selected to generate its hash.'

  local selection = utils.get_visually_selected_text(no_selection_found_message)

  if selection == nil then
    return
  end

  if string.match(selection, "^https?://[%w%-%./@]+/-/[%w%-]+%-%d+%.%d+%.%d+%.tgz$") == nil then
    vim.notify(
      'The selected text is not a valid tarball URL. The hash will not be generated.',
      'warning',
      { title = 'GenerateTarballHash command' }
    )
    return
  end

  local ok, hash = xpcall(
    utils.generate_tarball_hash,
    function(err)
      vim.notify(
        'Failed to hash the file for the selected URL: ' .. err,
        'error',
        { title = 'GenerateTarballHash command' }
      )
      return false
    end,
    selection
  )

  if ok then
    vim.fn.setreg('"', 'sha512-' .. hash, 'v')

    -- Cleaning visual selection
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)

    vim.notify(
      'The hash for the selected tarball URL was generated successfully and copied to the unnamed registry `"`.',
      'info',
      { title = 'GenerateTarballHash command' }
    )
  end

  -- Cleaning the visual selection
  vim.cmd('normal! gv')
end, { addr = 'lines', range = '%' })

---------------------------------- bugfixes ----------------------------------------

-- Neogit message filetype

vim.api.nvim_create_augroup("neogit-additions", {})

vim.api.nvim_create_autocmd("FileType", {
  group = "neogit-additions",
  pattern = "NeogitCommitMessage";
  command = "silent! set filetype=gitcommit",
})

-- Copilot tab key

-- See the mapping configuration where the tab key is re-mapped
vim.g.copilot_no_tab_map = true;

vim.g.copilot_assume_mapped = true;
vim.g.copilot_tab_fallback = "";

-- Neovide alt key for MacOS

vim.g.neovide_input_macos_alt_is_meta = true

-- Fix ugly highlight groups
vim.cmd("hi WinBar guibg=NONE")
vim.cmd("hi WinBarNC guibg=NONE")
vim.cmd("hi DapUINormalNC guibg=NONE")

