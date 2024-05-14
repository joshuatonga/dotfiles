vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*ssh/config*" },
	callback = function()
		vim.opt_local.filetype = "sshconfig"
	end,
})
