# Sessions are only managed for TMUX sessions
if os.getenv('TMUX') == nil then
  return
end

local function load(session_file, should_create)
  if should_create == 1 then
    vim.cmd('silent! source ' .. session_file)
    return
  end

  vim.fn.execute('silent! Obsession ' .. session_file)
end

local session_path = os.getenv('HOME') .. '/.local/share/nvim/sessions/'

local _, session_name = xpcall(
  function() return vim.fn.system('tmux display-message -p "#S"') end,
  function() end
)

local _, window_name = xpcall(
  function() return vim.fn.system('tmux display-message -p "#W"') end,
  function() end
)

if session_name ~= nil and window_name ~= nil then
  session_name = session_name:gsub('[^%w%.%-_]', '')
  window_name = window_name:gsub('[^%w%.%-_]', '')

  local session_file = session_path .. session_name .. '-' .. window_name .. '.vim'

  local has_session = tonumber(
    vim.fn.system(
      'cat '
      .. session_file ..
      ' >/dev/null 2>&1 && echo "1" || echo "0"'
    )
  )

  load(session_file, has_session)
end

