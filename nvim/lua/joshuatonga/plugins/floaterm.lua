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
		{ "<Leader>fn", ":FloatermNew<CR>" },
		{ "<Leader>ft", ":FloatermToggle<CR>" },
		{ "<Leader>fk", ":FloatermKill<CR>" },
		{ "<Leader>fn", ":FloatermNext<CR>" },
		{ "<Leader>fh", ":FloatermPrev<CR>" },
		{ mode = { "t" }, "<Leader>fn", "<C-\\><C-n>:FloatermNew<CR>" },
		{ mode = { "t" }, "<Leader>ft", "<C-\\><C-n>:FloatermToggle<CR>" },
		{ mode = { "t" }, "<Leader>fk", "<C-\\><C-n>:FloatermKill<CR>" },
		{ mode = { "t" }, "<Leader>fk", "<C-\\><C-n>:FloatermNext<CR>" },
		{ mode = { "t" }, "<Leader>fh", "<C-\\><C-n>:FloatermPrev<CR>" },
		{ "<Leader>gg", ":LG<CR>" },
	},
}
