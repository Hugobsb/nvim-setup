local config = {
  handle = {
    color = "#565761",
  },
  marks = {
    Search = {
      color = "#ff9c00",
    },
    Error = {
      color = "#ff0000",
    },
    Warn = {
      color = "#eaff1c",
    },
    Info = {
      color = "#eeefde",
    },
    Hint = {
      color = "#fffa44",
    },
    Misc = {
      color = "#00efff",
    },
    GitAdd = {
      text = "┆",
      color = "#00ff85",
    },
    GitChange = {
      text = "┆",
      color = "#ffa600",
    },
    GitDelete = {
      text = "▁",
      color = "#da4343",
    },
  },
  handlers = {
    cursor = false,
    search = true,
    ale = true,
  },
}

return config
