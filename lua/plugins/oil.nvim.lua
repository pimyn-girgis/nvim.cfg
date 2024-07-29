return {  -- edit directories and files like buffers
  "stevearc/oil.nvim",
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    view_options = {
      show_hidden = true,
      natural_order = true,
      is_always_hidden = function(name)
        return name == ".git" or name == ".DS_Store"
      end,
    },
    win_options = {
      wrap = true
    }
  }
}
