local utils = require "utils"
local screenshot = require "modules.screenshot"
local patches = require "patches"

local new_cmd = vim.api.nvim_create_user_command

new_cmd('Base64Encode', function()
  local no_selection_found_message = 'A text must be selected to encode it.'

  local selection = utils.get_visually_selected_text(no_selection_found_message)

  if selection == nil then
    return
  end

  local ok, encoded_string = xpcall(
    utils.base64_encode,
    function(err)
      vim.notify(
        'Failed to encode the selected text: ' .. err,
        vim.log.levels.ERROR,
        { title = 'Base64Encode command' }
      )
      return false
    end,
    selection
  )

  if ok then
    utils.replace_selected_text(encoded_string)
  end

  -- Cleaning the visual selection
  vim.cmd('normal! gv')
end, { addr = 'lines', range = '%' })

new_cmd('Base64Decode', function()
  local no_selection_found_message = 'A text must be selected to decode it.'

  local selection = utils.get_visually_selected_text(no_selection_found_message)

  if selection == nil then
    return
  end

  local ok, decoded_string = xpcall(
    utils.base64_decode,
    function(err)
      vim.notify(
        'Failed to decode the selected text: ' .. err,
        vim.log.levels.ERROR,
        { title = 'Base64Decode command' }
      )
      return false
    end,
    selection
  )

  if ok then
    utils.replace_selected_text(decoded_string)
  end

  -- Cleaning the visual selection
  vim.cmd('normal! gv')
end, { addr = 'lines', range = '%' })

new_cmd('GenerateUUID', function()
  local ok, id = xpcall(
    utils.generate_uuid,
    function(err)
      vim.notify(
        'Failed to generate UUID: ' .. err,
        vim.log.levels.ERROR,
        { title = 'GenerateUUID command' }
      )
    end
  )

  if ok then
    utils.insert_text_before_cursor(id)
  end
end, {})

new_cmd('GenerateUUIDFromString', function()
  local no_selection_found_message = 'A text must be selected to generate the UUID from the string.'

  local selection = utils.get_visually_selected_text(no_selection_found_message)

  if selection == nil then
    return
  end

  local ok, id = xpcall(
    utils.generate_uuid_from_string,
    function(err)
      vim.notify(
        'Failed to generate UUID from string: ' .. err,
        vim.log.levels.ERROR,
        { title = 'GenerateUUIDFromString command' }
      )
    end,
    selection
  )

  if ok then
    vim.fn.setreg('"', id, 'v')

    -- Cleaning visual selection
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)

    vim.notify(
      'The UUID for the selected string was generated successfully and copied to the unnamed registry `"`.',
        vim.log.levels.INFO,
      { title = 'GenerateUUIDFromString command' }
    )
  end
end, { addr = 'lines', range = '%' })

new_cmd('SortAlphabetically', function()
  local no_selection_found_message = 'A text must be selected to sort it.'

  local options = { 'Ascending', 'Descending' }

  vim.ui.select(options, { prompt = 'Choose the sort method: ' }, function(choice)
    if choice ~= options[1] and choice ~= options[2] then
      vim.notify(
        " " .. string.format("Invalid option. You must select between '%s' and %s.", options[1], options[2]),
        vim.log.levels.WARN,
        { title = 'SortAlphabetically command' }
      )
    else
      local ok, sorted_string = xpcall(
        utils.sort_alphabetically,
        function(err)
          vim.notify(
            'Failed to sort the selected text: ' .. err,
            vim.log.levels.ERROR,
            { title = 'SortAlphabetically command' }
          )
          return false
        end,
        choice, no_selection_found_message
      )

      if ok then
        utils.replace_selected_text_visually(sorted_string)
      end
    end

    -- Cleaning the visual selection
    vim.cmd('normal! gv')
  end)

end, { addr = 'lines', range = '%' })

new_cmd('GenerateISODate', function()
  local iso_date = utils.generate_iso_date()

  utils.insert_text_before_cursor(iso_date)
end, {})

new_cmd('ValidateUUID', function()
  local no_selection_found_message = 'A text must be selected to validate it.'

  local options = { 'v4' }

  vim.ui.select(options, { prompt = 'Choose the UUID version: ' }, function(choice)
    if choice ~= options[1] then
      vim.notify(
        " " .. string.format("Invalid option. You must select between the following options: ['%s']", options[1]),
        vim.log.levels.WARN,
        { title = 'CheckUUID command' }
      )
    else
      local selection = utils.get_visually_selected_text(no_selection_found_message)

      local ok, is_valid = xpcall(
        utils.is_uuid_valid,
        function(err)
          vim.notify(
            'Failed to validate the selected text: ' .. err,
            vim.log.levels.ERROR,
            { title = 'CheckUUID command' }
          )
          return false
        end,
        selection
      )

      if not ok then
        return
      end

      local message = is_valid and 'The selected text is a valid UUID.' or 'The selected text is not a valid UUID.'

      vim.notify(message, vim.log.levels.INFO, { title = 'CheckUUID command' })
    end

    -- Cleaning the visual selection
    vim.cmd('normal! gv')
  end)

end, { addr = 'lines', range = '%' })

new_cmd('Screenshot', function()
  xpcall(
    screenshot,
    function (err)
        vim.notify(
          'Failed to take screenshot of the selected text:' .. err,
          vim.log.levels.ERROR,
          { title = 'Screenshot command' }
        )
      return false
    end
  )
end, { addr = 'lines', range = '%' })

new_cmd('RunSH', function()
  vim.fn.execute("set splitright | vnew | set filetype=sh | execute('read !sh #') | execute getline(1) == '' ? '1delete' : ''")
end, {})

new_cmd('HarpoonTelescope', function()
  local harpoon_files = require'harpoon':list()
  local conf = require("telescope.config").values

  local file_paths = {}

  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end, {})

new_cmd('TelescopeCustomBufferFind', function()
  local action_state = require('telescope.actions.state')

  local function get_buffers()
    require'telescope.builtin'.buffers{
      initial_mode = 'normal',
      attach_mappings = function(prompt_bufnr, map)
        local delete_buf = function()
          local current_picker = action_state.get_current_picker(prompt_bufnr)
          current_picker:delete_selection(function(selection)
            vim.api.nvim_buf_delete(selection.bufnr, { force = true })
          end)
        end

        map('n', '<c-e>', delete_buf)

        return true
      end
    }
  end

  get_buffers()
end, {})

new_cmd('GenerateTarballHash', function()
  local no_selection_found_message = 'A tarball URL must be selected to generate its hash.'

  local selection = utils.get_visually_selected_text(no_selection_found_message)

  if selection == nil then
    return
  end

  if string.match(selection, "^https?://[%w%-%./@]+/-/[%w%-]+%-%d+%.%d+%.%d+%.tgz$") == nil then
    vim.notify(
      'The selected text is not a valid tarball URL. The hash will not be generated.',
      vim.log.levels.WARN,
      { title = 'GenerateTarballHash command' }
    )
    return
  end

  local ok, hash = xpcall(
    utils.generate_tarball_hash,
    function(err)
      vim.notify(
        'Failed to hash the file for the selected URL: ' .. err,
        vim.log.levels.ERROR,
        { title = 'GenerateTarballHash command' }
      )
      return false
    end,
    selection
  )

  if ok then
    vim.fn.setreg('"', 'sha512-' .. hash, 'v')

    -- Cleaning visual selection
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)

    vim.notify(
      'The hash for the selected tarball URL was generated successfully and copied to the unnamed registry `"`.',
      vim.log.levels.INFO,
      { title = 'GenerateTarballHash command' }
    )
  end

  -- Cleaning the visual selection
  vim.cmd('normal! gv')
end, { addr = 'lines', range = '%' })

new_cmd('PatchApply', function(opts)
  if opts.args ~= "" then
    patches.apply(opts.args)
  else
    patches.apply_all()
  end
end, {
  nargs = "?",
  complete = function()
    return patches.list()
  end,
  desc = "Apply plugin patches (optionally for a specific plugin)",
})

new_cmd('PatchReset', function(opts)
  if opts.args ~= "" then
    patches.reset(opts.args)
  else
    patches.reset_all()
  end
end, {
  nargs = "?",
  complete = function()
    return patches.list()
  end,
  desc = "Reset plugin to original state (optionally for a specific plugin)",
})

new_cmd('PatchStatus', function()
  patches.status()
end, {
  desc = "Show status of all plugin patches",
})
