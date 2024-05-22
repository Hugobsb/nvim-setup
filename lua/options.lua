require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

local utils = require'utils'
local screenshot = require'modules.screenshot'
local uuid = require'modules.uuid'

----------------------------------- globals ----------------------------------------

vim.g.neovide_cursor_vfx_mode = 'pixiedust'

--------------------------------- manual sets --------------------------------------

-- Disable line wrapping
vim.cmd("set nowrap")

-- Set `session options` for the `auto-session` plugin
vim.cmd("set sessionoptions+=winpos,terminal,folds")

-- Set / as diff character
vim.opt.fillchars:append { diff = "╱" }

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
    function ()
      uuid.seed()
      return uuid()
    end,
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

new_cmd('RestCustomRunFile', function()
  local options = vim.fn.globpath(
    vim.fn.getcwd() .. (os.getenv('NVIM_REST_DIR') or '/http-requests'),
    '*.http',
    true,
    true
  )

  if #options == 0 then
    vim.notify(
      'No http files found in the current directory.',
      'warning',
      { title = 'RestCustomRunFile command' }
    )
    return
  end

  for i, option in ipairs(options) do
    options[i] = option:gsub(utils.escape_regex_chars(vim.fn.getcwd()) .. '/', '')
  end

  vim.ui.select(options, { prompt = 'Choose the http request: ' }, function(choice)
    if choice == nil then
      vim.notify(
        'No http file selected.',
        'warning',
        { title = 'RestCustomRunFile command' }
      )

      return
    end

    require'rest-nvim'.run_file(choice, { keep_going = false })

    -- TODO: check if adding this verification is necessary
    -- xpcall(
    --   require'rest-nvim'.run_file(choice, { keep_going = false }),
    --   function (err)
    --     vim.notify(
    --       'Failed to run the selected http file: ' .. err,
    --       'error',
    --       { title = 'RestCustomRunFile command' }
    --     )
    --
    --     return false
    --   end
    -- )
  end)
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
  vim.fn.execute('set splitright | vnew | set filetype=sh | read !sh #')
end, {})

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

