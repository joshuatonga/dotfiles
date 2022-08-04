local keymap = require 'joshuatonga.core.keymap'
local nnoremap = keymap.nnoremap

vim.g.floaterm_keymap_new = '<Leader>tf'
vim.g.floaterm_keymap_toggle = '<Leader>tt'
vim.g.floaterm_keymap_kill = '<Leader>tk'
vim.g.floaterm_keymap_next = '<Leader>tn'
vim.g.floaterm_keymap_prev = '<Leader>tp'

vim.api.nvim_create_user_command('LG', 'FloatermNew --height=0.9 --width=0.9 lazygit', {})
nnoremap('<Leader>gg', ':LG<CR>')
