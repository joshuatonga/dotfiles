require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = { "pyright", "terraformls", "lua_ls", "gopls", "tsserver", "rust_analyzer" },
})
