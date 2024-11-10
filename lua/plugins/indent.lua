return { -- Add indentation guides even on blank lines
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = true,
    event = "UIEnter",
  },
  -- Detect tabstop and shiftwidth automatically
  {
    'tpope/vim-sleuth',
  }
}
