vim.opt.background = "dark"

require("cyberdream").setup({
	borderless_pickers = false,

	variant = "default",
	highlights = {
		LspInlayHint = { fg = "#176101" },
		Comment = { fg = "#B2727B" },
		LineNr = { fg = "#88C9F2" },
		CursorLineNr = { fg = "#B2727B" },
	},
	colors = {
		-- bg = "#0C0C0C",
		bg = "#000000",
		bgAlt = "#1e2124",
		bgHighlight = "#3c4048",
		fg = "#ffffff",
		grey = "#808080",
		-- blue = "#00afaf",
		-- blue = "#77BEBC",
		blue = "#88C9F2",
		green = "#27c400",
		cyan = "#0000E7",
		red = "#f21616",
		yellow = "#f1ff5e",
		magenta = "#e81010",
		pink = "#e81010",
		orange = "#ed5615",
		-- purple = "#ff8503",
		purple = "#52E2DD",
	},
})
vim.cmd("colorscheme cyberdream")
-- vim.cmd("colorscheme eldar")
-- vim.cmd("colorscheme default")
-- vim.cmd("colorscheme industry")
-- vim.cmd("colorscheme ron")
-- vim.cmd("colorscheme cinnabar")

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
