scriptencoding utf-8


if exists('b:did_ftplugin_markdown_after')
    finish
endif



FtpluginSetLocal expandtab
FtpluginSetLocal shiftwidth=4
FtpluginSetLocal softtabstop=4

let g:markdown_syntax_conceal = v:false



let b:did_ftplugin_markdown_after = 1
