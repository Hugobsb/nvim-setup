local M = {}

local function execute_os_command(command)
  local handle, err = io.popen(command)

  if handle == nil then
    return nil, 'Handle cannot be nil'
  end

  if err then
    return nil, 'The command execution failed with the following error -> ' .. err
  end

  local result = handle:read("*a")

  handle:close()

  return result, nil
end

local function is_base64_valid(str)
  local base64_pattern = "^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)?$"

  local command = 'echo "' .. str .. '"' .. " | grep -E '" .. base64_pattern .. "'"

  local result, err = execute_os_command(command)

  if err then
    error(err)
  end

  return type(result) == 'string' and string.len(result) > 0
end

M.get_visually_selected_text = function(no_selection_found_message)
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

  if #lines == 0 then
    print(no_selection_found_message)
    return ""
  elseif #lines == 1 then
    return string.sub(lines[1], start_pos[3], end_pos[3])
  else
    local first_line = string.sub(lines[1], start_pos[3])
    local last_line = string.sub(lines[#lines], 1, end_pos[3])
    local middle_lines = {}

    for i = 2, #lines - 1 do
      table.insert(middle_lines, lines[i])
    end

    return table.concat({first_line, table.concat(middle_lines, "\n"), last_line}, "\n")
  end
end

M.insert_text_before_cursor = function(str)
  -- Enter normal mode to avoid issues with visual mode
  vim.api.nvim_command('normal! gv')

  -- Set the unnamed register with the replacement text
  vim.fn.setreg('"', str, 'v')

  -- Paste the replacement text before the cursor
  vim.api.nvim_command('normal! ""P')
end

M.replace_selected_text = function(replace_with)
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

  if #lines == 0 then
    return
  end

  -- Enter normal mode to avoid issues with visual mode
  vim.api.nvim_command('normal! gv')

  -- Delete the selected text
  vim.api.nvim_command('normal! d')

  M.insert_text_before_cursor(replace_with)
end

M.base64_encode = function(str)
  if is_base64_valid(str) then
    print('Warning: the given string is already encoded')
  end

  local command = 'echo "' .. str .. '" | base64'

  local result, err = execute_os_command(command)

  if err then
    error(err)
  end

  if type(result) == "string" and not str:match("\n$") then
    return string.gsub(result, "\n$", "")
  else
    return result
  end
end

M.base64_decode = function(str)
  if not is_base64_valid(str) then
    error('The given string is not a valid base64')
    return
  end

  local command = 'echo "' .. str .. '" | base64 --decode'

  local result, err = execute_os_command(command)

  if err then
    error(err)
  end

  if type(result) == "string" and not str:match("\n$") then
    return string.gsub(result, "\n$", "")
  else
    return result
  end
end

return M

