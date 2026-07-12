local dap = require "dap"
local dap_utils = require "dap.utils"
local utils = require "utils"

local NODE_DEBUG_PORT = 7473
local NODE_INSPECTOR_PORT = 9229
local KOTLIN_DEBUG_PORT = 5005

vim.fn.sign_define('DapBreakpoint', { text = '😡', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🥶', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '😭', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '🧐', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '✋🏻', texthl = '', linehl = '', numhl = '' })

-- When hitting a breakpoint, reuse existing window if buffer is already open
-- This prevents DAP from overwriting the current buffer layout
dap.defaults.fallback.switchbuf = 'useopen,uselast'

-- Adapters

-- Kotlin

dap.adapters.kotlin = {
  type = 'executable',
  command = vim.fn.stdpath("data") .. "/lazy/kotlin-debug-adapter/adapter/build/install/adapter/bin/kotlin-debug-adapter",
  options = { auto_continue_if_many_stopped = false },
}

-- JS/TS

for _, language in ipairs({ "pwa-node", "pwa-chrome", "node-terminal", "pwa-extensionHost" }) do
  dap.adapters[language] = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = {
      command = 'node',
      args = {
        utils.get_pkg_path('js-debug-adapter', '/js-debug/src/dapDebugServer.js'),
        '${port}',
      },
    }
  }
end

-- Rust (codelldb)

dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = utils.get_pkg_path('codelldb', '/extension/adapter/codelldb'),
    args = { '--port', '${port}' },
  },
  env = {
    LLDB_LIBRARY_PATH = utils.get_first_existing_path {
      utils.get_pkg_path('codelldb', '/extension/lldb/lib/liblldb.so'),
      utils.get_pkg_path('codelldb', '/extension/lldb/lib/liblldb.dylib'),
    },
  },
}

-- Configuration

-- JS/TS

for _, language in ipairs({ "typescript", "javascript", "typescriptreact" }) do
  dap.configurations[language] = {
    {
      name = "Launch file",
      type = "pwa-node",
      request = "launch",
      program = "${file}",
      cwd = "${workspaceFolder}",
      port = NODE_DEBUG_PORT
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
      internalConsoleOptions = "neverOpen",
      port = NODE_INSPECTOR_PORT
    },
    {
      name = "Attach to Node process",
      type = "pwa-node",
      request = "attach",
      processId = dap_utils.pick_process,
      cwd = "${workspaceFolder}"
    },
    {
      name = "Debug Jest Tests",
      type = "pwa-node",
      request = "launch",
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
    port = KOTLIN_DEBUG_PORT,
    args = {},
    projectRoot = vim.fn.getcwd,
    hostName = "localhost",
    timeout = 2000,
  },
}

-- Rust

dap.configurations.rust = {
  {
    name = "Debug executable (cargo)",
    type = "codelldb",
    request = "launch",
    program = function()
      local handle = io.popen("cargo metadata --no-deps --format-version 1")
      if not handle then
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
      end
      local raw = handle:read("*a")
      handle:close()

      local ok, metadata = pcall(vim.json.decode, raw)
      if not ok then
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
      end

      local binaries = {}
      for _, pkg in ipairs(metadata.packages or {}) do
        for _, target in ipairs(pkg.targets or {}) do
          if target.kind[1] == "bin" then
            table.insert(binaries, target.name)
          end
        end
      end

      if #binaries == 0 then
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
      end

      local bin = binaries[1]
      if #binaries > 1 then
        bin = vim.fn.input("Binary: ", bin, "customlist,v:lua.vim.fn.getcompletion")
      end

      os.execute("cargo build --bin " .. bin .. " > /dev/null 2>&1")
      return vim.fn.getcwd() .. "/target/debug/" .. bin
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
  {
    name = "Debug current file",
    type = "codelldb",
    request = "launch",
    program = function()
      local handle = io.popen("rustc --print cfg | grep target_file | cut -d'\"' -f2")
      if not handle then
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
      end
      local result = handle:read("*a")
      handle:close()
      result = result:gsub("%s+", "")
      if result ~= "" then
        return result
      end
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
  {
    name = "Attach to process",
    type = "codelldb",
    request = "attach",
    pid = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
  },
}

return {}