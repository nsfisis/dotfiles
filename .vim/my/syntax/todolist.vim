scriptencoding utf-8


if exists("b:current_syntax")
    finish
endif



syn match todolistCheckboxUnchecked /\[ \]/
syn match todolistCheckboxChecked /\[x\]/
syn region todolistComment start="//" end="$"



hi def link todolistCheckboxUnchecked Operator
hi def link todolistCheckboxChecked Operator
hi def link todolistComment Comment


let b:current_syntax = "todolist"
