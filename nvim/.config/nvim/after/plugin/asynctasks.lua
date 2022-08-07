vim.g.asyncrun_open = 6;  -- Open quickfix

vim.api.nvim_create_user_command('Ar', 'AsyncRun <args>', {
  nargs = '*'
})


vim.api.nvim_create_user_command('At', 'AsyncTask <args>', {
  nargs = '*'
})
