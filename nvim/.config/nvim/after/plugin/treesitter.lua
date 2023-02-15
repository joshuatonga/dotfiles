require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"javascript",
		"dockerfile",
		"json",
		"lua",
		"markdown",
		"python",
		"regex",
		"typescript",
		"vim",
		"yaml",
	},
	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,
	-- Automatically install missing parsers when entering buffer
	auto_install = true,
	highlight = {
		enable = true,
		disable = {},
	},
	indent = {
		enable = true,
		disable = { "python", "yaml" },
	},
	rainbow = {
		enable = false,
		extended_mode = true,
		max_file_lines = nil,
	},
})

-- Workaround when using treesitter with folds. See: https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation
vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
	group = vim.api.nvim_create_augroup("TS_FOLD_WORKAROUND", {}),
	callback = function()
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	end,
})
