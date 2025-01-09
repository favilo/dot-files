vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true


vim.opt.signcolumn = 'yes'
vim.opt.isfname:append("@-@")

vim.g.mapleader = " "

vim.opt.list = true
vim.opt.listchars:append({ space = "⋅" })
vim.opt.listchars:append({ eol = "↴" })
vim.opt.listchars:append({ tab = "→ " })
vim.opt.listchars:append({ trail = "↴" })
vim.opt.listchars:append({ extends = "↴" })
vim.opt.listchars:append({ precedes = "↴" })
vim.opt.listchars:append({ nbsp = "⎵" })
