scriptencoding utf-8

if exists('b:current_syntax')
    finish
endif


syn match leafCheckboxTodo /\[ \]/
syn match leafCheckboxDone /\[x\]/
syn match leafCheckboxCanceled /\[-\]/
syn region leafComment start="# " end="$"
syn match leafTag /@\w\+/
syn match leafProperty /\<\%(DEADLINE\|SCHEDULED\|ARCHIVED\): /
syn match leafTimestamp /<\d\d\d\d-\d\d-\d\d\%( [月火水木金土日]\)\?\%( \d\d:\d\d\)\?>/
syn match leafTimestamp /<\d\d\d\d-\d\d-\d\d\%( [月火水木金土日]\)\?\%( \d\d:\d\d\)\?>--<\d\d\d\d-\d\d-\d\d\%( [月火水木金土日]\)\?\%( \d\d:\d\d\)\?>/


hi default link leafCheckboxTodo Special
hi default link leafCheckboxDone Comment
hi default link leafCheckboxCanceled Comment
hi default link leafComment Comment
hi default link leafTag String
hi default link leafProperty Identifier
hi default link leafTimestamp Identifier


let b:current_syntax = 'leaf'
