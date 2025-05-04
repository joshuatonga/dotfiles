return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
	},

	opts = {
		provider_selector = function()
			return { "indent" }
		end,
	},

	init = function()
		vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.opt.foldlevelstart = 99
	end,
}
