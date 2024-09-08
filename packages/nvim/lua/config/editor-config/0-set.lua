-- set curson in insert mode
-- vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

-- indentation --
-- https://vim.fandom.com/wiki/Indenting_source_code
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

-- folding --
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 1

-- disable line wrapping
vim.opt.wrap = false

-- disable swapfile, enable undo file
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = false

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "
