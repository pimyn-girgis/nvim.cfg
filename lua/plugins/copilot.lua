return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = true },
      filetypes = { markdown = true },
    }
  },
  { -- copilot-cmp
    "zbirenbaum/copilot-cmp",
    config = true,
  },

}
