" ****************************
" Plugins
" ****************************

call plug#begin('~/.local/share/nvim/plugged')

Plug 'tpope/vim-fugitive'
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif
Plug 'scrooloose/nerdtree' " File directory tree plugin
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdcommenter' " For commenting
Plug 'tpope/vim-surround' " CRUD of surrounding pairs makes easy
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'easymotion/vim-easymotion' " For easy movement 
Plug 'Raimondi/delimitMate' " for auto closing of quotes, braces, etc
Plug 'mattn/emmet-vim' " for emmet
Plug 'nathanaelkane/vim-indent-guides'
Plug 'majutsushi/tagbar' " for summary of code
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

" Colorschemes
Plug 'yasukotelin/shirotelin'
Plug 'fnune/base16-vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Coc extensions
let g:coc_global_extensions = ['coc-tsserver', 'coc-emmet', 'coc-python', 'coc-eslint','coc-css', 'coc-html', 'coc-json', 'coc-yank', 'coc-prettier']

call plug#end()


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

" CtrlP
nmap cp :let @+ = expand("%:p")
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store,*/vendor,*/node_modules/* " ignore this folders when using ctrl p
set wildignore+=*/tmp/*,*.so,*.swp,*.zip " MacOSX/Linux

" NerdTree - open/close nerdtree in normal mode
nmap <C-f> :NERDTreeToggle<CR>
nmap <C-\> :NERDTreeFind<CR>
let g:NERDTreeWinSize=40

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

" Rainbow
let g:rainbow_active=1

" Indent Guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors=0
let g:indent_guides_guide_size = 2 " indent size
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=238
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=236

" Airline 
let g:airline#extension#tabline#enabled=1
let g:airline_powerline_fonts = 1
let g:Powerline_symbols = 'fancy'
let g:airline_theme = 'minimalist'
set laststatus=2 " for vim airline to appear

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

" Coc
set hidden " if hidden is not set, TextEdit might fail.

" some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" better display for messages
set cmdheight=2

" you will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
"inoremap <silent><expr> <TAB>
     "\ pumvisible() ? "\<C-n>" :
     "\ <SID>check_back_space() ? "\<TAB>" :
     "\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
 "let col = col('.') - 1
 "return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
 if (index(['vim','help'], &filetype) >= 0)
   execute 'h '.expand('<cword>')
 else
   call CocAction('doHover')
 endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
 autocmd!
 " Setup formatexpr specified filetype(s).
 autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
 " Update signature help on jump placeholder
 autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Signify
nnoremap <leader>gd :SignifyDiff<cr>
nnoremap <leader>hd :SignifyHunkDiff<cr>
nnoremap <leader>hu :SignifyHunkUndo<cr>
nmap <silent> <cr> <plug>(signify-next-hunk)
nmap <silent> <backspace> <plug>(signify-prev-hunk)

" Hexokinase - colors
let g:Hexokinase_highlighters = [ 'backgroundfull' ]
