scriptencoding utf-8


if exists('b:did_ftplugin_vim_after')
    finish
endif



FtpluginSetLocal colorcolumn=+1
FtpluginSetLocal expandtab
FtpluginSetLocal iskeyword-=#
FtpluginSetLocal keywordprg=:help
FtpluginSetLocal shiftwidth=4
FtpluginSetLocal softtabstop=4
FtpluginSetLocal textwidth=78

let g:vim_indent_cont = 4



let b:did_ftplugin_vim_after = 1