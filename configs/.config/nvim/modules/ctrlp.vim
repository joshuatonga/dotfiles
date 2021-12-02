nmap cp :let @+ = expand("%:p")
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store,*/vendor,*/node_modules/* " ignore this folders when using ctrl p
set wildignore+=*/tmp/*,*.so,*.swp,*.zip " MacOSX/Linux
