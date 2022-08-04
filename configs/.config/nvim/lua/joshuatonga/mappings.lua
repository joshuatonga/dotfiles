local keymap = require 'joshuatonga.core.keymap'
local nnoremap = keymap.nnoremap
local inoremap = keymap.inoremap

vim.g.mapleader = ','

nnoremap('Q', '<nop>',  { silent = true, noremap = true })
nnoremap('<C-left>', ':tabprevious')
nnoremap('<C-left>', ':tabprevious')
nnoremap('<C-j>', '<C-w><C-j>')
nnoremap('<C-k>', '<C-w><C-k>')
nnoremap('<C-l>', '<C-w><C-l>')
nnoremap('<C-h>', '<C-w><C-h>')

nnoremap('<C-w>+', ':resize +5<CR>', { silent = true, noremap = true })
nnoremap('<C-w>-', ':resize -5<CR>', { silent = true, noremap = true })
nnoremap('<C-w>>', ':vertical resize +5<CR>', { silent = true, noremap = true })
nnoremap('<C-w><', ':vertical resize -5<CR>', { silent = true, noremap = true })

nnoremap('<C-s', ':w<CR>')
inoremap('<C-s', '<Esc>:w<CR>')
inoremap('jj', '<Esc>')

nnoremap('<Leader>sv', ':source %<CR>')
