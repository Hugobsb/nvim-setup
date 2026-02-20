local M = {}

-- Re-export domain-specific sub-modules
local submodules = {
  require "utils.encoding",
  require "utils.uuid",
  require "utils.selection",
  require "utils.lazy",
}

for _, mod in ipairs(submodules) do
  for k, v in pairs(mod) do
    M[k] = v
  end
end

-- General-purpose utilities

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
  if vim.fn.filereadable(path) == 1 then
    return path
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
