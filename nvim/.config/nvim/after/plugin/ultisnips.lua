vim.cmd([[
augroup ultisnips_no_auto_expansion
    au!
    au VimEnter * au! UltiSnips_AutoTrigger
augroup END
]])

vim.g.UltiSnipsEditSplit = "vertical"
vim.g.UltiSnipsSnippetDirectories = { "ultisnips" }

vim.keymap.set("n", "<Leader>use", ":UltiSnipsEdit<CR>")
