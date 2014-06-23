"
" vim settings
"

" general settings {{{

set nocompatible " be Vim not vi
let mapleader=","

set cmdheight=2

" }}}

" vundle settings {{{

filetype off  " just for vundle; it'll be turned on later
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()
"runtime bundle/vim-pathogen/autoload/pathogen.vim
"call pathogen#infect()

Bundle "gmarik/vundle"
Bundle "bling/vim-airline"
Bundle "tpope/vim-fugitive"
Bundle "vim-scripts/Gundo"
Bundle "vim-scripts/zoom.vim"
Bundle "altercation/vim-colors-solarized"
Bundle "jmcantrell/vim-virtualenv"
Bundle "tpope/vim-surround"
Bundle "kien/ctrlp.vim"
Bundle "majutsushi/tagbar"
Bundle "scrooloose/syntastic.git"
Bundle "airblade/vim-gitgutter"
Bundle "tmhedberg/SimpylFold"
Bundle "joequery/Stupid-EasyMotion"
Bundle "Raimondi/delimitMate"
Bundle "Valloric/YouCompleteMe"
Bundle "vim-scripts/TaskList.vim"

" colors
Bundle "endel/vim-github-colorscheme"
Bundle "nanotech/jellybeans.vim"

" snippets
Bundle 'SirVer/ultisnips'
Bundle 'honza/vim-snippets'

" makegreen
Bundle "pydave/AsyncCommand"
Bundle "jimf/vim-red-green"
Bundle "jimf/vim-async-make-green"

call vundle#end()

" }}}

" basic editing setup {{{

set history=100

" Enable file type detection.
filetype on
filetype plugin on
filetype indent on

" whitespace
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set smartindent

" line numbering
set number
set numberwidth=3

set ruler

set showmatch

autocmd FileType text setlocal textwidth=78

" minimum lines above and below cursor position
set scrolloff=3

" stop storing swap/backup files
set noswapfile
set nobackup

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
            \ | wincmd p | diffthis
endif

" filter paths from glob operations (and Command-T)
set wildignore+=*.o,*.obj,.git,.hg,.svn,*.pyc,*.pyo

set wildmode=longest,list
set wildmenu " make tab completion for files/buffers act like bash

set list listchars=tab:»·,trail:·
"set list listchars=tab:»·,trail:·,eol:¶

"}}}

" color settings {{{

syntax enable

set t_Co=256
"colorscheme solarized
colorscheme github

" }}}

" search settings {{{

set incsearch
set hlsearch
" make searches are case-sensitive only when searching for an
" uppercase character
set ignorecase smartcase

" clear search highlights when hitting return
noremap <cr> :nohls<cr>/<bs>

" }}}

" fold settings {{{

" automatically save/load folds
au BufWinLeave ?+ mkview
au BufWinEnter ?+ silent loadview

"}}}

" statusline settings {{{

set laststatus=2 " always show status line

set statusline=
set statusline=[%n][%<%f]%h%m%r
set statusline+=%#String#
set statusline+=%{fugitive#statusline()}
if &filetype == 'python'
    set statusline+=%{python#statusline()}
endif
set statusline+=%*
set statusline+=%=    " everything after this is right justified
set statusline+=%#StatusLineNC#%y[%{&ff}:%{&fenc}]%*
set statusline+=\ %-8.(%l,%c%V%)\ %P
set statusline+=%#warningmsg#%{SyntasticStatuslineFlag()}%*

" }}}

" buffer settings {{{

" allow unsaved backgrounding buffers and remember their marks/undo
set hidden

" save a changed buffer when it becomes hidden
set autowrite

"}}}

" supertab settings {{{

"let g:SuperTabDefaultCompletionType = "context"
"let g:SuperTabContextTextOmniPrecedence = ["&omnifunc", "&completefunc"]
"let g:SuperTabLongestHighlight = 1
"let g:SuperTabClosePreviewOnPopupClose = 1
"let g:SuperTabCrMapping = 0

" }}}

" syntastic settings {{{

let g:syntastic_auto_jump = 0
let g:syntastic_check_on_open = 1
let g:syntastic_enable_signs = 0
let g:syntastic_auto_loc_list = 1
let g:syntastic_stl_format = '[%E{%e error(s)}%B{, }%W{%w warning(s)}]'

" }}}

" tagbar settings {{{

" focus when tag window opens
let g:tagbar_autofucus = 1

" close when selecting a tag
let g:tagbar_autoclose = 1

" remove instructions
let g:tagbar_compact = 1

" unfold just enought to show the current tag
let g:tagbar_autoshowtag = 1

" }}}

" makegreen settings {{{


" }}}

" key mappings {{{

" as a time saver allow ; to be used as : for vim commands
nnoremap ; :

" turn off search highlighting
nmap <silent> <c-n> :silent noh<cr>

" faster saving
nmap <leader>w :w!<cr>

" toggle line numbering
nnoremap <leader>n :set nonumber!<cr>

" show the tasklist if there are tasks (press q to close it)
map <leader>L <plug>TaskList

" toggle the Gundo panel
nnoremap <leader>U :GundoToggle<cr>

" toggle the Tagbar panel
nnoremap <leader>l :TagbarToggle<cr>

" create a map for MakeGreen so it won't automatically bind to <leader>t
nnoremap <unique> <silent> <leader>m :call MakeGreen()<cr>

" faster buffer use
"nnoremap <leader>b :buffers<cr>:buffer<space>

" goto file in a vertical split
nnoremap <c-w>gv :vertical wincmd f<cr>
nnoremap <c-w>gV :vertical wincmd F<cr>
set splitright

" write current word as uppercase or lowercase
inoremap <c-u> <esc>lviwUea
inoremap <c-l> <esc>lviwuea

" a faster escape
inoremap jj <esc>

" kill highlights
nnoremap <leader><space> :noh<cr>

    " faster splits {{{

    map <C-j> <c-w>j
    map <c-k> <c-w>k
    map <c-l> <c-w>l
    map <c-h> <c-w>h

    " }}}

    " ins-completion mappings became CTRL on a Mac sucks {{{

    " keywords in the current file
    inoremap <c-space>n <c-x><c-n>

    " tags
    inoremap <c-space>] <c-x><c-]>

    " filenames
    inoremap <c-space>f <c-x><c-f>

    " omni
    inoremap <c-space>o <c-x><c-o>

    " }}}

    " Mappings for editing .vimrc {{{

    " bindings for making it easier to edit the .vimrc
    "  <leader>ev - opens .vimrc
    "  <leader>sv - reloads .vimrc
    map <leader>ev :e ~/.vimrc<Enter><C-W>_
    map <silent> <leader>sv :source ~/.vimrc<enter>:filetype detect<enter>:echo 'vimrc reloaded'<enter>

    " }}}

    " Cursor lines/columns - toggling commands {{{

    map  <silent> <leader>c      :set cursorcolumn! cursorline! <cr>
    imap <silent> <leader>c <esc>:set cursorcolumn! cursorline! <cr>a

    "}}}

    " map ,e to open files in the same directory as the current file {{{

    cnoremap %% <c-r>=expand("%:h")<cr>/
    map <leader>e :edit %%
    map <leader>v :view %%

    " }}}

    " tabs {{{

    map tl :tabnext<cr>
    map th :tabprev<cr>
    map tn :tabnew<cr>
    map td :tabclose<cr>

    " }}}

    " disable arrows for navigation {{{
    inoremap <Up> <NOP>
    inoremap <Down> <NOP>
    inoremap <Left> <NOP>
    inoremap <Right> <NOP>
    nnoremap <Up> <NOP>
    nnoremap <Down> <NOP>
    nnoremap <Left> <NOP>
    nnoremap <Right> <NOP>
    " }}}

    " refactoring with rope {{{

    map <leader>j :RopeGotoDefinition<cr>
    map <leader>r :RopeRename<cr>

    " }}}

" }}}

" cscope settings {{{
" mostly taken from: http://cscope.sourceforge.net/cscope_maps.vim

if has("cscope")

    "set cscopetag

    " load a project specific cscope database
    set nocsverb
    if filereadable("cscope.out")
        cs add cscope.out
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb

    " cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls

    " jump to search result in current window
    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

    " jump to search result in a horizontal split
    nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>

    " jump to search result in a vertical split
    nmap <C-Space><C-Space>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space><C-Space>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space><C-Space>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space><C-Space>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space><C-Space>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space><C-Space>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-Space><C-Space>i :vert scs find i ^<C-R>=expand("<cfile>")<CR><CR>
    nmap <C-Space><C-Space>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>

endif

" }}}

" Let me Google that for you {{{

    function! Google(q)
        " Google a search term using Chrome
        let l:goog = shellescape("https://google.com/search?q=" . a:q)
        let l:cmd = "/usr/bin/open -a Google\\ Chrome " . l:goog
        call system(l:cmd . " 2>&1 > /dev/null")
    endfunction

    function! GooglePrompt()
        call inputsave()
        let q = input("Google: ")
        call inputrestore()
        call Google(q)
    endfunction

    function! VGoogle()
        let reg = '"'
        silent exe 'norm! gv"'.reg.'y'
        call Google(getreg(reg))
    endfunction

    map <leader>g :call Google(expand("<cword>"))<CR>
    map <leader>G :call GooglePrompt()<CR>
    vmap <leader>g :call VGoogle()<CR>

" }}}

" autocompletion settings {{{

set completeopt=menuone,menu,longest,preview

" }}}

" license mappings {{{

map <leader>AL :call AddApacheLicense()<cr>

function! AddApacheLicense()
    :0r ~/.vim/apache.txt
    exe "3 s/<copyright-year>/" . strftime("%Y") . "/"
    :16
endfunction

" }}}

" plugin settings {{{

    " airline {{{

    let g:airline_powerline_fonts = 1
    "let g:airline#extensions#tabline#enabled = 1
    "let g:airline#extensions#tabline#tab_min_count = 0

    " }}}

    " virtualenv {{{

    let g:virtualenv_directory = "~/.pythonbrew/venvs/Python-2.7/"

    " }}}

    "  gitgutter {{{
    let g:gitgutter_realtime = 1
    "let g:gitgutter_eager = 1
    "  }}}

    " SimpylFold {{{

    let g:SimpylFold_fold_docstring = 0

    " }}}

    " delimitMate {{{

    au FileType python let b:delimitMate_nesting_quotes = ['"']

    " }}}

    " UltiSnips {{{

    let g:UltiSnipsExpandTrigger="<C-space>"
    let g:UltiSnipsEditSplit="horizontal"
    let g:UltiSnipsSnippetsDir="ultisnips"
    let g:UltiSnipsSnippetDirectories=["ultisnips"]

    " }}}

    " YouCompleteMe {{{

    let g:ycm_autoclose_preview_window_after_insertion = 1

    " }}}

" }}}

" vim:foldenable:fdm=marker
