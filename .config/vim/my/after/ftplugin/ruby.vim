scriptencoding utf-8


if exists('b:did_ftplugin_ruby_after')
    finish
endif



FtpluginSetLocal expandtab
FtpluginSetLocal shiftwidth=2
FtpluginSetLocal softtabstop=2

let g:ruby_operators = v:true
let g:ruby_space_errors = v:true



let b:did_ftplugin_ruby_after = 1
