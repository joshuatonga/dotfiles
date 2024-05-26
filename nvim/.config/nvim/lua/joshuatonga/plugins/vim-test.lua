return {
	"vim-test/vim-test",

	keys = {
		{ "<Leader>gt", ":TestNearest<CR>" },
		{ "<Leader>gT", ":TestFile<CR>" },
		{ "<Leader>gs", ":TestSuite<CR>" },
		{ "<Leader>gl", ":TestLast<CR>" },
		{ "<Leader>gL", ":TestVisit<CR>" },
	},

	init = function()
		vim.g["test#strategy"] = "make"
	end,
}
