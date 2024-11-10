-- Shortcuts
local opt = vim.opt        -- set options
local wopt = vim.wo
local key = vim.keymap.set -- set keymap
local edit = vim.g         -- set editor variables
local exec = vim.cmd
local auto = vim.api.nvim_create_autocmd

-- Options
opt.tabstop = 2
opt.softtabstop = 2  -- Number of spaces that a <Tab> counts for
opt.textwidth = 120
opt.shiftwidth = 2   -- Size of an indent
opt.expandtab = true -- Use spaces instead of tabs
opt.colorcolumn = '121'
opt.spell = true
opt.relativenumber = true -- Show relative line numbers
-- opt.autochdir = true   -- change directory to directory of open buffer
opt.hlsearch = false      -- Set highlight on search
opt.mouse = 'a'           -- Enable mouse mode
-- opt.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim.
opt.breakindent = true    -- Enable break indent
opt.undofile = true       -- Save undo history
opt.wrap = false
opt.wrapmargin = 2
opt.ignorecase = true -- Case insensitive searching UNLESS \C or capital in search
opt.smartcase = true
opt.updatetime = 250  -- Decrease update time
opt.timeout = true
opt.timeoutlen = 300
opt.completeopt = 'menuone,noselect' -- complete options
opt.termguicolors = true             -- Colors
opt.foldcolumn = '0'                 -- Where to fold
opt.foldlevel = 99                   -- Using ufo provider need a large value
opt.foldlevelstart = 99
opt.foldenable = true
opt.encoding = 'utf-8'
-- Window Options
wopt.signcolumn = 'yes' -- Keep signcolumn on by default
wopt.numberwidth = 2
-- editor variables
edit.mapleader = ' '
edit.maplocalleader = ' '

-- Lua Package Manager
local rocks = vim.fn.expand("$HOME" .. "/.luarocks/share/lua/5.1/?")
package.path = package.path .. ";" .. rocks .. "/init.lua;"
package.path = package.path .. ";" .. rocks .. ".lua;"
-- Plugin Manager
require('config.lazy')
-- Set Theme
exec.colorscheme "catppuccin"

auto(
  'BufWritePost', {
    desc = "Format Go/C/C++/Verilog on save",
    pattern = { "*.go", "*.c", "*.h", "*.cpp", "*.hpp", "*.cc", "*.hh", "*.v", "*.sv" },
    callback = function()
      vim.lsp.buf.format()
    end,
  }
)
auto(
  { 'vimEnter' }, {
    desc = "typst watch on typst files",
    pattern = { "*.typ" },
    command = "TypstWatch",
  }
)

auto('TermEnter', { command = 'startinsert' })

auto(
  'TextYankPost', {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
    pattern = '*',
  }
)

-- keymaps
key('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
key('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
key('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
key('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
key({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true }) -- Leader
-- Remap for dealing with word wrap
key('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
key('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
key('n', '<C-k>', function() vim.api.nvim_open_win() end, { desc = "Open floating preview" })

Capabilities = vim.lsp.protocol.make_client_capabilities()
Capabilities = require('cmp_nvim_lsp').default_capabilities(Capabilities)
Capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

On_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end


local serverlist = {
  clangd = {},
  lua_ls = {
    settings = { Lua = { diagnostics = { globals = { 'vim' } } }, },
  },
  basedpyright = {},
  -- rust_analyzer = {}, -- using rustacean.nvim
  nixd = {
    settings = {
      nixd = {
        nixpkgs = {
          expr = "import <nixpkgs> { }",
        },
        formatting = {
          command = { "nixfmt" },
        },
        options = {
          nixos = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
          },
          home_manager = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."ruixi@k-on".options',
          },
        },
      },
    },
  },
  jdtls = {},
  typst_lsp = {},
}

for name, info in pairs(serverlist) do
   require'lspconfig'[name].setup {
    capabilities = Capabilities,
    on_attach = On_attach,
    settings = info.settings,
    cmd = info.cmd,
  }
end
