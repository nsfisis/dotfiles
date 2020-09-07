if exists('b:did_indent')
    finish
endif


setlocal indentexpr=TodolistIndent()


function! TodolistIndent()
    if v:lnum == 0
        return 0
    endif

    let line = getline(v:lnum - 1)
    if s:starts_with_checkbox(line)
        return indent(v:lnum - 1)
    else
        return 0
    endif
endfunction


function! s:starts_with_checkbox(line)
    if a:line =~# '^\s*\[[ x]\]'
        return 1
    else
        return 0
    endif
endfunction


let b:did_indent = 1
