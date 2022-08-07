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
  use 'scrooloose/nerdcommenter' -- For commenting
  use 'tpope/vim-surround' -- CRUD of surrounding pairs makes easy
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'phaazon/hop.nvim' -- For easy movement
  use 'Raimondi/delimitMate' -- for auto closing of quotes, braces, etc
  use 'lukas-reineke/indent-blankline.nvim'
  use 'terryma/vim-multiple-cursors' -- for multi selection, FIXME, replace this with https://github.com/mg979/vim-visual-multi
  use 'norcalli/nvim-colorizer.lua'
  use 'p00f/nvim-ts-rainbow' -- for parenthesis colors
  use 'gregsexton/MatchTag' -- for html matching tags
  use 'PieterjanMontens/vim-pipenv'
  use 'voldikss/vim-floaterm'
  use 'mtth/scratch.vim'
  use 'bronson/vim-trailing-whitespace'
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install' }
  use 'honza/vim-snippets'
  use 'mhinz/vim-grepper'
  use 'folke/which-key.nvim'

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
end)
