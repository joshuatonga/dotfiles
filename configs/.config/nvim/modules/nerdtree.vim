nmap <C-e> :NERDTreeToggle<CR>
nmap <leader>ns :NERDTreeFind<CR>
nmap <leader>nf :NERDTreeFocus<CR>

let g:NERDTreeWinSize=40
let g:NERDTreeGitStatusUseNerdFonts = 1 " you should install nerdfonts by yourself. default: 0
let NERDTreeQuitOnOpen=1 " close nerdtree on open of a file
let NERDTreeShowHidden=1 " show hidden files by default
let NERDTreeShowLineNumbers=1

autocmd FileType nerdtree setlocal relativenumber
