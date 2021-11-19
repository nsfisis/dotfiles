scriptencoding utf-8

if exists('g:loaded_autosave')
    finish
endif



command! -bar
    \ AutosaveEnable
    \ call autosave#enable()


command! -bar
    \ AutosaveDisable
    \ call autosave#disable()


command! -bar
    \ AutosaveToggle
    \ if exists('b:autosave_timer') |
    \     call autosave#enable() |
    \ else |
    \     call autosave#disable() |
    \ endif



let g:loaded_autosave = 1
