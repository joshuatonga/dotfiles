vim.opt.background = "dark"

-- vim.cmd("colorscheme eldar")
-- vim.cmd("colorscheme default")
-- vim.cmd("colorscheme industry")
-- vim.cmd("colorscheme ron")
-- vim.cmd("colorscheme cinnabar")

-- require("gruvbox").setup({
-- 	terminal_colors = true, -- add neovim terminal colors
-- 	undercurl = false,
-- 	underline = false,
-- 	bold = false,
-- 	italic = {
-- 		strings = false,
-- 		emphasis = false,
-- 		comments = false,
-- 		operators = false,
-- 		folds = false,
-- 	},
-- 	strikethrough = false,
-- 	invert_selection = false,
-- 	invert_signs = false,
-- 	invert_tabline = false,
-- 	invert_intend_guides = false,
-- 	inverse = true, -- invert background for search, diffs, statuslines and errors
-- 	contrast = "hard", -- can be "hard", "soft" or empty string
-- 	palette_overrides = {},
-- 	overrides = {},
-- 	dim_inactive = false,
-- 	transparent_mode = false,
-- })
-- vim.opt.background = "dark"
-- vim.cmd("colorscheme gruvbox")

require("cyberdream").setup({
	borderless_telescope = false,
})
vim.cmd("colorscheme cyberdream")

vim.cmd("highlight Normal guibg=black")

-- show a visual indicator when yanking
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 100,
		})
	end,
})

vim.cmd("highlight Folded guibg=green guifg=white")
vim.cmd("highlight CursorLine guibg=#212121")
