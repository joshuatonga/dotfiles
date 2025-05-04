return {
	{
		"olimorris/codecompanion.nvim",
		opts = {},
		lazy = false,
		keys = {
			{ "<leader>cc", ":CodeCompanionChat toggle<CR>", mode = { "n", "v" }, desc = "CodeCompanionChat toggle" },
			{ "<space>cc", ":CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "CodeCompanion show actions" },
			{ "<leader>ci", ":CodeCompanionChat Add<CR>", mode = { "v" }, desc = "CodeCompanionChat Add" },
		},
		config = function(_, opts)
			require("codecompanion").setup(opts)
			-- Expand 'cc' into 'CodeCompanion' in the command line
			vim.cmd([[cab cc CodeCompanion]])
			vim.cmd([[cab ccc CodeCompanionChat]])
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"zbirenbaum/copilot.lua",
				cmd = "Copilot",
				-- event = "InsertEnter",
				config = function()
					require("copilot").setup({})
				end,
			},
		},
	},
}
