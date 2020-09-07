scriptencoding utf-8


if exists('b:did_ftplugin_after_todolist')
    finish
endif



FtpluginSetLocal expandtab
FtpluginSetLocal shiftwidth=4
FtpluginSetLocal softtabstop=4
" FtpluginSetLocal foldmethod=indent


let b:caw_oneline_comment = '//'


let b:lexima_disabled = 1
" for lexima
inoremap <nowait> <buffer>  <ESC>  <ESC>


nmap <buffer>  ,x  <Plug>(todolist-toggle-checkbox)
nmap <buffer>  ,X  <Plug>(todolist-toggle-checkbox-rec)



let b:did_ftplugin_after_todolist = 1
