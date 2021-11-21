call plug#begin('~/.local/share/nvim/plugged')
Plug 'tpope/vim-fugitive' "Plug for git
Plug 'mileszs/ack.vim'
Plug 'tpope/vim-markdown'
"Plug 'airblade/vim-gitgutter'
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif
"Plug 'powerline/powerline'
"Plug 'MattesGroeger/vim-bookmarks'
Plug 'scrooloose/nerdtree' " File directory tree plugin
Plug 'tpope/vim-surround' " CRUD of surrounding pairs makes easy
Plug 'sheerun/vim-polyglot'
"Plug 'w0rp/ale'
Plug 'skywind3000/asyncrun.vim'
Plug 'jparise/vim-graphql'
Plug 'majutsushi/tagbar'
"Plug 'bling/vim-airline' " Lean and mean status/tabline for vim
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdcommenter' " For commenting
Plug 'easymotion/vim-easymotion' " For easy movement 
"Plug 'Raimondi/delimitMate' " for auto closing of quotes, braces, etc
Plug 'mtth/scratch.vim'
Plug 'posva/vim-vue'
Plug 'mattn/emmet-vim' " for emmet
Plug 'nathanaelkane/vim-indent-guides'
"Plug 'c.vim'
Plug 'zig-lang/zig.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'hashivim/vim-terraform'
Plug 'sainnhe/sonokai'
"Plug 'MarcWeber/vim-addon-mw-utils' " pluginns for snipmate
"Plug 'tomtom/tlib_vim' " pluginns for snipmate
"Plug 'garbas/vim-snipmate' " pluginns for snipmate
"Plug 'honza/vim-snippets' " pluginns for snipmate
"Plug 'Yggdroot/indentLine' " for indentation guide
"Plug 'davidhalter/jedi-vim' " Auto complete python
"Plug 'othree/javascript-libraries-syntax.vim'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'majutsushi/tagbar' " for summary of code
Plug 'ap/vim-css-color' " show colors in css
Plug 'terryma/vim-multiple-cursors' " for multi selection
Plug 'luochen1990/rainbow' " for parentheses colors
"Plug 'HTML-AutoCloseTag' " Auto close tag for html
Plug 'othree/html5.vim' " for html5
Plug 'whatyouhide/vim-gotham'
Plug 'isruslan/vim-es6'
Plug 'gregsexton/MatchTag' " for html matching tags
Plug 'fatih/vim-go'
Plug 'AndrewRadev/splitjoin.vim'
"Plug 'mxw/vim-jsx' " for reactjs syntax highlightning
Plug 'chemzqm/vim-jsx-improve'
"Plug 'TaskList.vim' " Todo list
"Plug 'ervandew/supertab'
"Plug 'klen/python-mode' " python completion
"Plug 'Shougo/neosnippet'
"Plug 'Shougo/neosnippet-snippets' " snippets for neocomplete
"Plug 'nvie/vim-flake8' " pyython stnax checker
"Plug 'SirVer/ultisnips' " For snippets creating
Plug 'hail2u/vim-css3-syntax' " for css
Plug 'briancollins/vim-jst'
Plug 'groenewege/vim-less'
"Plug 'andviro/flake8-vim' " for python syntax checker 
"Plug 'Valloric/YouCompleteMe' " auto completion
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ctrlpvim/ctrlp.vim' " buffer
Plug 'FelikZ/ctrlp-py-matcher' " ctrlp fast matcher base on python
"Plug 'mxw/vim-jsx' " for react jsx syntax highlighting and indentation of it
Plug 'ekalinin/dockerfile.vim' " Dockerfile syntax
Plug 'kchmck/vim-coffee-script' " Coffeescript syntax
Plug 'digitaltoad/vim-jade' " Jade syntax
Plug 'mustache/vim-mustache-handlebars' " Syntax

"Plug 'altercation/vim-colors-solarized' " Vim colorscheme
Plug 'sainnhe/edge'
Plug 'zefei/cake16'
Plug 'ajgrf/parchment'
Plug 'flazz/vim-colorschemes'
Plug 'morhetz/gruvbox'
Plug 'matveyt/vim-modest'
Plug 'arzg/vim-corvine'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'rakr/vim-two-firewatch'
Plug 'sjl/badwolf'
Plug 'edkolev/tmuxline.vim'
Plug 'plytophogy/vim-virtualenv'
Plug 'PieterjanMontens/vim-pipenv'
Plug 'ayu-theme/ayu-vim'
Plug 'cocopon/iceberg.vim'
Plug 'yasukotelin/shirotelin'

" Track the engine.
"Plug 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'
Plug 'fatih/molokai'
"Plug 'sainnhe/edge'

"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'Shougo/deoplete.nvim'
"Plug 'deoplete-plugins/deoplete-go', {'build': {'unix': 'make'}}
"
Plug 'tpope/vim-dadbod'

" Tfalseypescript setup
Plug 'herringtondarkholme/yats.vim'
"Plug 'mhartington/nvim-typescript', { 'do': './install.sh' }
"Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" coc extensions
"let g:coc_global_extensions = ['coc-tsserver', 'coc-emmet', 'coc-python', 'coc-eslint','coc-css', 'coc-html', 'coc-json', 'coc-yank', 'coc-prettier']
let g:coc_global_extensions = ['coc-tsserver', 'coc-emmet', 'coc-python', 'coc-eslint','coc-css', 'coc-html', 'coc-json', 'coc-yank', 'coc-prettier']


Plug 'ianks/vim-tsx'

"Plug 'Valloric/YouCompleteMe', {  
     "\ 'build'      : {
        "\ 'mac'     : './install.sh --clang-completer --system-libclang --omnisharp-completer',
        "\ 'unix'    : './install.sh --clang-completer --system-libclang --omnisharp-completer',
        "\ 'windows' : './install.sh --clang-completer --system-libclang --omnisharp-completer',
        "\ 'cygwin'  : './install.sh --clang-completer --system-libclang --omnisharp-completer'
        "\ }
     "\ }

call plug#end()
"let &runtimepath.=',~/.vim/bundle/ale'
"let &runtimepath.='~/.vim/bundle/ale'

filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
"PlugCheck  
"End Plug Scripts-------------------------
filetype plugin indent on    " required
""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger = "<tab>"
"let g:UltiSnipsJumpForwardTrigger = "<c-j>"
"let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
"let g:UltiSnipsSnippetsDir = $HOME."/UltiSnips"
"let g:UltiSnipsSnippetsDir = $HOME."/.config/UltiSnips"
"let g:UltiSnipsSnippetDirectories = ['UltiSnips', $HOME.'/.config/UltiSnips']
"let g:UltiSnipsEnableSnipMate = 0
"let g:UltiSnipsListSnippets = "<c-l>"

" If you want :UltiSnipsEdit to split your window.
"let g:UltiSnipsEditSplit="vertical"


" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","
set timeout timeoutlen=1500

" set standard encoding 
set encoding=utf8

" use unix as the standard file type
set ffs=unix,dos,mac


" open new split panes to right and bottom which feels more natural than vim's
" default
set splitbelow
set splitright

" >> VIM USER INTEFACE

" visual autocomplete for command menu
set wildmenu

" ignore compiled files
set wildignore=*.o,*~,*.pyc

" highlight current line
set cursorline

" search as characters are entered
set incsearch
set ic " case insensitive

" highlight search results

" show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2
" >> PLUGINS 
" mappings of keys

nmap cp :let @+ = expand("%:p")

" open/close nerdtree in normal mode
nmap <F3> :NERDTreeToggle<CR>
let g:NERDTreeWinSize=60

" For navigating split navigations or etc
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" auto check file for errors on write
"autocmd BufWritePost *.py call Flake8()
"let g:PyFlakeOnWrite=1
"" List of checker used
"let g:PyFlakeCheckers='pep8,mccabe,frosted'
"
"let g:PyFlakeDisabledMessages='E127'
"let g:PyFlakeDisabledMessages='E128'
"let g:PyFlakeDisabledMessages='E501'
"let g:PyFlakeDisabledMessages='E502'
" start multi cursor mode
"let g:muilti_cursor_start_key='<C-o>'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
"set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

"Rainbow parentheses
let g:rainbow_active=1

"for indentguides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors=0


let g:scratch_persistence_file = '/tmp/scratch.vim'

let g:indent_guides_guide_size = 2 " indent size
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=238
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=236
"airline 
let g:airline#extension#tabline#enabled=1
let g:airline_powerline_fonts = 1
let g:Powerline_symbols = 'fancy'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_theme = 'deus'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
"let g:airline_right_sep = '«'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
" For vim airline to appear
set laststatus=2

"settings for supertab
let g:SuperTabDefaultCompletionType = "<C-X><C-O"
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabClosePreviewOnPopupClose = 1
"autcmd CompleteDone * pclose

" For react jsx syntax highlightning
let g:jsx_ext_required = 0

" for omnicomplete
"autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete


" >> OTHER
" Add left side numbes ( line number )
set number
" vim tabs spaces = 4
" size of a hard tabstop
set tabstop=2
"  size of an indent
set shiftwidth=2
" a combination of spaces and tabs are used to simulate tab stops at a width
" other than the (hard)tabstop
set softtabstop=2
" make tab insert indents instead of tabs at the beginning of a line
set smarttab
"  always uses spaces instead of tab characters
set expandtab


autocmd FileType python setlocal ts=4 sw=4 sts=4 expandtab

"Auto indent
set ai
"Smart indent
set si
" wrap lines
set wrap


" Enable colorscheme
" 256 colors
set t_Co=256
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
set background=dark
set nohlsearch
"syntax on
"set hlsearch
let g:gruvbox_italic=1
"set term=screen-256color
"colorscheme edge
"colorscheme modest
"let ayucolor="light"  " for light version of theme
"let ayucolor="mirage" " for mirage version of theme
"let ayucolor="dark"   " for dark version of theme
" dark mode
colorscheme ayu
" light mode
"colorscheme shirotelin
"colorscheme parchment
"colorscheme cake16

if has("gui_running")
 "" Solarized http://ethanschoonover.com/solarized/vim-colors-solarized
 "" let g:solarized_termcolors=16
 "syntax on
 ""set background=dark
 "set go=c
 ""let g:edge_disable_italic_comment = 1
  "colorscheme edge
  "set background=light
  "colorscheme modest
  "colorscheme corvine_light
  "colorscheme parchment
endif

"set background=dark
"syntax on
"let g:solarized_termcolors=256 " use 256 color
"

" Put color in column 80
set colorcolumn=120


" Folding
set foldmethod=indent
set foldnestmax=10
"set nofoldenable
"set foldlevel=2
"



" Ignore this folders when using ctrl p
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store,*/vendor,*/node_modules/*


" ctrl + x ctrl + k
"set dictionary+=/usr/share/dict/american-english



" Templates / Code snippets
"function PythonFor()
   "":read ~/.vim/templates/python-for.py
"endfunction



"let g:jsx_ext_required = 0 " Allow JSX in normal JS files
"

" For ultisnips
" Trigger configuration. Do not use <tab> if you use
"https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
"let g:UltiSnipsEditSplit="vertical"




"function! PlaySound()
 "":DoQuietly play ~/.vim/typewriter-key-1.aiff
"endfunction
"autocmd CursorMovedI * call PlaySound()

set clipboard=unnamedplus

set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/

" Always show statusline
set laststatus=2

" Make linenumbers transparent
highlight clear LineNr

" Make non text line transparent
highlight NonText ctermbg=None

" Make statusline transparent
hi StatusLine ctermbg=NONE cterm=NONE

"let g:used_javascript_libs = 'vue,chai,react,underscore'

"let g:ale_python_pylint_change_directory=0
"let g:ale_python_flake8_change_directory=0
"let g:ale_python_auto_pipenv=1

"let g:ale_lint_on_save = 1
"let g:ale_lint_on_text_changed = 0
"let g:ale_linters = {
"\   'javascript': ['eslint'],
"\   'typescript': ['tsserver', 'tslint'],
"\   'go': ['gometalinter', 'gofmt'],
"\}
"let g:ale_fixers = {
"\    'javascript': ['eslint'],
"\    'typescript': ['prettier'],
"\    'vue': ['eslint'],
"\    'scss': ['prettier'],
"\    'html': ['prettier']
"\}

"let g:ale_sign_error = '⤫' " Less aggressive than the default '>>'
"let g:ale_sign_warning = '⚠'
"let g:ale_lint_on_enter = 0 " Less distracting when opening a new file
"let g:ale_fix_on_save = 1

" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
"autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
"autocmd FileChangedShellPost *
 ""\ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
autocmd BufWritePost *.js AsyncRun -post=checktime ./node_modules/.bin/eslint --fix %


let g:user_emmet_install_global = 1

"And use ctrl+] when the cursor is positioned in a symbol to quickly jump to a definition or declaration.
"au FileType c,cpp nnoremap <buffer> <c-]> :YcmCompleter GoTo<CR>
"let g:ycm_global_ycm_extra_conf = '~/.config/nvim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
"
"
"
command! Picon exe 'normal m`' | silent! undojoin | exe '%!picon -a' | exe 'normal ``'


"autocmd Filetype python autocmd BufWritePre <buffer> Picon
"autocmd Filetype python autocmd CursorHold <buffer> Picon


map <F12> :%!picon -a<CR>


"nmap <F8> :TagbarToggle<CR>

"for marks
set viminfo='100,f1


set shortmess+=A


nnoremap <C-Left> :tabprevious<CR>                                                          
nnoremap <C-Right> :tabnext<CR>


"********************************************************************************
" Go stuff.
" Ref: https://github.com/fatih/vim-go-tutorial#documentation-lookup

" Keys
" K - Get documentation under cursor

" Auto import
let g:go_fmt_command = "goimports"

let g:go_auto_type_info = 1

set updatetime=700
let g:go_auto_sameids = 1

" Colors
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1

" Change from go to definition from guru to godef
let g:go_def_mode = 'godef'

" Only show quickfix list not location list
let g:go_list_type = "quickfix"

" Go to defintion
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)

" Go doc
au FileType go nmap <Leader>i <Plug>(go-info)

" Show all function declrations
au FileType go nmap <leader>gt :GoDeclsDir<cr>


" For switching between the unit tests and the implementation
au Filetype go nmap <leader>ga <Plug>(go-alternate-edit)
au Filetype go nmap <leader>gah <Plug>(go-alternate-split)
au Filetype go nmap <leader>gav <Plug>(go-alternate-vertical)
au FileType go nmap <F10> :GoTest<cr>
au FileType go nmap <F9> :GoCoverageToggle<cr>

" For building and running
autocmd FileType go nmap <leader>i  <Plug>(go-install)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
 "let l:file = expand('%')
 "if l:file =~# '^\f\+_test\.go$'
   "call go#test#Test(0, 1)
 "elseif l:file =~# '^\f\+\.go$'
   "call go#cmd#Build(0)
 "endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

" Run tests
autocmd FileType go nmap <leader>t  <Plug>(go-test)

" Run test converage
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

" Openning an alternatate file
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')



" Quick fix go to
"map <C-n> :cnext<CR>
"map <C-m> :cprevious<CR>
"nnoremap <leader>a :cclose<CR>

" TODO: Integrate delve and vim-delve for debugging go 
" TODO: Fix GoCalles vim-go is not a valid GOPATH
"   https://github.com/fatih/vim-go/issues/472

"********************************************************************************


"********************************************************************************
" Auto completion using deoplete
let g:deoplete#enable_at_startup = 1

" Disable deoplete when in multi cursor mode
function! Multiple_cursors_before()
   "let b:deoplete_disable_auto_complete = 1
endfunction

function! Multiple_cursors_after()
   "let b:deoplete_disable_auto_complete = 0
endfunction
"********************************************************************************


"set autowrite
"
"set shell='/bin/sh'
"let g:go_autodetect_gopath = 0
"
"


" Scratch pad
let g:scratch_no_mappings = 1

nmap gq <plug>(scratch-insert-reuse)
nmap gQ <plug>(scratch-insert-clear)
xmap gq <plug>(scratch-selection-reuse)
xmap gQ <plug>(scratch-selection-clear)



" OPen current file in a gvim window. 
nmap <silent> <leader>w :exec 'silent !gvim % &'



" coc
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
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


" for tagbar
nmap <F4> :TagbarToggle<CR>

" Tagbar tags for typescript
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

" dadbod db query


"xnoremap <expr> <Plug>(DBExe)     db#op_exec()
"nnoremap <expr> <Plug>(DBExe)     db#op_exec()
"nnoremap <expr> <Plug>(DBExeLine) db#op_exec() . '_'

"xmap <leader>db  <Plug>(DBExe)
"nmap <leader>db  <Plug>(DBExe)
"omap <leader>db  <Plug>(DBExe)
"nmap <leader>dbb <Plug>(DBExeLine)
"" operator mapping
"func! DBExe(...)
	"if !a:0
		"let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
		"return 'g@'
	"endif
	"let sel_save = &selection
	"let &selection = "inclusive"
	"let reg_save = @@

	"if a:1 == 'char'	" Invoked from Visual mode, use gv command.
		"silent exe 'normal! gvy'
	"elseif a:1 == 'line'
		"silent exe "normal! '[V']y"
	"else
		"silent exe 'normal! `[v`]y'
	"endif

	"execute "DB " . @@

	"let &selection = sel_save
	"let @@ = reg_save
"endfunc

"xnoremap <expr> <Plug>(DBExe)     DBExe()
"nnoremap <expr> <Plug>(DBExe)     DBExe()
"nnoremap <expr> <Plug>(DBExeLine) DBExe() . '_'

"xmap <leader>db  <Plug>(DBExe)
"nmap <leader>db  <Plug>(DBExe)
"omap <leader>db  <Plug>(DBExe)
"nmap <leader>dbb <Plug>(DBExeLine)
"" specific region for dadbod
"nmap <expr> <C-Q> db#op_exec()
"xmap <expr> <C-Q> db#op_exec()


"call add(g:dadbods, db)

" if g:db and b:db is set up -- b:db will be used.
" so g:db would serve as a default database (first in the list)
"let g:db = g:dadbods[0].url


"command! DBSelect :call popup_menu(map(copy(g:dadbods), {k,v -> v.name}), {
      "\"callback": 'DBSelected'
      "\})

"func! DBSelected(id, result)
  "if a:result != -1
    "let b:db = g:dadbods[a:result-1].url
    "echomsg 'DB ' . g:dadbods[a:result-1].name . ' is selected.'
  "endif
"endfunc

"let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git|dist'
"let g:ctrlp_custom_ignore = '\v[\/]\.(DS_Storegit|hg|svn|optimized|compiled|node_modules|dist)$'
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif


"nnoremap <silent> <cr> :GitGutterNextHunk<cr>
"nnoremap <silent> <backspace> :GitGutterPrevHunk<cr>

" Faster sign updates on CursorHold/CursorHoldI
set updatetime=100

nnoremap <leader>gd :SignifyDiff<cr>
nnoremap <leader>hd :SignifyHunkDiff<cr>
nnoremap <leader>hu :SignifyHunkUndo<cr>

" hunk jumping
nmap <silent> <cr> <plug>(signify-next-hunk)
nmap <silent> <backspace> <plug>(signify-prev-hunk)

" hunk text object
"omap ic <plug>(signify-motion-inner-pending)
"xmap ic <plug>(signify-motion-inner-visual)
"omap ac <plug>(signify-motion-outer-pending)
"xmap ac <plug>(signify-motion-outer-visual)

nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>
