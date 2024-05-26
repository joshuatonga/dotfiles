return {
	"SirVer/ultisnips",

	dependencies = {
		"honza/vim-snippets",
	},

	config = function()
		local augroup = vim.api.nvim_create_augroup("ultisnips_no_auto_expansion", { clear = true })

		vim.api.nvim_create_autocmd("VimEnter", {
			group = augroup,
			callback = function()
				vim.api.nvim_exec_autocmds("User", { pattern = "UltiSnips_AutoTrigger", modeline = false })
			end,
		})

		vim.g.UltiSnipsEditSplit = "vertical"
		vim.g.UltiSnipsSnippetDirectories = { "ultisnips" }

		vim.keymap.set("n", "<Leader>use", ":UltiSnipsEdit<CR>")
	end,
}
