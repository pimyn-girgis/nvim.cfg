return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp', {
      'L3MON4D3/LuaSnip',
      config = function()
        Ls = require 'luasnip'
        Ls.config.setup {}
        Ls.config.set_config({
          history = true,                            -- keep last snippet local to jump back
          updateevents = "TextChanged,TextChangedI", -- Update while typing in insert mode
          enable_autosnippets = true,                -- use autosnippets
          ext_opts = {
            [require("luasnip.util.types").choiceNode] = {
              active = {
                virt_text = { { "choiceNode", "Comment" } },
              },
            }
          }
        })

        require("luasnip.loaders.from_lua").load({
          paths = {
            "~/.config/nvim/snippets/"
          }
        })
      end
    },
    event = 'InsertEnter',
    'hrsh7th/cmp-cmdline', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path',
  },
  config = function()
    local cmp = require('cmp')
    cmp.setup({
      snippet = {
        expand = function(args)
          Ls.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },

      mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-k>'] = cmp.mapping.complete(),
        ['<C-y>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if Ls.expand_or_locally_jumpable() then
            Ls.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if Ls.locally_jumpable(-1) then
            Ls.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sorting = {
        priority_weight = 1,
        comparators = {
          cmp.config.compare.locality,
          cmp.config.compare.recently_used,
          cmp.config.compare.score,
          cmp.config.compare.offset,
          cmp.config.compare.order,
        },
      },
      sources = cmp.config.sources({
        { name = "copilot" },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = "path" },
      })
    })
  end,
  event = 'InsertEnter',
}
