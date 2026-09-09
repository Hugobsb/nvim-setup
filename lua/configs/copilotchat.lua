local config = {
  model = 'claude-sonnet-5',

  prompts = {
    JavaDoc = {
      sticky = '#buffer',
      prompt = "Write me a Java doc for the selected function",
    },
    ChangeLog = {
      sticky = { '#buffers', '#gitdiff:origin/develop' },
      prompt = "Based on the provided diff and on the CHANGELOG markdown file, write the latest " ..
               "changed/added/removed details using the \"Keep a Changelog\" format.",
    },
  },
}

return config
