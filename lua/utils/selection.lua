local M = {}

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
    vim.notify(
      no_selection_found_message,
      vim.log.levels.WARN,
      { title = 'Visual selection utilitary' }
    )
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

---@param text string
M.escape_regex_chars = function(text)
  local magic_chars_match = '[%%%[%]^$().*+-?]'

  local escaped_text = text:gsub(magic_chars_match, "%%%0")

  return escaped_text
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
  vim.api.nvim_command('normal! gv')

  M.insert_text_before_cursor(replace_with)
end

--@param replace_with string
M.replace_selected_text_visually = function(replace_with)
  vim.api.nvim_command('normal! gv')

  if vim.fn.visualmode() ~= 'V' then
    -- Switch from characterwise visual to linewise visual
    vim.api.nvim_feedkeys('V', 'x', true)
  end

  M.insert_text_before_cursor(replace_with)
end

M.sort_alphabetically = function(option, no_selection_found_message)
  local text = M.get_visually_selected_text(no_selection_found_message)

  if option == 'Ascending' then
    return sort_text_alphabetically(text, true)
  else if option == 'Descending' then
    return sort_text_alphabetically(text, false)
  end end

  return text
end

---@param text string
---@param separator string|nil
M.break_list_items = function(text, separator)
  if separator == nil then
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
