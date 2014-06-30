"
" gvim/macvim settings
"

set columns=100
set lines=40

"set clipboard=unnamed  " better integration with system clipboard

set antialias

set guioptions-=L   " hide scroll bars
set guioptions-=r   " "
set guioptions-=b   " "
set guioptions-=T   " hide toolbar
set guioptions-=m   " hide menu
set guioptions-=t   " no tearof menu entries in Win32

set antialias linespace=2

" GUI Powerline settings {{{

"set guifont=Menlo\ Regular\ for\ Powerline:h14
set guifont=Inconsolata-dz\ for\ Powerline:h14
let g:Powerline_symbols = 'fancy'

" }}}

" open in full screen mode!
set fuoptions=maxvert,maxhorz
au GUIEnter * set fullscreen

autocmd VimLeave * macaction hide:

" vim:foldenable:fdm=marker
