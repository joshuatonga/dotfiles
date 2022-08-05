local keymap = require 'joshuatonga.core.keymap'
local nnoremap = keymap.nnoremap
local inoremap = keymap.inoremap
local vnoremap = keymap.vnoremap
local xnoremap = keymap.xnoremap

vim.g.mapleader = ','

local opts = { silent = true }

nnoremap('<C-q>', ':q<CR>', opts)

-- Pane navigations
nnoremap('<C-j>', '<C-w><C-j>')
nnoremap('<C-k>', '<C-w><C-k>')
nnoremap('<C-l>', '<C-w><C-l>')
nnoremap('<C-h>', '<C-w><C-h>')

-- Custom utilities
nnoremap('<C-f>', function()
  vim.cmd('silent !tmux neww tmux-sessionizer')
end)

nnoremap('<Leader>hw', ':help <C-r><C-w><CR>') -- Open help page for the word under cursor
nnoremap('<C-w>+', ':resize +10<CR>', opts)
nnoremap('<C-w>-', ':resize -10<CR>', opts)
nnoremap('<C-w>>', ':vertical resize +10<CR>', opts)
nnoremap('<C-w><', ':vertical resize -10<CR>', opts)

-- Quickfix mappings
nnoremap('Q', ':copen<CR>', opts)
nnoremap(']q', ':cnext<CR>', opts)
nnoremap('[q', ':cprev<CR>', opts)
nnoremap(']Q', ':cfirst<CR>', opts)
nnoremap('[Q', ':clast<CR>', opts)

-- Stay in visual mode when indenting. Ref: https://github.com/ChristianChiarulli/nvim/blob/master/lua/user/keymaps.lua
vnoremap('<', '<gv', opts)
vnoremap('>', '>gv', opts)

-- Don't copy the word when pasting
vnoremap('p', '"_dP', opts)

-- Visual block moving
xnoremap('J', ":move '>+1<CR>gv-gv", opts)
xnoremap('K', ":move '<-2<CR>gv-gv", opts)
-- xnoremap('<A-j>', ":move '>+1<CR>gv-gv", opts)
-- xnoremap('<A-k>', ":move '<-2<CR>gv-gv", opts)

nnoremap('<C-s>', ':w<CR>')
inoremap('jj', '<Esc>')

nnoremap('<Leader>sv', ':source %<CR>')
