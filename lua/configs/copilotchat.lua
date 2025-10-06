local config = {
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
    Commit = {
      sticky = { '#gitdiff:staged' },
      prompt = "Write commit message for the change with conventional commits format. " ..
        "Keep the title under 50 characters and wrap message at 72 characters. " ..
        "Every single line must not have more than 72 characters. " ..
        "Format as a gitcommit code block. " ..
        "Format separated ideas with hyphens and lines breaks."
    },
  },
}

return config
