scriptencoding utf-8


if exists('b:did_ftplugin_cpp_after')
    finish
endif



FtpluginSetLocal expandtab
FtpluginSetLocal shiftwidth=4
FtpluginSetLocal softtabstop=4
FtpluginSetLocal cinoptions=:0,l1,g0,N-s

let g:c_comment_strings = v:true
let g:c_space_errors = v:true



let b:did_ftplugin_cpp_after = 1