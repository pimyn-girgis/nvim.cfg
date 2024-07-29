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
