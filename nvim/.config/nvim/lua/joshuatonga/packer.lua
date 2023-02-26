vim.cmd([[packadd packer.nvim]])

vim.api.nvim_create_user_command("PI", "PackerInstall", {})
vim.api.nvim_create_user_command("PS", "PackerSync", {})
vim.api.nvim_create_user_command("PC", "PackerClean", {})

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- Text/Movement
	use("tpope/vim-surround") -- CRUD of surrounding pairs makes easy
	use("phaazon/hop.nvim") -- For easy movement
	use("mg979/vim-visual-multi")
	use("p00f/nvim-ts-rainbow") -- for parenthesis colors
	use("leafOfTree/vim-matchtag")
	use("ntpeters/vim-better-whitespace")
	use("cohama/lexima.vim")
	use("scrooloose/nerdcommenter") -- For commenting

	-- UI
	use("nvim-lualine/lualine.nvim")
	use("lewis6991/gitsigns.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use("norcalli/nvim-colorizer.lua")
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	})
	use("nvim-treesitter/nvim-treesitter-context")
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	})
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })
	use("danilamihailov/beacon.nvim")

	-- Tools
	use("lambdalisue/suda.vim")
	use("folke/which-key.nvim")
	use("Einenlum/yaml-revealer")
	use("tpope/vim-fugitive")
	use("voldikss/vim-floaterm")
	use("mtth/scratch.vim")
	use({ "iamcco/markdown-preview.nvim", run = "cd app && yarn install" })
	use("mhinz/vim-grepper")
	use("tpope/vim-dispatch")
	use("vim-test/vim-test")
	use("skywind3000/asynctasks.vim")
	use("skywind3000/asyncrun.vim")
	use("vimwiki/vimwiki")
	use("phelipetls/jsonpath.nvim")

	-- LSP
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "nvim-telescope/telescope.nvim", tag = "0.1.0" })
	use("neovim/nvim-lspconfig")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-nvim-lsp-document-symbol")
	use("davidsierradz/cmp-conventionalcommits")
	use("hrsh7th/nvim-cmp")
	use("SirVer/ultisnips")
	use("honza/vim-snippets")
	use("folke/neodev.nvim")
	use("quangnguyen30192/cmp-nvim-ultisnips")
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use("ray-x/lsp_signature.nvim")
	use("pearofducks/ansible-vim")
	use("jose-elias-alvarez/typescript.nvim")

	-- Debugging
	use("mfussenegger/nvim-dap")
	use("jay-babu/mason-nvim-dap.nvim")
	use("theHamsta/nvim-dap-virtual-text")
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	use({ "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } })
	use({
		"microsoft/vscode-js-debug",
		opt = true,
		run = "npm install --legacy-peer-deps && npm run compile",
		tag = "v1.74.1",
	})

	-- Themes
	use("EdenEast/nightfox.nvim")
	use("folke/tokyonight.nvim")
	use("ellisonleao/gruvbox.nvim")
	use("vimoxide/vim-cinnabar")
	use("agude/vim-eldar")
	use({ "projekt0n/github-nvim-theme", tag = "v0.0.7" })

	-- Games
	use("joshuatonga/vim-game-snake-god-mode")
end)
