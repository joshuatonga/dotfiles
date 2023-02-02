local keymap = require 'joshuatonga.core.keymap'
local nnoremap = keymap.nnoremap

nnoremap('<C-e>', ':NERDTreeToggle<CR>')
nnoremap('<C-t>', ':NERDTreeFocus<CR>')
nnoremap('<leader>nf', ':NERDTreeFind<CR>')

vim.g.NERDTReeWinSize = 40
vim.g.NERDTreeGitStatusUseNerdFonts = 1
--vim.g.NERDTreeQuitOnOpen = 1
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeShowLineNumbers = 1

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'nerdtree',
  command = 'setlocal relativenumber'
})

-- vim.api.nvim_create_autocmd({'VimEnter'}, {
--   pattern = '*',
--   command = 'NERDTree'
-- })
