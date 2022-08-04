local keymap = require 'joshuatonga.core.keymap'
local nnoremap = keymap.nnoremap

local actions = require 'telescope.actions'
require('telescope').setup {
  defaults = {
    mappings = {
      n = {
        ['q'] = actions.close,
      },

      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      }
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
    }
  }
}
require('telescope').load_extension('fzf')

vim.api.nvim_create_user_command('Maps', 'Telescope keymaps', {})

nnoremap('<C-p>', ":lua require('telescope.builtin').find_files({ hidden = true })<CR>")
nnoremap('<leader>fs', ":lua require('telescope.builtin').live_grep()<CR>")
nnoremap('<leader>fb', ":lua require('telescope.builtin').buffers()<CR>")
nnoremap('<leader>fh', ":lua require('telescope.builtin').help_tags()<CR>")
nnoremap('<leader>fm', ":lua require('telescope.builtin').man_pages()<CR>")
nnoremap('<leader>fr', ":lua require('telescope.builtin').old_files()<CR>")
nnoremap('<leader>fg', ":lua require('telescope.builtin').git_status()<CR>")
nnoremap('<leader>fc', ":lua require('telescope.builtin').git_bcommits()<CR>")
