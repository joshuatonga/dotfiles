local keymap = require("joshuatonga.core.keymap")
local nnoremap = keymap.nnoremap

vim.cmd([[
augroup ultisnips_no_auto_expansion
    au!
    au VimEnter * au! UltiSnips_AutoTrigger
augroup END
]])

vim.g.UltiSnipsEditSplit = "vertical"
vim.g.UltiSnipsSnippetDirectories = { "ultisnips" }

nnoremap("<Leader>use", ":UltiSnipsEdit<CR>")
