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
    init = function()
      require('mini.trailspace').setup()
    end
  },
}
