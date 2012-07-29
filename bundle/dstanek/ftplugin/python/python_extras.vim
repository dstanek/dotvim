" python-extras.vim -- version 0.1
"
" Integrates several Python development tools to give you a kick-ass
" IDE-like experience. IDEs suck! Long like Vim!
"
" (c) Copyright 20[\d]{2} David Stanek <dstanek@dstanek.com>
"
" You can reach me at:
"  - dstanek {at} dstanek.com
"  - @dstanek
"  - http://traceback.org
"
" Usage:
"
" Save this script into your ~/.vim/scripts/ directory and source it when
" editing Python files:
"   au FileType python source ~/.vim/scripts/python-extras.vim
"
" Requirements:
" vim (>= 7.3)
"
" New Key Bindings:
"   [[      -- Jump to beginning of block
"   ]]      -- Jump to end of block
"   ]v      -- Select (Visual Line Mode) block
"   ]<      -- Shift block to left
"   ]>      -- Shift block to right
"   ]#      -- Comment selection
"   ]u      -- Uncomment selection
"   ]c      -- Select current/previous class
"   ]f      -- Select current/previous function
"   ]<up>   -- Jump to previous line with the same/lower indentation
"   ]<down> -- Jump to next line with the same/lower indentation


if exists('b:loaded_slither_extras')
    finish
endif
let b:loaded_slither_extras = '0.1'


" {{{ Python testing support

"function! RedBar(error_message)
"    hi RedBar ctermfg=white ctermbg=red guifg=white guibg=red
"    echohl RedBar
"    echon a:error_message . repeat(" ", &columns - strlen(a:error_message))
"    echohl
"endfunction


"function! GreenBar()
"    hi GreenBar ctermfg=white ctermbg=green guifg=white guibg=green
"    echohl GreenBar
"    echon 'All tests passed' . repeat(" ", &columns-16)
"    echohl
"endfunction


function! FindTestsForCurrentFile()
    python find_tests_for_current_file()
endfunction


"function! FindTestDirForCurrentFile()
"    python find_test_dir_for_current_file()
"endfunction
"
"
"function! JumpToError()
"    if getqflist() != []
"        for error in getqflist()
"            if error['valid']
"                break
"            endif
"        endfor
"
"        silent cc!
"        exec ":sbuffer " . error['bufnr']
"
"        let error_message = substitute(error['text'], '^ *', '', 'g')
"        call RedBar(error_message)
"    else
"        call GreenBar()
"    endif
"endfunction
"
"
function! RunTests(target, args)
    silent ! echo
    echo 'silent ! echo -e "\033[1;36mRunning tests in ' . a:target . '\033[0m"'
    exec 'silent ! echo -e "\033[1;36mRunning tests in ' . a:target . '\033[0m"'
    set makeprg=nosetests\ --with-doctest\ -x
    silent w
    exec "make " . a:args . " '" . a:target . "'"
endfunction
"
"
"function! RunAllTests(args)
"    silent ! echo
"    silent ! echo -e "\033[1;36mRunning all unit tests\033[0m"
"    let test_dir_name = FindTestDirForCurrentFile()
"    call RunTests(test_dir_name, a:args)
"endfunction


function! RunTestsForFile(args)
    let test_file_name = FindTestsForCurrentFile()
    call RunTests(test_file_name, a:args)
endfunction


function! JumpToTestsForFile()
    exec 'e ' . FindTestsForCurrentFile()
endfunction


if has('python')
    pyfile ~/.vim/pylibs/helpers.py

    nnoremap <silent> <leader>m :call RunTestsForFile('--with-machineout')<cr>:redraw<cr>:call JumpToError()<cr>
    nnoremap <silent> <leader>M :call RunTestsForFile('')<cr>
    nnoremap <silent> <leader>a :call RunAllTests('--with-machineout')<cr>:redraw<cr>:call JumpToError()<cr>
    nnoremap <silent> <leader>A :call RunAllTests('')<cr>
    "nnoremap <silent> <leader>t :call JumpToTestsForFile()<cr>
else
    nnoremap <silent> <leader>m :echo 'Sorry, this requires Python support.'<cr>
    nnoremap <silent> <leader>M :echo 'Sorry, this requires Python support.'<cr>
    nnoremap <silent> <leader>a :echo 'Sorry, this requires Python support.'<cr>
    nnoremap <silent> <leader>A :echo 'Sorry, this requires Python support.'<cr>
    nnoremap <silent> <leader>t :echo 'Sorry, this requires Python support.'<cr>
endif

" }}}

"" {{{ Pylint support
"
"""source ~/.vim/compiler/pylint.vim
""autocmd FileType python compiler pylint
"
"" }}}

"" {{{ Python breakpoints
"
"" Author: Nick Anderson <nick at anders0n.net>
"" Website: http://www.cmdln.org
"" Adapted from sonteks post on Vim as Python IDE
"" http://blog.sontek.net/2008/05/11/python-with-a-modular-ide-vim/
"
"python << EOF
"
"def SetBreakpoint():
"    import re
"    nLine = int( vim.eval( 'line(".")'))
"
"    strLine = vim.current.line
"    strWhite = re.search( '^(\s*)', strLine).group(1)
"
"    vim.current.buffer.append(
"       "%(space)sfrom ipdb import set_trace;set_trace() %(mark)s Breakpoint %(mark)s" %
"         {'space':strWhite, 'mark': '#' * 30}, nLine - 1)
"
"vim.command( 'map <f7> :py SetBreakpoint()<cr>')
"
"def RemoveBreakpoints():
"    import re
"
"    nCurrentLine = int( vim.eval( 'line(".")'))
"
"    nLines = []
"    nLine = 1
"    for strLine in vim.current.buffer:
"        if strLine.lstrip()[:38] == 'from ipdb import set_trace;set_trace()':
"            nLines.append( nLine)
"            print nLine
"        nLine += 1
"
"    nLines.reverse()
"
"    for nLine in nLines:
"        vim.command( 'normal %dG' % nLine)
"        vim.command( 'normal dd')
"        if nLine < nCurrentLine:
"            nCurrentLine -= 1
"
"    vim.command( 'normal %dG' % nCurrentLine)
"
"vim.command( 'map <s-f7> :py RemoveBreakpoints()<cr>')
"EOF
"
"" }}}

"" {{{ Highlight extra errors
"" From Gary Bernhardt's Vim scripts
""   http://bitbucket.org/garybernhardt/dotfiles/ 
"
"syn match pythonError	 "^\s*def\s\+\w\+(.*)\s*$" display
"syn match pythonError	 "^\s*class\s\+\w\+(.*)\s*$" display
"syn match pythonError	 "^\s*except\s*$" display
"syn match pythonError	 "^\s*finally\s*$" display
"syn match pythonError	 "^\s*try\s*$" display
"syn match pythonError	 "^\s*except\s.*[^\:]$" display
"syn match pythonError	 "[;]$" display
"syn match pythonError    ".\%>79v" display
"syn keyword pythonError         do
"" }}}

" {{{ Key mappings for easily moving around Python code

" Find comment
map <leader>/# /^ *#<cr>

" Find function
map <leader>/f /^ *def\><cr>

" Find class
map <leader>/c /^ *class\><cr>

" Find if
map <leader>/i /^ *if\><cr>

" Delete function
" \%$ means 'end of file' in vim-regex-speak
map <leader>df d/\(^ *def\>\)\\|\%$<cr>

com! FindLastImport :execute'normal G<CR>' | :execute':normal ?^\(from\|import\)\><CR>'
map <leader>/m :FindLastImport<cr>

" }}}

"" vim:foldenable:foldmethod=marker:
