require('mason').setup()

require('mason-lspconfig').setup({
  ensure_installed = { 'pyright', 'terraformls', 'sumneko_lua', 'gopls' }
})
