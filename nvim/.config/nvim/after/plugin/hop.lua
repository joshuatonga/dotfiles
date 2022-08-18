require('hop').setup()
local keymap = require 'joshuatonga.core.keymap'
local nnoremap = keymap.nnoremap

nnoremap('<Leader><Leader>w', ':HopWord<CR>')
nnoremap('<Leader><Leader>b', ':HopWordBC<CR>')
nnoremap('f',
  "<CMD>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<CR>")
nnoremap('f',
  "<CMD>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<CR>")
nnoremap('F',
  "<CMD>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<CR>")
nnoremap('t',
  "<CMD>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<CR>")
nnoremap('T',
  "<CMD>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<CR>")
