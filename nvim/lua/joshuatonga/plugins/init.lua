return {
	-- Text/Movement
	"tpope/vim-surround", -- CRUD of surrounding pairs makes easy
	"leafOfTree/vim-matchtag",
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
	{ "tris203/precognition.nvim", event = "VeryLazy", config = true },

	-- Tools
	"lambdalisue/suda.vim",

	"Einenlum/yaml-revealer",
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	"mhinz/vim-grepper",
	"tpope/vim-dispatch",
	"vimwiki/vimwiki",
	"phelipetls/jsonpath.nvim",

	-- LSP
	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",
	"neovim/nvim-lspconfig",
	"folke/neodev.nvim",
	"pearofducks/ansible-vim",
	"jose-elias-alvarez/typescript.nvim",
	"fatih/vim-go",
	"mrcjkb/rustaceanvim",
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
	{ "vimoxide/vim-cinnabar", lazy = true },
	{ "agude/vim-eldar", lazy = true },
	{ "ellisonleao/gruvbox.nvim", lazy = true },
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 1000,
	},
}
