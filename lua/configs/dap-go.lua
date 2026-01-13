local config = {
  dap_configurations = {
    {
      type = "go",
      name = "Debug (Build Flags & Arguments)",
      request = "launch",
      program = "${file}",
      args = require("dap-go").get_arguments,
      buildFlags = require("dap-go").get_build_flags,
    },
  },
  delve = {
    path = vim.fn.stdpath("data") .. "/lazy/delve/dlv",
  },
}

require("dap-go").setup(config)

