local utils = require'custom.utils'
local uuid = require'custom.modules.uuid'

-------------------------------------- globals -------------------------------------------

vim.g.neovide_cursor_vfx_mode = "pixiedust"

---------------------------------- custom commands ---------------------------------------

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
      print('Failed to encode the selected text: ' .. err)
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
      print('Failed to decode the selected text: ' .. err)
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
  uuid.seed()
  local id = uuid()

  utils.insert_text_before_cursor(id)

  -- Cleaning the visual selection
  vim.cmd('normal! gv')
end, { addr = 'lines', range = '%' })

new_cmd('SortAlphabetically', function()
  local no_selection_found_message = 'A text must be selected to encode it.'

  local option = vim.fn.input(
    'Ascending: 1' .. '\n' .. 'Descending: 2' .. '\n' .. 'Choose your option: '
  )

  if option ~= '1' and option ~= '2' then
    print(" " .. "Invalid option. You must select between '1' and '2'.")
  else
    local ok, sorted_string = xpcall(
      utils.sort_alphabetically,
      function(err)
        print('Failed to sort the selected text: ' .. err)
        return false
      end,
      option, no_selection_found_message
    )

    if ok then
      utils.replace_selected_text(sorted_string)
    end
  end

  -- Cleaning the visual selection
  vim.cmd('normal! gv')
end, { addr = 'lines', range = '%' })

new_cmd('GenerateISODate', function()
  local iso_date = utils.generate_iso_date()

  utils.insert_text_before_cursor(iso_date)

  -- Cleaning the visual selection
  vim.cmd('normal! gv')
end, { addr = 'lines', range = '%' })

