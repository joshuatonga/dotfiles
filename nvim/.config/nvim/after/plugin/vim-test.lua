local keymap = require('joshuatonga.core.keymap')
local nnoremap = keymap.nnoremap

vim.g['test#strategy'] = 'make'

local opts = { silent = true }
nnoremap('<Leader>gt', ':TestNearest<CR>', opts)
nnoremap('<Leader>gT', ':TestFile<CR>', opts)
nnoremap('<Leader>gs', ':TestSuite<CR>', opts)
nnoremap('<Leader>gl', ':TestLast<CR>', opts)
nnoremap('<Leader>gL', ':TestVisit<CR>', opts)
