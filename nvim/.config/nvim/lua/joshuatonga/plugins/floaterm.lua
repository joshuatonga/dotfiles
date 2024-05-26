return {
	"voldikss/vim-floaterm",

	init = function()
		vim.g.floaterm_height = 0.9
		vim.g.floaterm_width = 0.9
	end,

	config = function()
		vim.api.nvim_create_user_command("LG", "FloatermNew --height=0.99 --width=0.99 lazygit", {})
	end,

	cmd = "LG",

	keys = {
		{ "<Leader>tf", ":FloatermNew<CR>" },
		{ "<Leader>tt", ":FloatermToggle<CR>" },
		{ "<Leader>tk", ":FloatermKill<CR>" },
		{ "<Leader>tn", ":FloatermNext<CR>" },
		{ "<Leader>tp", ":FloatermPrev<CR>" },
		{ mode = { "t" }, "<Leader>tf", "<C-\\><C-n>:FloatermNew<CR>" },
		{ mode = { "t" }, "<Leader>tt", "<C-\\><C-n>:FloatermToggle<CR>" },
		{ mode = { "t" }, "<Leader>tk", "<C-\\><C-n>:FloatermKill<CR>" },
		{ mode = { "t" }, "<Leader>tn", "<C-\\><C-n>:FloatermNext<CR>" },
		{ mode = { "t" }, "<Leader>tp", "<C-\\><C-n>:FloatermPrev<CR>" },
		{ "<Leader>gg", ":LG<CR>" },
	},
}
