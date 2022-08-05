local keymap = require 'joshuatonga.core.keymap'
local nnoremap = keymap.nnoremap
local tnoremap = keymap.tnoremap

nnoremap('<Leader>tf', ':FloatermNew<CR>')
nnoremap('<Leader>tt', ':FloatermToggle<CR>')
nnoremap('<Leader>tk', ':FloatermKill<CR>')
nnoremap('<Leader>tn', ':FloatermNext<CR>')
nnoremap('<Leader>tp', ':FloatermPrev<CR>')
tnoremap('<Leader>tf', ':FloatermNew<CR>')
tnoremap('<Leader>tt', ':FloatermToggle<CR>')
tnoremap('<Leader>tk', ':FloatermKill<CR>')
tnoremap('<Leader>tn', ':FloatermNext<CR>')
tnoremap('<Leader>tp', ':FloatermPrev<CR>')

vim.api.nvim_create_user_command('LG', 'FloatermNew --height=0.9 --width=0.9 lazygit', {})
nnoremap('<Leader>gg', ':LG<CR>')
