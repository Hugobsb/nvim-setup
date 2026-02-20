-- Sessions are only managed for TMUX sessions
if os.getenv('TMUX') == nil then
  return
end

local function load(session_file, should_restore)
  if should_restore then
    vim.cmd('silent! source ' .. session_file)
    return
  end

  vim.fn.execute('silent! Obsession ' .. session_file)
end

local tmux_info = vim.fn.system({ 'tmux', 'display-message', '-p', '#S/#W/#P' })

if vim.v.shell_error ~= 0 then
  vim.notify(
    "Failed to retrieve tmux session data",
    vim.log.levels.ERROR,
    { title = "Session" }
  )
  return
end

local session_name, window_name, panel_number = vim.trim(tmux_info):match("^(.-)/(.-)/(.-)$")

if not session_name or not window_name or not panel_number then
  vim.notify(
    "Failed to parse tmux session data: " .. tmux_info,
    vim.log.levels.ERROR,
    { title = "Session" }
  )
  return
end

session_name = session_name:gsub('[^%w%.%-_]', '')
window_name = window_name:gsub('[^%w%.%-_]', '')
panel_number = panel_number:gsub('[^%w%.%-_]', '')

local session_path = vim.fn.stdpath("data") .. '/sessions/'
if vim.fn.isdirectory(session_path) == 0 then
  vim.fn.mkdir(session_path, "p")
end

local session_file = session_path .. session_name .. '-' .. window_name .. '-' .. panel_number .. '.vim'

local has_session = vim.fn.filereadable(session_file) == 1

load(session_file, has_session)
