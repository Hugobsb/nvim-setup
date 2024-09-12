local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local config = {
  rootDir = require "lspconfig/util".root_pattern({ ".gradlew", ".git", "mvnw" }),
  cmd = {
    os.getenv("HOME") .. "/.local/share/nvim/mason/bin/jdtls",
    "--jvm-arg=-javaagent:" .. os.getenv("HOME") .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
    "--jvm-arg=-Xbootclasspath/a:" .. os.getenv("HOME") .. "/.config/nvim/plugins/jdtls/lombok.jar"
  },
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  contentProvider = { preferred = "fernflower" },
  settings = {
    java = {
      signatureHelp = { enabled = true },
    },
  },
  filetypes = { "java" },
  init_options = {
    bundles = {},
  },
}

xpcall(
  function()
    local bundles = {
      vim.fn.glob(
        os.getenv("HOME")
        .. "/.local/share/nvim/lazy/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
        true
      )
    }

    vim.list_extend(
      bundles,
      vim.split(
        os.getenv("HOME")
        .. vim.fn.glob("/.local/share/nvim/lazy/vscode-java-test/server/*.jar", true),
        "\n"
      )
    )

    local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    config.init_options = {
      bundles = bundles,
      extendedClientCapabilities = extendedClientCapabilities,
    }

    require("jdtls").start_or_attach(config)

    print("jdtls has been attached successfully!")
  end,
  function(err)
    print("Error on jdtls attach: " .. err)
  end
)

return config
