vim.api.nvim_create_user_command("Rg", "GrepperRg <args>", { nargs = "+" })
vim.api.nvim_create_user_command("Rgh", "GrepperRg --hidden <args>", { nargs = "+" })
