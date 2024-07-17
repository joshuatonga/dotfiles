return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")
		wk.add({
			{ "<leader>f", group = "file" },
			{ "<leader>p", group = "explorer" },
			{ "<leader>s", group = "stuff" },
			{ "<leader>fg", group = "git" },
		})
	end,
}
