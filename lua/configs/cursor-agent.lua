local config = {
  cmd = "cursor-agent",

  -- Whether to send content via stdin when using non-terminal helpers
  use_stdin = true,
  -- Reserved for future concurrency control
  multi_instance = false,
  -- Timeout for non-streaming helpers (ms)
  timeout_ms = 60000,
  -- Auto-scroll behavior for certain UI helpers
  auto_scroll = true,
}

return config

