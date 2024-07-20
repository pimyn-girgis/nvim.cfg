return {
  'mistricky/codesnap.nvim',
  build = "make build_generator",
  keys = {
    {
      "<leader>cc",
      "<Esc><Cmd>CodeSnap<cr>",
      mode = "x",
      desc = "Save selected code snapshot into clipboard",
    },
    {
      "<leader>cs",
      "<Esc><Cmd>CodeSnapSave<cr>",
      mode = "x",
      desc = "Save selected code snapshot in ~/Pictures",
    },
  },
  opts = {
    save_path = "~/Pictures",
    title = "",
    code_font_family = "JetBrainsMono Nerd Font",
    watermark_font_family = "Pacifico",
    watermark = "",
    bg_theme = "default",
    breadcrumbs_separator = "/",
    has_breadcrumbs = false,
    has_line_number = true,
    show_workspace = false,
    min_width = 0,
    bg_x_padding = 122,
    bg_y_padding = 82,
  },
}
