return {
	"sindrets/diffview.nvim",
	opts = {
		use_icons = false,
	},

	config = function(_, opts)
		require("diffview").setup(opts)
		vim.cmd([[cab diff DiffviewOpen]])

		vim.keymap.set("n", "<leader>dvo", "<cmd>DiffviewOpen<CR>", { desc = "Diffview Open" })
		vim.keymap.set("n", "<leader>dvc", "<cmd>DiffviewClose<CR>", { desc = "Diffview Close" })
		vim.keymap.set("n", "<leader>dvf", "<cmd>DiffviewFileHistory<CR>", { desc = "Diffview File History" })
		vim.keymap.set(
			"n",
			"<leader>dvn",
			"<cmd>DiffviewOpen origin/main..HEAD<CR>",
			{ desc = "Diffview Compare Origin Main" }
		)
		vim.keymap.set("n", "<leader>dvm", "<cmd>DiffviewOpen main..HEAD<CR>", { desc = "Diffview Compare Main" })

		-- <leader>b to toggle the file panel
		-- vim.keymap.set("n", "<leader>dvt", "<cmd>DiffviewToggleFiles<CR>", { desc = "Diffview Toggle File Panel" })

		-- <leader>e to focus the file panel
		-- vim.keymap.set("n", "<leader>dvf", "<cmd>DiffviewFocusFiles<CR>", { desc = "Diffview Focus File Panel" })
	end,
}
