setlocal foldmethod=expr
setlocal foldexpr=GetPythonFold(v:lnum)
setlocal foldtext=GetPythonFoldText()

fun! GetPythonFold(lnum)
    if getline(a:lnum) =~? '\v^\s*$'
        let next_line = nextnonblank(a:lnum)
        if next_line > 1
            return IndentLevel(next_line)
        endif
        return "-1"
    endif

    let enclosing_line = s:FindEnclosingClassOrDef(a:lnum)
    if enclosing_line > 0
        return IndentLevel(enclosing_line) + 1
    endif
    return "0"
endf

fun! IndentLevel(lnum)
    return (indent(a:lnum) / &shiftwidth)
endf

function! s:FindEnclosingClassOrDef(lnum)
    if getline(a:lnum) =~? '\v^\s*class.+:$|^\s*def.+:$'
        return a:lnum
    endif

    let original_indent = indent(a:lnum)
    let possible_lnum = a:lnum
    while possible_lnum >= 0
        if getline(possible_lnum) =~? '\v^\s*class.+:$|^\s*def.+:$'
            if indent(possible_lnum) < original_indent "|| original_indent == 0
                return possible_lnum
            endif
        endif
        let possible_lnum -= 1
    endwhile

    return -1
endf

fun! GetPythonFoldText()
    " Heavily inspired by
    " http://www.gregsexton.org/2011/03/improving-the-text-displayed-in-a-fold/"

    " folds only start on class or def statements - let grab the line
    let line = getline(v:foldstart)

    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = " " . foldSize . " lines "
    "let foldLevelStr = repeat("+--", v:foldlevel)
    let foldLevelStr = repeat("+--", 1)
    let lineCount = line("$")
    let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "
    let expansionString = repeat(".", w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
    return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endf
