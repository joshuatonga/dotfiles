return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	-- tag = "v0.0.23",
	version = false,
	opts = {
		provider = "copilot",
		file_selector = {
			provider = "snacks",
		},
	},
	build = "make",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		"folke/snacks.nvim",
		{
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			config = function()
				require("copilot").setup({})
			end,
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "Avante" },
			},
			ft = { "Avante" },
		},
	},
}
