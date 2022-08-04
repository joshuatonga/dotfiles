require('lsp-format').setup()
local lsp = require 'lspconfig'
local cmp_nvim_lsp = require 'cmp_nvim_lsp'
local keymap = require 'joshuatonga.core.keymap'

local nnoremap = keymap.nnoremap

nnoremap('<Space>e', vim.diagnostic.open_float)
nnoremap('[d', vim.diagnostic.goto_prev)
nnoremap(']d', vim.diagnostic.goto_next)
nnoremap('<Space>q', vim.diagnostic.setloclist)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  nnoremap('gD', vim.lsp.buf.declaration, bufopts)
  nnoremap('gd', vim.lsp.buf.definition, bufopts)
  nnoremap('K', vim.lsp.buf.hover, bufopts)
  nnoremap('gi', vim.lsp.buf.implementation, bufopts)
  nnoremap('<C-k>', vim.lsp.buf.signature_help, bufopts)
  nnoremap('<Space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  nnoremap('<Space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  nnoremap('<Space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  nnoremap('<Space>D', vim.lsp.buf.type_definition, bufopts)
  nnoremap('<Space>rn', vim.lsp.buf.rename, bufopts)
  nnoremap('<Space>ca', vim.lsp.buf.code_action, bufopts)
  nnoremap('gr', vim.lsp.buf.references, bufopts)
  nnoremap('<Space>f', vim.lsp.buf.formatting, bufopts)

  require('lsp-format').on_attach(client)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

lsp.sumneko_lua.setup {
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

lsp.pyright.setup {
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
}

lsp.tsserver.setup {
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
}

lsp.terraformls.setup {
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
}
