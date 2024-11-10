return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'folke/lazydev.nvim',
    },
  },
  {
    'kaarmu/typst.vim',
    ft = 'typst',
  },
  { -- show variable types
    'jubnzv/virtual-types.nvim',
    event = "UIEnter",
  },

  { -- show function signature
    'ray-x/lsp_signature.nvim',
    opts = {
      bind = true,
      handler_opts = {
        border = "rounded"
      },
      select_signature_key = "<C-s>",
      toggle_key = "<C-h>",
    },
    event = "InsertEnter",
  },
  {
    "aznhe21/actions-preview.nvim",
    keys = {
      { '<leader>ca', function() require("actions-preview").code_actions() end, desc = "[C]ode [A]ction" },
    }
  },
}
