local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- use \ default leader key
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

require("lazy").setup("joshuatonga.plugins")
require("joshuatonga.settings")
require("joshuatonga.mappings")
require("joshuatonga.theme")
require("joshuatonga.lsp")
require("joshuatonga.shame")
