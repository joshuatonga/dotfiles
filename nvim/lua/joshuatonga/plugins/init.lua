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
	{
		"mhinz/vim-grepper",
		keys = {
			{ "<leader>gr", ":Grepper -tool git<CR>", desc = "Grepper git grep" },
			{ "<leader>gR", ":Grepper -tool rg<CR>", desc = "Grepper ripgrep" },
			{ "<leader>gw", "<plug>(GrepperOperator)", mode = { "n", "x" }, desc = "Grepper operator" },
		},
	},
	"tpope/vim-dispatch",
	-- "vimwiki/vimwiki",
	"phelipetls/jsonpath.nvim",
	{
		"cuducos/yaml.nvim",
		ft = { "yaml" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"folke/snacks.nvim",
		},
		config = function()
			vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved" }, {
				pattern = { "*.yaml" },
				callback = function()
					vim.opt_local.winbar = require("yaml_nvim").get_yaml_key()
				end,
			})
		end,
	},

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
			vim.g.user_emmet_leader_key = "<C-e>"
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
