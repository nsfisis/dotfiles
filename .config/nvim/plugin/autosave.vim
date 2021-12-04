scriptencoding utf-8

if exists('g:loaded_autosave')
    finish
endif


command! -bar
    \ AutosaveEnable
    \ lua require('autosave').enable()

command! -bar
    \ AutosaveDisable
    \ lua require('autosave').disable()

command! -bar
    \ AutosaveToggle
    \ lua require('autosave').toggle()


let g:loaded_autosave = 1
