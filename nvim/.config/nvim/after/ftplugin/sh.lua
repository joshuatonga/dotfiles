vim.api.nvim_create_autocmd("BufEnter", {
	pattern = ".env",
	group = vim.api.nvim_create_augroup("__env", { clear = true }),
	callback = function()
		vim.diagnostic.enable(false)
	end,
})
