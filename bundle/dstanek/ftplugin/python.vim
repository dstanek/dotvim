" David Stanek <dstanek@dstanek.com>
"
" My Python IDE setup

" whitespace
set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=78
set expandtab autoindent
set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" misc highlights
call matchadd('ErrorMsg', '\%>'.&tw.'v', -1) " long lines
call matchadd('ErrorMsg', '\s\+$', -1)       " trailing whitespace
call matchadd('ErrorMsg', '\t\+', -1)        " tabs

set ofu=pythoncomplete#Complete
set completeopt=menuone,longest,preview
"inoremap <C-Space> <C-x><C-o>
inoremap <C-Space> <C-g>g

set tags+=$HOME/.vim/tags/python27.ctags,$HOME/.vim/tags/django-master.ctags

" comment settings
set formatoptions=cq textwidth=72 foldignore= wildignore+=*.py[co]

" Add a virtualenv's site-packages to vim path so that vim can provide
" completion for libraries installed there
python << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
else:
    activate_this = os.path.expanduser('~/.vim/pyenv/bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

python << EOF
import os
import sys
from os.path import join as joinpath, dirname, expanduser
import vim

py_path = os.path.expanduser('~/.vim/pylibs/')
sys.path.append(py_path)
for path in os.listdir(py_path):
    path = os.path.join(py_path, path)
    if os.path.isdir(path):
        sys.path.append(path)
EOF

function! python#statusline() " {{{
    let env = expand("$VIRTUAL_ENV")
    if strlen(env) > 0
        return "[venv:".fnamemodify(env, ":t")."]"
    endif
    return ""
endf

" setup rope
source ~/.vim/pylibs/ropevim/ropevim.vim

"set foldcolumn=3
"set foldnestmax=2
nnoremap <space> za

autocmd BufNewFile,BufRead *.py :compiler nose
