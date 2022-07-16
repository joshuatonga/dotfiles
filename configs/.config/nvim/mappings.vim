let mapleader = ","

nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>

" ctrl+s to save current file while in normal mode or insert mode
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>
imap jj <Esc>

" ,sv to reload nvim config
nnoremap <Leader>sv :source $MYVIMRC<CR>

" for navigating split navigations or etc
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
