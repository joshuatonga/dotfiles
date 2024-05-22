vim.g["test#strategy"] = "make"

vim.keymap.set("n", "<Leader>gt", ":TestNearest<CR>")
vim.keymap.set("n", "<Leader>gT", ":TestFile<CR>")
vim.keymap.set("n", "<Leader>gs", ":TestSuite<CR>")
vim.keymap.set("n", "<Leader>gl", ":TestLast<CR>")
vim.keymap.set("n", "<Leader>gL", ":TestVisit<CR>")
