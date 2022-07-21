" For list of commands see: https://github.com/junegunn/fzf.vim#commands
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <Leader>fs :Ag<CR>
nnoremap <silent> <Leader>fa :Agh<CR>
nnoremap <silent> <Leader>fb :Buffers<CR>
" view recent files
nnoremap <silent> <Leader>fh :History<CR>
" view files from git status
nnoremap <silent> <Leader>fg :GFiles?<CR>
nnoremap <silent> <Leader>fc :Commits<CR>
" view commits for the current buffer
nnoremap <silent> <Leader>fv :BCommits<CR>

" ctrl-_ to toggle preview window
let g:fzf_preview_window = ['right:60%', 'ctrl-_']
let s:AG_OPTIONS = "--path-to-ignore ~/.ignore"
let s:PREVIEW_OPTIONS = {'options': '--delimiter : --nth 4..'}
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, s:AG_OPTIONS, fzf#vim#with_preview(s:PREVIEW_OPTIONS), <bang>0)
command! -bang -nargs=* Agh call fzf#vim#ag(<q-args>, s:AG_OPTIONS . ' --hidden', fzf#vim#with_preview(s:PREVIEW_OPTIONS), <bang>0)
