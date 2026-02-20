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

    require("utils").override_code_action_with_lspsaga(bufnr)

    -- Java-specific test debugging (overrides neotest debug for Java buffers)
    -- Uses nvim-jdtls directly which is more reliable than neotest-java debug
    vim.keymap.set("n", "<leader>td", function()
      require("jdtls").test_nearest_method()
    end, { buffer = bufnr, desc = "Debug nearest test (jdtls)" })

    vim.keymap.set("n", "<leader>tD", function()
      require("jdtls").test_class()
    end, { buffer = bufnr, desc = "Debug test class (jdtls)" })

    vim.keymap.set("n", "<leader>tp", function()
      require("jdtls").pick_test()
    end, { buffer = bufnr, desc = "Pick test to debug (jdtls)" })
  end,

  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = (function()
          local runtimes = {}
          local sdkman_java_dir = home .. "/.sdkman/candidates/java"
          local java_dirs = vim.fn.glob(sdkman_java_dir .. "/*", false, true)
          local current_java = vim.fn.resolve(sdkman_java_dir .. "/current")

          for _, java_path in ipairs(java_dirs) do
            local dir_name = vim.fn.fnamemodify(java_path, ":t")
            if dir_name ~= "current" then
              local major_version = dir_name:match("^(%d+)")
              if major_version then
                table.insert(runtimes, {
                  name = "JavaSE-" .. major_version,
                  path = java_path,
                  default = (java_path == current_java),
                })
              end
            end
          end

          return runtimes
        end)(),
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
          -- JUnit 5
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.junit.jupiter.api.DynamicContainer.*",
          "org.junit.jupiter.api.DynamicTest.*",
          -- JUnit 4
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          -- AssertJ
          "org.assertj.core.api.Assertions.*",
          "org.assertj.core.api.AssertionsForClassTypes.*",
          "org.assertj.core.api.AssertionsForInterfaceTypes.*",
          "org.assertj.core.api.BDDAssertions.*",
          -- Hamcrest
          "org.hamcrest.MatcherAssert.*",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          -- Mockito
          "org.mockito.Mockito.*",
          "org.mockito.BDDMockito.*",
          "org.mockito.ArgumentMatchers.*",
          "org.mockito.AdditionalMatchers.*",
          "org.mockito.AdditionalAnswers.*",
          -- Spring Test
          "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
          "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
          "org.springframework.test.web.servlet.result.MockMvcResultHandlers.*",
          "org.springframework.test.web.servlet.setup.MockMvcBuilders.*",
          -- Java standard library
          "java.util.Objects.*",
          "java.util.Collections.*",
          "java.util.stream.Collectors.*",
          "java.util.Map.entry",
          "java.util.Optional.*",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
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

local function start_jdtls()
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
end

config.start = start_jdtls

return config
