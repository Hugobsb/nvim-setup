local SESSION_STORAGE = vim.fn.stdpath('data').."/sessions/"

local config = {
  log_level = 'info',                       -- Sets the log level of the plugin                                     - default "info"
  auto_session_enable_last_session = true,  -- Loads the last loaded session if session for cwd does not existing   - default `false`
  auto_session_root_dir = SESSION_STORAGE,  -- Changes the root dir for sessions                                    - default `vim.fn.stdpath('data').."/sessions/"`
  auto_session_enabled = true,              -- Enables/disables the plugin's auto save and restore features         - default `true`
  auto_session_create_enabled = true,       -- Enables/disables the plugin's session auto creation                  - default `true`
  auto_save_enabled = false,                -- Enables/disables auto saving                                         - default `nil`
  auto_restore_enabled = false,             -- Enables/disables auto restoring                                      - default `nil`
  auto_session_suppress_dirs = nil,         -- Suppress session create/restore if in one of the list of dirs        - default `nil`
  auto_session_allowed_dirs = nil,          -- Allow session create/restore if in one of the list of dirs           - default `nil`
  auto_session_use_git_branch = true,       -- Use the git branch to differentiate the session name                 - default `nil`
}

return config

