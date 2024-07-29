return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'folke/lazydev.nvim',
    },
    lazy = false,
  },
  {
    'kaarmu/typst.vim',
    ft = 'typst',
  },
  { -- show variable types
    'jubnzv/virtual-types.nvim',
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
    }
  },
}
