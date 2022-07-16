syntax on
filetype plugin indent on
autocmd FileType python setlocal ts=4 sw=4 sts=4 expandtab

highlight clear LineNr " make linenumbers transparent
highlight NonText ctermbg=None " make non text line transparent


set nohlsearch
set autoread " set to auto read when a file is changed from the outside
set timeout timeoutlen=200
set encoding=utf8 " set standard encoding
set ffs=unix,dos,mac " use unix as the standard file type
set splitbelow " open new split panes to right and bottom which feels more natural than vim's default
set splitright
set wildmenu " visual autocomplete for command menu
set wildignore=*.o,*~,*.pyc " ignore compiled files
set cursorline " highlight current line
set incsearch " search as characters are entered
set ic " case insensitive
set showmatch " show matching brackets when text indicator is over them
set mat=2 "h ow many tenths of a second to blink when matching brackets
set number " add left side numbes ( line number )
set tabstop=2 " size of a hard tabstop
set shiftwidth=2 " size of an indent
set softtabstop=2 " a combination of spaces and tabs are used to simulate tab stops at a width other than the (hard)tabstop
set smarttab " make tab insert indents instead of tabs at the beginning of a line
set expandtab " always uses spaces instead of tab characters
set ai " auto indent
set si " smart indent
set wrap " wrap lines
set colorcolumn=120
set foldmethod=indent
set foldnestmax=10
set nofoldenable " don't fold when opening a file
set clipboard=unnamedplus
set viminfo='100,f1 " for marks
set shortmess+=A
