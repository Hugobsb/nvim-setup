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

---@param text string
---@param ascending boolean
local function sort_text_alphabetically(text, ascending)
  local lines = {}

  local match_whitespaces = "%S+"

  local match_lines = "[^\r\n]+"

  for line in text:gmatch(match_lines) do
    table.insert(lines, line)
  end

  if #lines == 0 then
    return text
  end

  local trim_left = string.match(text, "^[\n\r]+") or ""
  local trim_right = string.match(text, "[\n\r]+$") or ""

  if ascending then
    table.sort(
      lines,
      function (a, b)
        return a:match(match_whitespaces) < b:match(match_whitespaces)
      end
    )
  else
    table.sort(
      lines,
      function(a, b)
        return a:match(match_whitespaces) > b:match(match_whitespaces)
      end
    )
  end

  local sorted_text = trim_left .. table.concat(lines, "\n") .. trim_right

  return sorted_text
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

---@param str string
M.insert_text_before_cursor = function(str)
  -- Set the unnamed register with the replacement text
  vim.fn.setreg('"', str, 'v')

  -- Paste the replacement text before the cursor
  vim.api.nvim_command('normal! ""P')
end

---@param replace_with string
M.replace_selected_text = function(replace_with)
  -- Save the current cursor position
  vim.api.nvim_command('normal! gv')

  M.insert_text_before_cursor(replace_with)
end

--@param replace_with string
M.replace_selected_text_visually = function(replace_with)
  -- Save the current cursor position
  vim.api.nvim_command('normal! gv')

  if vim.fn.visualmode() ~= 'V' then
    -- Estamos no modo visual (não linha)
    -- Trocar para o modo visual de linha
    vim.api.nvim_feedkeys('V', 'x', true)
  end

  print(vim.fn.visualmode())

  M.insert_text_before_cursor(replace_with)
end

---@param str string
---@return string
M.base64_encode = function(str)
  if is_base64_valid(str) then
    print('Warning: the given string is already encoded')
  end

  local command = 'echo "' .. str .. '" | base64'

  local output, err = execute_os_command(command)

  if err then
    error(err)
  end

  local result = tostring(output)

  if type(output) == "string" and not str:match("\n$") then
    result = string.gsub(output, "\n$", "")
  end

  return result
end

---@param str string
---@return string
M.base64_decode = function(str)
  if not is_base64_valid(str) then
    error('The given string is not a valid base64')
    return str
  end

  local command = 'echo "' .. str .. '" | base64 --decode'

  local output, err = execute_os_command(command)

  if err then
    error(err)
  end

  local result = tostring(output)

  if type(output) == "string" and not str:match("\n$") then
    result = string.gsub(output, "\n$", "")
  end

  return result
end

M.sort_alphabetically = function(option, no_selection_found_message)
  local text = M.get_visually_selected_text(no_selection_found_message)

  if option == '1' then
    return sort_text_alphabetically(text, true)
  else if option == '2' then
    return sort_text_alphabetically(text, false)
  end end

  return text
end

M.validate_and_convert_github_url = function(url)
    if (url == nil) then return nil end

    local httpsPattern = "^https://github.com/.+/.+$"

    if string.match(url, httpsPattern) then
        return url
    end

    local sshPattern = "^git@github.com:.+/.+%.git$"

    local sshMatch = string.match(url, sshPattern)

    if sshMatch then
        local username, reponame = string.match(sshMatch, "^git@github.com:(.+)/(.+)%.git$")
        if username and reponame then
            return "https://github.com/" .. username .. "/" .. reponame
        end
    end

    return nil
end

M.get_buffer_directory = function()
  local bufnr = vim.fn.bufnr('%')

  local filename = vim.fn.bufname(bufnr)

  local directory = vim.fn.fnamemodify(filename, ':p')

  return directory
end

M.generate_iso_date = function()
  local iso_date = vim.fn.strftime('%Y-%m-%dT%H:%M:%S.000Z')

  return iso_date
end

M.resize_font_size = function(amount, exact, bounds)
  if (bounds == nil) then
    bounds = {
      maximum = 24,
      minimum = 8
    }
  end

  vim.opt.guifont = string.gsub(vim.opt.guifont._value, ":h(%d+)", function(n)
    local size = n + amount

    if exact ~= nil then
        size = amount
    end

    if size <= bounds.minimum then
        size = bounds.minimum
    elseif size >= bounds.maximum then
        size = bounds.maximum
    end

    return string.format(":h%d", size)
  end)
end

---@param text string
---@param separator string|nil
M.break_list_items = function(text, separator)
  if (separator == nil) then
    separator = ','
  end

  local trimmed_text = text:gsub("%s", "")

  local broken_text = "\n" .. trimmed_text:gsub(separator, separator .. "\n")

  local ends_with_separator = trimmed_text:sub(-1) == separator

  if not ends_with_separator then
      broken_text = broken_text .. "\n"
  end

  return broken_text
end

return M

