local config = {
  rootDir = require "lspconfig/util".root_pattern({ ".gradlew", ".git", "mvnw" }),
  cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/jdtls" },
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

    config.init_options = {
      bundles = bundles,
    }

    require("jdtls").start_or_attach(config)

    print("jdtls has been attached successfully!")
  end,
  function(err)
    print("Error on jdtls attach: " .. err)
  end
)

return config
