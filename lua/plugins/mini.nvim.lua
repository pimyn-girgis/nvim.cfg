return { -- multiple independent Plugins
  'echasnovski/mini.nvim',
  version = false,
  init = function()
    require('mini.icons').setup()
    require('mini.operators').setup()
    require('mini.trailspace').setup()
  end,
  keys = {
    -- trailspace
    {
      '<leader>tt',
      function()
        MiniTrailspace.trim()
        MiniTrailspace.trim_last_lines()
      end,
      desc = '[T]rim [T]railspace'
    }
  }
}
