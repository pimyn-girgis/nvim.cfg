return { -- Theme
  {      --
    'folke/noice.nvim',
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        -- override markdown rendering so that cmp and other plugins use Treesitter
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = false,
        }
      },
    }

  },

  {
    "rcarriga/nvim-notify",
    keys = {
      {
        '<Esc>',
        function() require('notify').dismiss() end,
        silent = true,
      }
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "macchiato",
      integrations = {
        notify = true,
      }
    }
  },
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    config = true
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
      },
    },

    sections = {
      lualine_a = { 'buffer', },
      lualine_b = { 'progress', }
    },
  }
}
