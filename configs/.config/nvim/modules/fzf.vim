nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <Leader>f :Ag<CR>

" ctrl-_ to toggle preview window
let g:fzf_preview_window = ['right:60%', 'ctrl-_']
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--path-to-ignore ~/.ignore', fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=* Agh call fzf#vim#ag(<q-args>, '--path-to-ignore ~/.ignore --hidden', fzf#vim#with_preview(), <bang>0)
