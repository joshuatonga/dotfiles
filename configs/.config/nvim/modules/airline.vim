set laststatus=2 " for vim airline to appear
let g:airline_powerline_fonts = 1
let g:Powerline_symbols = 'fancy'
let g:airline_theme = 'solarized_flood'

" tabline
let g:airline#extensions#tabline#enabled = 1 " enable airline tabline
let g:airline#extensions#tabline#show_close_button = 0 " remove 'X' at the end of the tabline
let g:airline#extensions#tabline#fnamemod = ':t' " disable file paths in the tab
let g:airline#extensions#tabline#show_buffers = 0 " disable buffer line

" disable fugitive integration because i can't see the file path :<
let g:airline#extensions#branch#enabled = 0
