return {
	{
		"github/copilot.vim",
	},

	{
		"olimorris/codecompanion.nvim",
		opts = {
			strategies = {
				chat = {
					adapter = "copilot",
					model = "gpt-4.1",
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
}
