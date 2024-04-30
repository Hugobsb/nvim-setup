local dap = require "dap"
local dap_utils = require "dap.utils"

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🔵', texthl = '', linehl = '', numhl = '' })
-- vim.fn.sign_define('DapBreakpointRejected', { text = 'R', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '⚪', texthl = '', linehl = '', numhl = '' })
-- vim.fn.sign_define('DapStopped', { text = '→', texthl = '', linehl = 'debugPC', numhl = '' })

-- Adapters

dap.adapters.kotlin = {
  type = 'executable',
  command = os.getenv("HOME") .. "/.local/share/nvim/lazy/kotlin-debug-adapter/adapter/build/install/adapter/bin/kotlin-debug-adapter",
  options = { auto_continue_if_many_stopped = false },
}

-- JS/TS adapter is configured by a separate module

-- JS/TS

for _, language in ipairs({ "typescript", "javascript", "typescriptreact" }) do
  dap.configurations[language] = {
    {
      name = "Launch file",
      type = "pwa-node",
      request = "launch",
      program = "${file}",
      cwd = "${workspaceFolder}",
      port = 7473
    },
    {
      name = "Launch process",
      type = "pwa-node",
      request = "launch",
      runtimeExecutable = "npm",
      runtimeArgs = {
        "run-script",
        "start:debug"
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen"
    },
    {
      name = "Attach to Node process",
      type = "pwa-node",
      request = "attach",
      processId = dap_utils.pick_process,
      cwd = "${workspaceFolder}"
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Jest Tests",
      -- trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        vim.fn.getcwd() .. "/node_modules/jest/bin/jest.js",
        "--runInBand",
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen"
    }
  }
end

-- Kotlin

dap.configurations.kotlin = {
  {
    type = "kotlin",
    request = "launch",
    name = "Kotlin Launch",
    projectRoot = "${workspaceFolder}",
    mainClass = function()
      -- path until src
      local root = vim.fs.find("src", { path = vim.uv.cwd(), upward = true, stop = vim.env.HOME })[1] or "" -- /home/hugobsb/projects/work/ab-inbev/banking/pix-out-transaction/src

      -- path until src + path until filename
      local fname = vim.api.nvim_buf_get_name(0) -- /home/hugobsb/Projects/work/ab-inbev/banking/pix-out-transaction/src/main/kotlin/com/bees/pixouttransaction/PixOutTransactionApplication.kt

      -- use src to cut the class path
      -- example: com.abcd.efgh.MainApplicationKt
      return fname:sub(string.len(root) + 2):gsub("main/kotlin/", ""):gsub(".kt", "Kt"):gsub("/", ".")
    end,
    preLaunchTask = "build",
    jsonLogFile = "",
    enableJsonLogging = false,
  },
  {
    -- Use this for unit tests
    -- First, run 
    -- ./gradlew --info cleanTest test --debug-jvm
    -- then attach the debugger to it
    type = "kotlin",
    request = "attach",
    name = "Attach to debugging session",
    port = 5005,
    args = {},
    projectRoot = vim.fn.getcwd,
    hostName = "localhost",
    timeout = 2000,
  },
}

return {}

