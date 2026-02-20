local adapters_list = {
  ["neotest-golang"] = {
    should_load = vim.fn.filereadable("go.mod") == 1,
    config = {
      go_test_args = {
        "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
      },
    },
  },
  ["neotest-java"] = {
    should_load = vim.fn.filereadable("pom.xml") == 1 or vim.fn.filereadable("build.gradle") == 1,
    config = {
      ignore_wrapper = false, -- whether to ignore maven/gradle wrapper
      junit_jar = nil,
      -- default: .local/share/nvim/neotest-java/junit-platform-console-standalone-[version].jar
      incremental_build = true,
      jvm_args = {
        -- Allow bean definition overriding (common in test contexts with mocks)
        "-Dspring.main.allow-bean-definition-overriding=true",
        -- Activate test profile (when the application uses application-test.properties/yml)
        "-Dspring.profiles.active=test",
        -- Disable lazy initialization issues
        "-Dspring.main.lazy-initialization=false",
      },
    },
  },
  ["neotest-jest"] = {
    should_load = vim.fn.filereadable("package.json") == 1,
    config = {
      jestCommand = "npx jest",
      jestArguments = function(defaultArguments, context)
        return defaultArguments
      end,
      jestConfigFile = vim.fn.glob(vim.fn.getcwd() .. "/*{jest,config}*{jest,config}*.{js,ts,json}"),
      env = { CI = true },
      cwd = function()
        return vim.fn.getcwd()
      end,
      isTestFile = function(file_path)
        if not file_path then
          return false
        end
        local extension = "%.[jt]sx?$"
        return file_path:match("_test" .. extension)
            or file_path:match("%.test" .. extension)
            or file_path:match("%.spec" .. extension)
      end,
      jest_test_discovery = true,
      discovery = {
        enabled = false, -- disables neotest discovery to use jest's own test discovery
      },
    },
  },
}

local adapters = {}

for adapter_name, adapter in pairs(adapters_list) do
  if adapter.should_load then
    table.insert(adapters, require(adapter_name)(adapter.config))
  end
end

local config = {
  enable = {
    "test_nearest",
    "test_file",
    "test_suite",
    "last_failed",
    "visit",
    "rerun",
    "debug",
  },
  term_pos = "vert",
  term_opener = "vsplit",
  term_closer = "q",
  term_geo = { "curwin", "vertical", "botright", "split" },
  adapters = adapters,
}

require("neotest").setup(config)
