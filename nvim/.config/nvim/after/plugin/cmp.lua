local cmp = require 'cmp'

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

local kind_icons = {
  Text = ' text',
  Method = ' method',
  Function = ' function',
  Constructor = ' constructor',
  Field = ' field',
  Variable = ' variable',
  Class = 'ﴯ class',
  Interface = ' interface',
  Module = ' module',
  Property = 'ﰠ property',
  Unit = ' unit',
  Value = ' value',
  Enum = ' enum',
  Keyword = ' keyword',
  Snippet = ' snippet',
  Color = ' color',
  File = ' file',
  Reference = ' reference',
  Folder = ' folder',
  EnumMember = ' enum',
  Constant = ' constant',
  Struct = ' struct',
  Event = ' event',
  Operator = ' operator',
  TypeParameter = ' typeparam'
}

cmp.setup({
  -- completion = {
  --   autocomplete = false, -- Manual trigger completion with <C-space>
  -- },
  performance = {
    debounce = 500,
  },
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = kind_icons[vim_item.kind]
      -- Source
      vim_item.menu = ({
        buffer = '[Buffer]',
        nvim_lsp = '[LSP]',
        ultisnips = '[UltiSnips]',
        nvim_lua = '[Lua]',
      })[entry.source.name]
      return vim_item
    end
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'path' },
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' },
    { name = 'conventionalcommits' },
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'nvim_lsp_document_symbol' },
    { name = 'buffer', max_item_count = 10 },
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
