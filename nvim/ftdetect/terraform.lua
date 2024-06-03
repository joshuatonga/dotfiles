vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = { "*.tf", "*.tfvars" },
	callback = function()
		vim.opt_local.filetype = "terraform"
	end,
})
