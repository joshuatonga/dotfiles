return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")
		wk.setup()
		wk.register({
			mode = { "n" },
			["<leader>f"] = { name = "+file" },
			["<leader>p"] = { name = "+explorer" },
			["<leader>s"] = { name = "+stuff" },
			["<leader>fg"] = { name = "+git" },
		})
	end,
}
