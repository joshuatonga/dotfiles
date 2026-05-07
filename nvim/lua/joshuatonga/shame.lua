-- Don't know where to put it? put it here temporarily
-- Fix for GBrowse too many arguments - https://github.com/tpope/vim-fugitive/issues/2441#issuecomment-4240457814
vim.api.nvim_create_user_command("Browse", function(opts)
	vim.fn.system({ "xdg-open", opts.fargs[1] })
end, { nargs = 1 })
