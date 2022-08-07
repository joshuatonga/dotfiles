local keymap = require 'joshuatonga.core.keymap'
local nnoremap = keymap.nnoremap

local opts = { silent = true }
vim.g['test#strategy'] = 'make'

nnoremap('<Leader>gt', ':TestNearest<CR>', opts)
nnoremap('<Leader>gT', ':TestFile<CR>', opts)
nnoremap('<Leader>gs', ':TestSuite<CR>', opts)
nnoremap('<Leader>gl', ':TestLast<CR>', opts)
nnoremap('<Leader>gL', ':TestVisit<CR>', opts)
