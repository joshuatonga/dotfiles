vim.g.floaterm_height = 0.9
vim.g.floaterm_width = 0.9

vim.keymap.set("n", "<Leader>tf", ":FloatermNew<CR>")
vim.keymap.set("n", "<Leader>tt", ":FloatermToggle<CR>")
vim.keymap.set("n", "<Leader>tk", ":FloatermKill<CR>")
vim.keymap.set("n", "<Leader>tn", ":FloatermNext<CR>")
vim.keymap.set("n", "<Leader>tp", ":FloatermPrev<CR>")
vim.keymap.set("t", "<Leader>tf", "<C-\\><C-n>:FloatermNew<CR>")
vim.keymap.set("t", "<Leader>tt", "<C-\\><C-n>:FloatermToggle<CR>")
vim.keymap.set("t", "<Leader>tk", "<C-\\><C-n>:FloatermKill<CR>")
vim.keymap.set("t", "<Leader>tn", "<C-\\><C-n>:FloatermNext<CR>")
vim.keymap.set("t", "<Leader>tp", "<C-\\><C-n>:FloatermPrev<CR>")

vim.api.nvim_create_user_command("LG", "FloatermNew --height=0.99 --width=0.99 lazygit", {})
vim.keymap.set("n", "<Leader>gg", ":LG<CR>")
