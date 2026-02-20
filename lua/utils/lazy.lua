local M = {}

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

return M
