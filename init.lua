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
opt.relativenumber = true     -- Show relative line numbers
opt.autochdir = true
opt.hlsearch = false          -- Set highlight on search
opt.mouse = 'a'               -- Enable mouse mode
opt.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim.
opt.breakindent = true        -- Enable break indent
opt.undofile = true           -- Save undo history
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
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
opt.rtp:prepend(lazypath) -- Plugin Manager
require('lazy').setup('plugins', {})

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

local servers = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  -- See `:help K` for why this keymap
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

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

require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = vim.tbl_keys(servers),
}
require('mason-lspconfig').setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
  ['verible'] = function()
    require('lspconfig').verible.setup {
      cmd = { 'verible-verilog-ls', '--rules_config_search' },
      capabilities = capabilities,
      on_attach = on_attach,
    }
  end,
  ['clangd'] = function()
    require("lspconfig").clangd.setup {
      cmd = {
        "/usr/bin/clangd",
        "--offset-encoding=utf-16",
      },
      capabilities = capabilities,
      on_attach = on_attach,
    }
  end,
}
