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
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	})
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
	use("quangnguyen30192/cmp-nvim-ultisnips")
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use("ray-x/lsp_signature.nvim")
	use("pearofducks/ansible-vim")

	-- Themes
	use("EdenEast/nightfox.nvim")
	use("folke/tokyonight.nvim")
	use("ellisonleao/gruvbox.nvim")
	use("vimoxide/vim-cinnabar")
	use("agude/vim-eldar")

	-- Games
	use("joshuatonga/vim-game-snake-god-mode")
end)
