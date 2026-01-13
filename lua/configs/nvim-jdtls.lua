local nvchad_config = require "nvchad.configs.lspconfig"

local jdtls_setup = require "jdtls.setup"

-- Environment setup

local home = os.getenv("HOME")
local data_dir = vim.fn.stdpath("data")
local root_dir = jdtls_setup.find_root { ".git", "mvnw", "gradlew" }
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

local OS = "unsupported"

if vim.fn.has("mac") == 1 then
  local output, _ = vim.fn.system("uname -m")

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
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.
    "java", -- or '/path/to/java11_or_newer/bin/java'

    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:" .. data_dir .. "/mason/packages/jdtls/lombok.jar",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",

    -- 💀
    "-jar",
    vim.fn.glob(data_dir .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version

    -- 💀
    "-configuration",
    data_dir .. "/mason/packages/jdtls/config_" .. OS,

    "-data",
    workspace_dir
  },

  filetypes = { "java" },

  init_options = { bundles = {} },
  on_init = nvchad_config.on_init,
  capabilities = nvchad_config.capabilities,
  on_attach = function(client, bufnr)
    nvchad_config.on_attach(client, bufnr)

    pcall(
      function()
        vim.keymap.del({ "n", "v" }, "<leader>ca", { buffer = bufnr })
      end
    )

    vim.keymap.set(
      { "n", "v" },
      "<leader>ca",
      "<cmd> Lspsaga code_action <CR>",
      { buffer = bufnr, desc = "LSP Code action", noremap = true }
    )
  end,

  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
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
          "org.assertj.core.api.AssertionsForClassTypes.*",
          "org.hamcrest.MatcherAssert.*",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.*",
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
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
      pattern = { "*.java", "*.class", "*.jar" },
      callback = function()
        local bundles = {
          vim.fn.glob(
            data_dir .. "/lazy/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
            true
          )
        }

        vim.list_extend(
          bundles,
          vim.split(
            vim.fn.glob(data_dir .. "/lazy/vscode-java-test/server/*.jar", true),
            "\n"
          )
        )

        local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
        extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
        extendedClientCapabilities.classFileContentsSupport = true

        config.init_options = {
          bundles = bundles,
          extendedClientCapabilities = extendedClientCapabilities,
        }

        require("jdtls").start_or_attach(config)
      end,
    })
  end,
  function(err)
    print("Error on jdtls attach: " .. err)
  end
)

return config
