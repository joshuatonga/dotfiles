vim.cmd [[packadd packer.nvim]]

vim.api.nvim_create_user_command('PI', 'PackerInstall', {})
vim.api.nvim_create_user_command('PS', 'PackerSync', {})
vim.api.nvim_create_user_command('PC', 'PackerClean', {})

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'lewis6991/gitsigns.nvim'
  use 'tpope/vim-fugitive'
  use 'scrooloose/nerdtree' -- File directory tree plugin
  use 'Xuyuanp/nerdtree-git-plugin'
  -- use 'ryanoasis/vim-devicons'
  use 'tiagofumo/vim-nerdtree-syntax-highlight'
  use 'scrooloose/nerdcommenter' -- For commenting
  use 'tpope/vim-surround' -- CRUD of surrounding pairs makes easy
  use 'phaazon/hop.nvim' -- For easy movement
  use 'lukas-reineke/indent-blankline.nvim'
  use 'mg979/vim-visual-multi'
  use 'norcalli/nvim-colorizer.lua'
  use 'p00f/nvim-ts-rainbow' -- for parenthesis colors
  use 'leafOfTree/vim-matchtag'
  use 'voldikss/vim-floaterm'
  use 'mtth/scratch.vim'
  use 'bronson/vim-trailing-whitespace'
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install' }
  use 'cohama/lexima.vim'
  use 'mhinz/vim-grepper'
  use 'folke/which-key.nvim'
  use 'tpope/vim-dispatch'
  use 'vim-test/vim-test'
  use 'skywind3000/asynctasks.vim'
  use 'skywind3000/asyncrun.vim'
  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-lualine/lualine.nvim'
  use 'joshuatonga/vim-game-snake-god-mode'

  -- LSP
  use { 'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end }
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.0' }
  use 'neovim/nvim-lspconfig';
  use 'lukas-reineke/lsp-format.nvim'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'SirVer/ultisnips'
  use 'quangnguyen30192/cmp-nvim-ultisnips'

  -- Themes
  use 'EdenEast/nightfox.nvim'
  use 'folke/tokyonight.nvim'
  use 'ellisonleao/gruvbox.nvim'
  use 'vimoxide/vim-cinnabar'
  use 'agude/vim-eldar'
end)
