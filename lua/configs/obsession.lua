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

local function get_tmux_data(cmd)
  local _, result, err = xpcall(
    function()
      local m = vim.fn.system(cmd)

      if string.match(m, 'No such file or directory') ~= nil then
        return nil, "Failed to retrieve tmux data: " .. m
      end

      return m
    end,
    function()  return nil, "Unexpected failure when retrieving tmux data" end
  )

  return result, err
end

local session_path = os.getenv('HOME') .. '/.local/share/nvim/sessions/'

local session_name, s_err = get_tmux_data('tmux display-message -p "#S"')

if s_err ~= nil then
  vim.notify(
    "Failed to restore session (session name retrieval error): " .. s_err,
    "error",
    { title = "Session" }
  )
end

local window_name, w_err = get_tmux_data('tmux display-message -p "#W"')

if s_err ~= nil then
  vim.notify(
    "Failed to restore session (window name retrieval error): " .. w_err,
    "error",
    { title = "Session" }
  )
end

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

