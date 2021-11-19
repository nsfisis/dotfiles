scriptencoding utf-8


if exists('b:did_ftplugin_python_after')
    finish
endif



FtpluginSetLocal expandtab
FtpluginSetLocal shiftwidth=4
FtpluginSetLocal softtabstop=4

let g:python_highlight_all = v:true

" Overrides the default value: shiftwidth()*2
let g:pyindent_continue = shiftwidth()



let b:did_ftplugin_python_after = 1