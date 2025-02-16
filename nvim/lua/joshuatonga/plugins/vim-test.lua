return {
	"vim-test/vim-test",

	keys = {
		{ "<Leader>tt", ":TestNearest<CR>" },
		{ "<Leader>tT", ":TestFile<CR>" },
		{ "<Leader>ts", ":TestSuite<CR>" },
		{ "<Leader>tl", ":TestLast<CR>" },
		{ "<Leader>tL", ":TestVisit<CR>" },
	},

	init = function()
		vim.g["test#strategy"] = "make"
	end,
}
