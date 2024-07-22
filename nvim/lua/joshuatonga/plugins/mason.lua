return {
	"williamboman/mason.nvim",

	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},

	config = function()
		require("mason").setup()
		require("mason-nvim-dap").setup()

		require("mason-lspconfig").setup({
			ensure_installed = {
				"pyright",
				"terraformls",
				"lua_ls",
				"gopls",
				"tsserver",
				"rust_analyzer",
				"bashls",
				"yamlls",
				"helm_ls",
				"html",
				"emmet_ls",
				"cssls",
				"dockerls",
			},
		})
	end,
}
