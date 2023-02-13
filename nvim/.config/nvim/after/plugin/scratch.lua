local keymap = require('joshuatonga.core.keymap')
local nnoremap = keymap.nnoremap

vim.g.scratch_persistence_file = '~/vim-scratch'
nnoremap('<Leader>sc', ':Scratch<CR>')
