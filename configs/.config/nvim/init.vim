source $HOME/.config/nvim/plugs/plugins.vim
source $HOME/.config/nvim/modules/coc.vim
source $HOME/.config/nvim/modules/signify.vim
source $HOME/.config/nvim/modules/hexokinase.vim
source $HOME/.config/nvim/modules/airline.vim
source $HOME/.config/nvim/modules/indent-guides.vim
source $HOME/.config/nvim/modules/rainbow.vim
source $HOME/.config/nvim/modules/nerdtree.vim
source $HOME/.config/nvim/modules/ctrlp.vim

" ****************************
" General
" ****************************

filetype plugin indent on

set autoread " set to auto read when a file is changed from the outside

" with a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","
set timeout timeoutlen=1500

set encoding=utf8 " set standard encoding 
set ffs=unix,dos,mac " use unix as the standard file type

" open new split panes to right and bottom which feels more natural than vim's default
set splitbelow
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

autocmd FileType python setlocal ts=4 sw=4 sts=4 expandtab

" put color in column 80
set colorcolumn=120
" folding
set foldmethod=indent
set foldnestmax=10

set clipboard=unnamedplus

" make linenumbers transparent
highlight clear LineNr

" make non text line transparent
highlight NonText ctermbg=None

" make statusline transparent
hi StatusLine ctermbg=NONE cterm=NONE
 
" for marks
set viminfo='100,f1
set shortmess+=A

nnoremap <C-Left> :tabprevious<CR>                                                          
nnoremap <C-Right> :tabnext<CR>

nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>

nnoremap <Leader>sv :source $MYVIMRC<CR>


" ****************************
" Plugins - mapping keys, configs
" ****************************

" Tagbar
nmap <F4> :TagbarToggle<CR>
" tagbar tags for typescript
let g:tagbar_type_typescript = {                                                  
  \ 'ctagsbin' : 'tstags',                                                        
  \ 'ctagsargs' : '-f-',                                                           
  \ 'kinds': [                                                                     
    \ 'e:enums:0:1',                                                               
    \ 'f:function:0:1',                                                            
    \ 't:typealias:0:1',                                                           
    \ 'M:Module:0:1',                                                              
    \ 'I:import:0:1',                                                              
    \ 'i:interface:0:1',                                                           
    \ 'C:class:0:1',                                                               
    \ 'm:method:0:1',                                                              
    \ 'p:property:0:1',                                                            
    \ 'v:variable:0:1',                                                            
    \ 'c:const:0:1',                                                              
  \ ],                                                                            
  \ 'sort' : 0                                                                    
\ }    

" for navigating split navigations or etc
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Themes
set t_Co=256 " 256 colors
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
set background=dark
set nohlsearch
syntax on
"set hlsearch

let base16colorspace=256 " access colors present in 256 colorspace
colorscheme base16-windows-nt " dark red
"colorscheme shirotelin " light mode

let g:user_emmet_install_global = 1
