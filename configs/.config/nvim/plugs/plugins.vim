call plug#begin('~/.local/share/nvim/plugged')

if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree' " File directory tree plugin
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdcommenter' " For commenting
Plug 'tpope/vim-surround' " CRUD of surrounding pairs makes easy
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'easymotion/vim-easymotion' " For easy movement 
Plug 'Raimondi/delimitMate' " for auto closing of quotes, braces, etc
Plug 'nathanaelkane/vim-indent-guides'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'terryma/vim-multiple-cursors' " for multi selection, FIXME, replace this with https://github.com/mg979/vim-visual-multi
Plug 'luochen1990/rainbow' " for parentheses colors
Plug 'gregsexton/MatchTag' " for html matching tags
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher' " ctrlp fast matcher base on python
Plug 'edkolev/tmuxline.vim'
Plug 'PieterjanMontens/vim-pipenv'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Colorschemes
Plug 'yasukotelin/shirotelin'
Plug 'fnune/base16-vim'

call plug#end()
