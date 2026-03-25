-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- Josean's Preferences
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- colors
opt.termguicolors = true
opt.background = "dark" 
opt.signcolumn = "yes" 

-- backspace
opt.backspace = "indent,eol,start" 

-- clipboard (Crucial for system clipboard!)
opt.clipboard:append("unnamedplus") 

-- split windows
opt.splitright = true 
opt.splitbelow = true 

-- turn off swapfile
opt.swapfile = false
