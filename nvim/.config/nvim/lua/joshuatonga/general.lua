vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "python",
	command = "setlocal ts=4 sw=4 sts=4 expandtab",
})

vim.api.nvim_set_hl(0, "LineNr", {})
vim.api.nvim_set_hl(0, "NonText", { ctermbh = nil })

vim.opt.confirm = true
vim.opt.shortmess = vim.opt.shortmess + { A = true, c = true } -- disable swap message
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.termguicolors = true
vim.opt.hlsearch = false
vim.opt.autoread = true -- set to auto read when a file is changed from the outside
vim.opt.timeout = true
vim.opt.ttimeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10
vim.opt.encoding = "utf8" -- set standard encoding
vim.opt.ffs = { "unix", "dos", "mac" } -- use unix as the standard file type
vim.opt.splitbelow = true -- open new split panes to right and bottom which feels more natural than vim's default
vim.opt.splitright = true
vim.opt.wildmenu = true -- visual autocomplete for command menu
vim.opt.wildignore = { "*.o", "*~", "*.pyc" } -- ignore compiled files
vim.opt.cursorline = true -- highlight current line
vim.opt.incsearch = true -- search as characters are entered
vim.opt.ignorecase = true -- case insensitive
vim.opt.showmatch = true -- show matching brackets when text indicator is over them
vim.opt.mat = 2 -- how many tenths of a second to blink when matching brackets
vim.opt.number = true -- add left side numbes ( line number )
vim.opt.relativenumber = true
vim.opt.tabstop = 2 -- size of a hard tabstop
vim.opt.shiftwidth = 2 -- size of an indent
vim.opt.softtabstop = 2 -- a combination of spaces and tabs are used to simulate tab stops at a width other than the (hard)tabstop
vim.opt.smarttab = true -- make tab insert indents instead of tabs at the beginning of a line
vim.opt.expandtab = true -- always uses spaces instead of tab characters
vim.opt.autoindent = true -- auto indent
vim.opt.smartindent = true -- smart indent
vim.opt.wrap = true -- wrap lines
vim.opt.colorcolumn = "120"
vim.opt.foldmethod = "indent"
vim.opt.foldnestmax = 10
vim.opt.foldenable = false -- don't fold when opening a file
vim.opt.clipboard = { "unnamed", "unnamedplus" }
vim.opt.shada = "!,'300,<50,@100,s10,h"
vim.opt.mouse = ""
vim.opt.scrolloff = 8
vim.g.netrw_bufsettings = "noma nomod nu nowrap ro nobl"
-- vim.g.netrw_altfile = 1
vim.g.python3_host_prog = "~/.py3nvim/bin/python"
