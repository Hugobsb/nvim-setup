local config = {
  prompts = {
    JavaDoc = {
      prompt = "Write me a Java doc for the selected function",
    },
    ChangeLog = {
      prompt = "Based on the diff between the current branch and the branch where it parted from " ..
               "(most probably `develop`), write the latest changed/added/removed details using " ..
               "the \"Keep a Changelog\" format.",
    },
  },
}

return config
