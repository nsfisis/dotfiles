if exists('b:did_indent')
    finish
endif

setlocal indentexpr=v:lua.require'leaf.indent'.indentexpr()

let b:did_indent = 1
