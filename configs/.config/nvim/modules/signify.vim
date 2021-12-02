nnoremap <leader>gd :SignifyDiff<cr>
nnoremap <leader>hd :SignifyHunkDiff<cr>
nnoremap <leader>hu :SignifyHunkUndo<cr>
nmap <silent> <cr> <plug>(signify-next-hunk)
nmap <silent> <backspace> <plug>(signify-prev-hunk)
