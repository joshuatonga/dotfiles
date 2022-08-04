vim.cmd [[packadd packer.nvim]]

vim.api.nvim_create_user_command('PS', 'PackerSync', {})
vim.api.nvim_create_user_command('PC', 'PackerClean', {})

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'mhinz/vim-signify'
  use 'tpope/vim-fugitive'
  use 'scrooloose/nerdtree' -- File directory tree plugin
  use 'Xuyuanp/nerdtree-git-plugin'
  use 'scrooloose/nerdcommenter' -- For commenting
  use 'tpope/vim-surround' -- CRUD of surrounding pairs makes easy
  use 'sheerun/vim-polyglot'
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'easymotion/vim-easymotion' -- For easy movement
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
  use { 'nvim-treesitter/nvim-treesitter', run = function() require('nvim-treesitter.install').update({ with_sync = true }) end }

  use 'EdenEast/nightfox.nvim'
end)
