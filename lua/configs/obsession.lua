local session_path = os.getenv('HOME') .. '/.local/share/nvim/sessions/'

local _, session_name = xpcall(
  function() return vim.fn.system('tmux display-message -p "#S"') end,
  function() end
)

if session_name ~= nil then
  session_name = session_name:gsub('[^%w%.%-_]', '') .. '.vim'

  local has_session = tonumber(
    vim.fn.system(
      'cat '
      .. session_name ..
      ' >/dev/null 2>&1 && echo "1" || echo "0"'
    )
  )

  if has_session then
    vim.cmd('source ' .. session_path .. session_name)

    return
  end

  vim.fn.execute('Obsession ' .. session_path .. session_name)
end

