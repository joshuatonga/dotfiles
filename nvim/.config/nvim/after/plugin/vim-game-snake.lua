local keymap = require 'joshuatonga.core.keymap'
local nnoremap = keymap.nnoremap

vim.g.VimSnakeMode = 'hard'
nnoremap('<Leader>vgs', ':VimGameSnake<CR>')
