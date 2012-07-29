" Only do this when not done yet for this buffer
if exists("b:loaded_slither_editing")
    finish
endif
let b:loaded_slither_editing = '0.1'

map <buffer> <s-e> :w<cr>:!/usr/bin/env python % <cr>
map <buffer> gd /def <c-r><c-w><cr> 
