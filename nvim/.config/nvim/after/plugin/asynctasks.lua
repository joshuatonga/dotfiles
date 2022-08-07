local keymap = require 'joshuatonga.core.keymap'
local nnoremap = keymap.nnoremap

vim.g.asyncrun_open = 6;  -- Open quickfix

vim.api.nvim_create_user_command('Ar', 'AsyncRun <args>', {
  nargs = '*'
})


vim.api.nvim_create_user_command('At', 'AsyncTask <args>', {
  nargs = '*'
})

local opts = { silent = true }
nnoremap('<Leader>gab', ':AsyncTask build<CR>', opts)
nnoremap('<Leader>gat', ':AsyncTask test<CR>', opts)
nnoremap('<Leader>gar', ':AsyncTask run<CR>', opts)
