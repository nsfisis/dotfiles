scriptencoding utf-8

if exists('g:loaded_dummy')
    finish
endif



command! -bar -complete=customlist,dummy#complete -nargs=1
    \ Dummy
    \ call dummy#insert(<f-args>)



let g:loaded_dummy = 1
