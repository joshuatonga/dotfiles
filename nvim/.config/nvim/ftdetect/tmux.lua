vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.tmux' },
  callback = function()
    vim.opt_local.filetype = 'sh'
  end,
})
