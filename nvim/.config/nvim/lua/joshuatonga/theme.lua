-- vim.cmd("colorscheme eldar")
-- vim.cmd("colorscheme default")
-- vim.cmd("colorscheme industry")
-- vim.cmd("colorscheme ron")
vim.cmd("colorscheme cinnabar")

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
