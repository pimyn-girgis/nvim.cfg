return { -- Terminal in neovim
  'akinsho/toggleterm.nvim',
  version = "*",

  config = function()
    local Terminal = require('toggleterm.terminal').Terminal
    local ex       = function(cmd)
      return Terminal:new({
        cmd = cmd,
        hidden = true,
        direction = 'float',
      })
    end
    Lazygit        = function() ex('lazygit'):toggle() end
    Htop           = function() ex('htop'):toggle() end
    local opts     = {
      insert_mappings = true,
      direction = 'float',
    }
    require('toggleterm').setup(opts)
  end,

  keys = {
    {
      '<C-j>',
      "<Cmd>ToggleTerm direction=horizontal<CR><Cmd>startinsert<CR>",
      silent = true,
      mode = {'n', 'i'},
      desc = 'Open terminal'
    },
    {
      '<C-j>',
      "<Cmd>ToggleTerm<CR>",
      silent = true,
      mode = 't',
      desc = 'Close terminal'
    },
    {
      '<C-w>',
      "<Cmd>stopinsert<CR><C-w>",
      mode = 't',
    },
    {
      '<C-g>',
      "<Cmd>lua Lazygit()<CR>",
      silent = true,
      desc = 'Open lazygit'
    },
    {
      '<C-h>',
      "<Cmd>lua Htop()<CR>",
      silent = true,
      desc = 'Open lazygit'
    },
  }
}
