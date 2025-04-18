return {
	-- Text/Movement
	"tpope/vim-surround", -- CRUD of surrounding pairs makes easy
	"ntpeters/vim-better-whitespace",

	-- UI
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl" },
	{
		"norcalli/nvim-colorizer.lua",
		event = "BufReadPost",
		config = function()
			require("colorizer").setup()
		end,
	},
	{ "sindrets/diffview.nvim", dependencies = "nvim-lua/plenary.nvim" },
	{ "tris203/precognition.nvim", event = "VeryLazy", opts = { startVisible = false } },

	-- Tools
	"lambdalisue/suda.vim",

	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	"mhinz/vim-grepper",
	"tpope/vim-dispatch",
	-- "vimwiki/vimwiki",
	"phelipetls/jsonpath.nvim",

	-- LSP
	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",
	"neovim/nvim-lspconfig",
	"folke/neodev.nvim",
	"pearofducks/ansible-vim",
	"fatih/vim-go",
	"towolf/vim-helm",
	"mrcjkb/rustaceanvim",
	"b0o/schemastore.nvim",
	{
		"mattn/emmet-vim",
		init = function()
			vim.g.user_emmet_leader_key = "<C-z>"
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"neovim/nvim-lspconfig",
		},
		opts = {},
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {
			hint_enable = false,
		},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},

	-- Debugging
	"nvim-neotest/nvim-nio", -- TODO: find which plugin is using this and refactor

	-- Themes
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
	},
}
