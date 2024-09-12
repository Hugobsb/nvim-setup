local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local utils = require "utils"

-- Environment setup

local home = os.getenv("HOME")

local OS = "unsupported"
local WORKSPACE_PATH = home .. "/workspace/"

if vim.fn.has("mac") == 1 then
  local output, _ = utils.execute_os_command("uname -m")

  if output and output:match("arm64") then
    OS = "mac_arm"
  else
    OS = "mac"
  end
elseif vim.fn.has("unix") == 1 then
  OS = "linux"
end


local config = {
  rootDir = require "lspconfig/util".root_pattern({ ".gradlew", ".git", "mvnw" }),

  cmd = {
    "java", -- or '/path/to/java11_or_newer/bin/java'
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",

    -- 💀
    "-jar",
    vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version

    -- 💀
    "-configuration",
    home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. OS,

    "-data",
    WORKSPACE_PATH .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),

  },
  filetypes = { "java" },
  init_options = {
    bundles = {},
  },
  contentProvider = { preferred = "fernflower" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,

  settings = {
    java = {
      signatureHelp = { enabled = true },
      configuration = {
        updateBuildConfiguration = "interactive",
        -- runtimes = {
        --   {
        --     name = "JavaSE-11",
        --     path = "/usr/lib/jvm/java-11-openjdk/",
        --     default = true
        --   },
        --   -- {
        --   --   name = "JavaSE-17",
        --   --   path = "/usr/lib/jvm/java-17-openjdk/",
        --   -- },
        -- },
      },

      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all", -- literals, all, none
        },
      },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
      },
    },
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

    vim.api.nvim_create_autocmd("BufRead", {
      pattern = { "*.java", "*.class", "*.jar" },
      callback = function()
        require("jdtls").start_or_attach(config)
      end,
    })
  end,
  function(err)
    print("Error on jdtls attach: " .. err)
  end
)

return config
