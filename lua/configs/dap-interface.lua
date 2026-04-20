local dap, dapview = require("dap"), require("dap-view")

-- Listeners

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapview.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapview.close(true)
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapview.close(true)
end

dap.listeners.before.disconnect["dapui_config"] = function()
  dapview.close(true)
end

