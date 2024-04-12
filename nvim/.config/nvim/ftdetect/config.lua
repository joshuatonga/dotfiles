vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.config" },
	callback = function()
		vim.opt_local.filetype = "yaml"
	end,
})
