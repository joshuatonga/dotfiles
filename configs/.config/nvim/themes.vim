set t_Co=256 " 256 colors
set background=dark

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

"let base16colorspace=256 " access colors present in 256 colorspace
"colorscheme base16-windows-nt " dark red
"let g:rehash256 = 1
"colorscheme molokai " dark red
"colorscheme shirotelin " light mode
let g:neosolarized_termtrans=1
colorscheme NeoSolarized
"colorscheme Carbon
"let g:tokyonight_style = 'night'
"colorscheme tokyonight
"colorscheme terafox
