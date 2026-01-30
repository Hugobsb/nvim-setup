-- Git-based patch system for lazy.nvim plugins
-- Patches are stored as .patch files in lua/patches/files/<plugin-name>.patch
--
-- Usage in plugins/init.lua:
--   {
--     "rcasia/neotest-java",
--     build = function(plugin)
--       require("patches").apply(plugin)
--     end,
--   }

local M = {}

local patches_dir = vim.fn.stdpath("config") .. "/lua/patches/files"

-- Get the patch file path for a plugin
---@param plugin_name string The plugin name (e.g., "neotest-java")
---@return string|nil patch_path Path to the patch file or nil if not found
local function get_patch_file(plugin_name)
  local patch_path = patches_dir .. "/" .. plugin_name .. ".patch"
  if vim.fn.filereadable(patch_path) == 1 then
    return patch_path
  end
  return nil
end

-- Get plugin directory
---@param plugin table|string The lazy.nvim plugin spec or plugin name
---@return string plugin_name, string plugin_dir
local function get_plugin_info(plugin)
  local plugin_name
  local plugin_dir

  if type(plugin) == "string" then
    plugin_name = plugin
    plugin_dir = vim.fn.stdpath("data") .. "/lazy/" .. plugin_name
  else
    plugin_name = plugin.name or plugin[1]:match("[^/]+$")
    plugin_dir = plugin.dir or (vim.fn.stdpath("data") .. "/lazy/" .. plugin_name)
  end

  return plugin_name, plugin_dir
end

-- Run git command in plugin directory
---@param plugin_dir string The plugin directory
---@param args string[] Git command arguments
---@return boolean success, string output
local function git_command(plugin_dir, args)
  local cmd = { "git", "-C", plugin_dir }
  vim.list_extend(cmd, args)

  local result = vim.fn.system(cmd)
  local success = vim.v.shell_error == 0

  return success, result
end

-- Check if patch is already applied
---@param plugin_dir string The plugin directory
---@param patch_path string Path to the patch file
---@return boolean is_applied
local function is_patch_applied(plugin_dir, patch_path)
  -- Try to apply in reverse with --check (dry run)
  -- If it succeeds, the patch is currently applied
  local success, _ = git_command(plugin_dir, { "apply", "--reverse", "--check", patch_path })
  return success
end

-- Apply patch to a plugin
---@param plugin table|string The lazy.nvim plugin spec or plugin name
function M.apply(plugin)
  local plugin_name, plugin_dir = get_plugin_info(plugin)
  local patch_path = get_patch_file(plugin_name)

  if not patch_path then
    return
  end

  -- Check if already applied
  if is_patch_applied(plugin_dir, patch_path) then
    vim.notify(
      string.format("[patches] Patch already applied to %s", plugin_name),
      vim.log.levels.INFO
    )
    return
  end

  local success, output = git_command(plugin_dir, { "apply", "--whitespace=nowarn", patch_path })

  if success then
    vim.notify(
      string.format("[patches] Applied patch to %s", plugin_name),
      vim.log.levels.INFO
    )
  else
    vim.notify(
      string.format("[patches] Failed to apply patch to %s: %s", plugin_name, output),
      vim.log.levels.ERROR
    )
  end
end

-- Reset plugin to original state (unapply patch)
---@param plugin table|string The lazy.nvim plugin spec or plugin name
function M.reset(plugin)
  local plugin_name, plugin_dir = get_plugin_info(plugin)
  local patch_path = get_patch_file(plugin_name)

  if not patch_path then
    vim.notify(
      string.format("[patches] No patch found for %s", plugin_name),
      vim.log.levels.WARN
    )
    return
  end

  -- Check if patch is applied
  if not is_patch_applied(plugin_dir, patch_path) then
    vim.notify(
      string.format("[patches] Patch not applied to %s, nothing to reset", plugin_name),
      vim.log.levels.INFO
    )
    return
  end

  local success, output = git_command(plugin_dir, { "apply", "--reverse", "--whitespace=nowarn", patch_path })

  if success then
    vim.notify(
      string.format("[patches] Reset %s to original state", plugin_name),
      vim.log.levels.INFO
    )
  else
    vim.notify(
      string.format("[patches] Failed to reset %s: %s", plugin_name, output),
      vim.log.levels.ERROR
    )
  end
end

-- List all available patches
---@return string[] plugin_names List of plugin names with patches
function M.list()
  local files = vim.fn.glob(patches_dir .. "/*.patch", false, true)

  local available = {}
  for _, file in ipairs(files) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    table.insert(available, name)
  end

  return available
end

-- Apply all patches
function M.apply_all()
  local plugins = M.list()
  for _, plugin_name in ipairs(plugins) do
    M.apply(plugin_name)
  end
end

-- Reset all plugins to original state
function M.reset_all()
  local plugins = M.list()
  for _, plugin_name in ipairs(plugins) do
    M.reset(plugin_name)
  end
end

-- Show status of all patches
function M.status()
  local plugins = M.list()

  if #plugins == 0 then
    vim.notify("[patches] No patches available", vim.log.levels.INFO)
    return
  end

  local lines = { "Patch status:" }
  for _, plugin_name in ipairs(plugins) do
    local _, plugin_dir = get_plugin_info(plugin_name)
    local patch_path = get_patch_file(plugin_name)
    local applied = patch_path and is_patch_applied(plugin_dir, patch_path)
    local status = applied and "✓ applied" or "✗ not applied"
    table.insert(lines, string.format("  %s: %s", plugin_name, status))
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

return M
