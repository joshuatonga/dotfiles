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

	theme = {
		variant = "default",
		highlights = {
			LspInlayHint = { fg = "#176101" },
		},
		colors = {
			-- bg = "#0C0C0C",
			bg = "#000000",
			bgAlt = "#1e2124",
			bgHighlight = "#3c4048",
			fg = "#ffffff",
			grey = "#808080",
			blue = "#00afaf",
			green = "#27c400",
			cyan = "#0000E7",
			red = "#f21616",
			yellow = "#f1ff5e",
			magenta = "#e81010",
			pink = "#e81010",
			orange = "#ed5615",
			purple = "#ff8503",
		},
	},
})
vim.cmd("colorscheme cyberdream")
require("nightfox").setup({
	palettes = {
		carbonfox = {
			bg1 = "#000000",
			bg0 = "#1d1d2b",
			bg3 = "#121820", -- 55% darkened from stock
			sel0 = "#131b24", -- 55% darkened from stock
		},
	},
})
-- vim.cmd("colorscheme carbonfox")

-- vim.cmd("highlight Normal guibg=black")

-- show a visual indicator when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 100,
		})
	end,
})

-- vim.cmd("highlight Folded guibg=green guifg=white")
-- vim.cmd("highlight CursorLine guibg=#212121")
