return {
	"sindrets/diffview.nvim",
	keys = {
		{ "<leader>dvo", "<cmd>DiffviewOpen<CR>", desc = "Diffview Open" },
		{ "<leader>dvc", "<cmd>DiffviewClose<CR>", desc = "Diffview Close" },
		{ "<leader>dvh", "<cmd>DiffviewHistory<CR>", desc = "Diffview History" },
		{ "<leader>dvt", "<cmd>DiffviewToggleFiles<CR>", desc = "Diffview Toggle File Panel" },
		{ "<leader>dvf", "<cmd>DiffviewFocusFiles<CR>", desc = "Diffview Focus File Panel" },
		{ "<leader>dvn", "<cmd>DiffviewOpen origin/main..HEAD<CR>", desc = "Diffview Compare Origin Main" },
		{ "<leader>dvm", "<cmd>DiffviewOpen main..HEAD<CR>", desc = "Diffview Compare Main" },
	},

	init = function()
		vim.cmd([[cab diff DiffviewOpen]])
	end,

	opts = {
		use_icons = false,
	},
}
