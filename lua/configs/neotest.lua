local adapters_list = {
  ["neotest-golang"] = {
    should_load = vim.fn.glob("go.mod") ~= "",
    config = {
      go_test_args = {
        "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
      },
    },
  },
  ["neotest-java"] = {
    should_load = vim.fn.glob("pom.xml") ~= "" or vim.fn.glob("build.gradle") ~= "",
    config = {
      ignore_wrapper = false, -- whether to ignore maven/gradle wrapper
      junit_jar = nil,
      -- default: .local/share/nvim/neotest-java/junit-platform-console-standalone-[version].jar
      incremental_build = true
    },
  },
  ["neotest-jest"] = {
    should_load = vim.fn.glob("package.json") ~= "",
    config = {
      jestCommand = "npm test --",
      -- jestConfigFile = "jest.config.js",

      env = { CI = true },

      cwd = function()
        return vim.fn.getcwd()
      end,

      jest_test_discovery = false,
      discovery = {
        enabled = false,
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

