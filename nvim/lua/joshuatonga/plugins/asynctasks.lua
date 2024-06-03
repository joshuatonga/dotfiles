return {
	"skywind3000/asynctasks.vim",
	dependencies = {
		"skywind3000/asyncrun.vim",
	},

	init = function()
		vim.g.asyncrun_open = 6 -- Open quickfix

		vim.api.nvim_create_user_command("Ar", "AsyncRun <args>", {
			nargs = "*",
		})

		vim.api.nvim_create_user_command("At", "AsyncTask <args>", {
			nargs = "*",
		})
	end,

	keys = {
		{ "<Leader>gab", ":AsyncTask build<CR>" },
		{ "<Leader>gat", ":AsyncTask test<CR>" },
		{ "<Leader>gar", ":AsyncTask run<CR>" },
	},

	config = function() end,

	cmd = { "Ar", "At", "AsyncRun", "AsyncTask" },
}
