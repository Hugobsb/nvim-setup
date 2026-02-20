local M = {}

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

---@param str string
---@return boolean
M.is_uuid_valid = function(str)
  return str:lower():match('^%x%x%x%x%x%x%x%x%-%x%x%x%x%-4%x%x%x%-[89ab]%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$') ~= nil
end

return M
