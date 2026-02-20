local M = {}

local function is_base64_valid(str)
  return str:match("^[A-Za-z0-9+/]*=?=?$") ~= nil
    and #str % 4 == 0
    and #str > 0
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

M.log_table_to_console = function(table)
   if type(table) == 'table' then
      local str = '{ '
      for key, value in pairs(table) do
         if type(key) ~= 'number' then key = '"'..key..'"' end
         str = str .. '['..key..'] = ' .. M.log_table_to_console(value) .. ','
      end
      return str .. '} '
   else
      return tostring(table)
   end
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
  -- Save the current cursor position
  vim.api.nvim_command('normal! gv')

  M.insert_text_before_cursor(replace_with)
end

--@param replace_with string
M.replace_selected_text_visually = function(replace_with)
  -- Save the current cursor position
  vim.api.nvim_command('normal! gv')

  if vim.fn.visualmode() ~= 'V' then
    -- Switch from characterwise visual to linewise visual
    vim.api.nvim_feedkeys('V', 'x', true)
  end

  M.insert_text_before_cursor(replace_with)
end

---@param str string
---@return string
M.base64_encode = function(str)
  if is_base64_valid(str) then
    vim.notify(
      'Warning: the given string can be already encoded',
      vim.log.levels.WARN,
      { title = 'Base64 encode utilitary' }
    )
  end

  local output = vim.fn.system({ 'base64' }, str)

  if vim.v.shell_error ~= 0 then
    error('base64 encode failed: ' .. output)
  end

  return (output:gsub("\n$", ""))
end

---@param str string
---@return string
M.base64_decode = function(str)
  if not is_base64_valid(str) then
    error('The given string is not a valid base64')
  end

  local output = vim.fn.system({ 'base64', '--decode' }, str)

  if vim.v.shell_error ~= 0 then
    error('base64 decode failed: ' .. output)
  end

  return (output:gsub("\n$", ""))
end

---@return string
M.generate_uuid = function()
  local result = vim.fn.system({ 'uuidgen' })

  if vim.v.shell_error ~= 0 then
    error('Failed to generate UUID: ' .. result)
  end

  result = vim.trim(result)

  if result == '' then
    error('An error occurred while generating the UUID. The UUID generator function evaluated an empty result.')
  end

  return result
end

---@param str string
---@return string
M.generate_uuid_from_string = function(str)
  local sha1_output = vim.fn.system({ 'sha1sum' }, str)

  if vim.v.shell_error ~= 0 then
    error('Failed to compute sha1: ' .. sha1_output)
  end

  local hash = sha1_output:match('^(%x+)')

  if not hash or #hash < 32 then
    error('An error occurred while generating the UUID from string. Invalid sha1 output.')
  end

  hash = hash:sub(1, 32)

  local uuid = string.format(
    '%s-%s-4%s-a%s-%s',
    hash:sub(1, 8),
    hash:sub(9, 12),
    hash:sub(14, 16),
    hash:sub(18, 20),
    hash:sub(21, 32)
  )

  return uuid
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

M.validate_and_convert_github_url = function(url)
    if url == nil then return nil end

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
  if bounds == nil then
    bounds = {
      maximum = 24,
      minimum = 8
    }
  end

---@diagnostic disable-next-line: undefined-field
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

---@param c string
M.char_to_hex = function(c)
  return string.format("%%%02X", string.byte(c))
end

---@param text string
M.url_encode = function (text)
  text = text:gsub("\n", "\r\n")
  text = text:gsub("([^%w ])", M.char_to_hex)
  text = text:gsub(" ", "+")
  return text
end

---@param x string
M.hex_to_char = function(x)
  return string.char(tonumber(x, 16))
end

---@param text string
M.url_decode = function(text)
  text = text:gsub("+", " ")
  text = text:gsub("%%(%x%x)", M.hex_to_char)
  return text
end

---@param str string
---@return boolean
M.is_uuid_valid = function(str)
  return str:lower():match('^%x%x%x%x%x%x%x%x%-%x%x%x%x%-4%x%x%x%-[89ab]%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$') ~= nil
end

---@param url string
M.generate_tarball_hash = function(url)
  local command = 'curl -sSL ' .. vim.fn.shellescape(url) .. ' | openssl dgst -sha512 -binary | openssl base64 -A'

  local result = vim.fn.system(command)

  if vim.v.shell_error ~= 0 then
    error('Failed to generate tarball hash: ' .. result)
  end

  if type(result) ~= 'string' or #result == 0 then
    error('An error occurred while generating the tarball hash. The hash generator function evaluated an empty result.')
  end

  return result
end

M.get_repo_with_ssh_prefix = function(repo)
  local prefix = os.getenv("LAZY_SSH_PREFIX")
  if not prefix or prefix == "" then
    return repo
  end

  if type(repo) == "string" and not repo:match("^" .. prefix) then
    return prefix .. repo
  end

  return repo
end

M.mutate_lazy_plugins_list_with_ssh_prefix = function(plugins)
  for _, plugin in ipairs(plugins) do
    if type(plugin[1]) == "string" then
      plugin[1] = M.get_repo_with_ssh_prefix(plugin[1])
    end
    if plugin.dependencies then
      for i, dep in ipairs(plugin.dependencies) do
        if type(dep) == "string" then
          plugin.dependencies[i] = M.get_repo_with_ssh_prefix(dep)
        elseif type(dep) == "table" and type(dep[1]) == "string" then
          dep[1] = M.get_repo_with_ssh_prefix(dep[1])
        end
      end
    end
  end
end

M.with_file_verification = function(args, file_path)
  local file_exists = vim.fn.filereadable(file_path) == 1

  if not file_exists then
    return nil
  end

  return args
end

M.with_optional_activation = function(env_var, source)
  local is_activated = os.getenv(env_var) ~= nil

  if is_activated then
    return source
  end

  return nil
end

-- JS/TS adapter is configured by a separate module

--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
M.get_pkg_path = function(pkg, path)
  pcall(require, 'mason')

  local root = vim.env.MASON or (vim.fn.stdpath('data') .. '/mason') or ''

  return root .. '/packages/' .. pkg .. '/' .. path
end

--- Returns the file at the given path if it exists, nil otherwise.
---@param path string
---@return string|nil
M.get_path_if_exists = function(path)
  local file = vim.fn.glob(path)

  if file ~= "" then
    return file
  end

  return nil
end

--- Returns the first existing path from a list of paths, nil if none exist.
---@param paths string[]
---@return string|nil
M.get_first_existing_path = function(paths)
  for _, path in ipairs(paths) do
    local file = M.get_path_if_exists(path)
    if file then
      return file
    end
  end

  return nil
end

--- Override NvChad's <leader>ca with Lspsaga code_action for a buffer.
---@param bufnr number
M.override_code_action_with_lspsaga = function(bufnr)
  pcall(vim.keymap.del, { "n", "v" }, "<leader>ca", { buffer = bufnr })
  vim.keymap.set(
    { "n", "v" },
    "<leader>ca",
    "<cmd>Lspsaga code_action<CR>",
    { buffer = bufnr, desc = "LSP Code action", noremap = true }
  )
end

return M
