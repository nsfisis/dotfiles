scriptencoding utf-8


if exists("b:current_syntax_my_python")
    finish
endif

if b:current_syntax !=# 'python'
    finish
endif



" Highlight "self".
syn keyword pythonSelf self
hi default link pythonSelf Identifier


let b:current_syntax_my_python = 1
