local M = {}

local function is_base64_valid(str)
  return str:match("^[A-Za-z0-9+/]*=?=?$") ~= nil
    and #str % 4 == 0
    and #str > 0
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

---@param c string
M.char_to_hex = function(c)
  return string.format("%%%02X", string.byte(c))
end

---@param text string
M.url_encode = function(text)
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

return M
