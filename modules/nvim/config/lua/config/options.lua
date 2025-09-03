-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"
vim.g.solarized_termcolors = 256
vim.g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB

local opt = vim.opt
opt.background = "dark"
opt.colorcolumn = "120"
opt.encoding = "utf-8"
opt.expandtab = true
opt.fileformat = "unix"
opt.foldenable = false
opt.formatoptions = "croql"
opt.relativenumber = true
opt.ruler = true
opt.shiftwidth = 2
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false -- disable swapfiles because they are fucking garbage
opt.tabstop = 4
opt.termguicolors = true
opt.textwidth = 120
opt.timeoutlen = 500
opt.ttimeoutlen = 10
opt.visualbell = true
