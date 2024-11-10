return { -- multiple independent Plugins
  {
    'echasnovski/mini.trailspace',
    version = '*',
    keys = {
      {
        '<leader>tt',
        function()
          require('mini.trailspace').trim()
          require('mini.trailspace').trim_last_lines()
        end,
        desc = '[T]rim [T]railspace'
      }
    },
    config = true,
    event = "UIEnter",
  },
  {
    'echasnovski/mini.icons',
    version = '*',
    config = true,
    event = "UIEnter",
  },
}
