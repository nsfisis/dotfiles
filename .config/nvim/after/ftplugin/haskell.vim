scriptencoding utf-8


if exists('b:did_ftplugin_haskell_after')
    finish
endif



FtpluginSetLocal expandtab
FtpluginSetLocal shiftwidth=4
FtpluginSetLocal softtabstop=4

let g:hs_highlight_boolean = v:true
let g:hs_highlight_types = v:true
let g:hs_highlight_more_types = v:true
let g:hs_highlight_debug = v:true
let g:hs_allow_hash_operator = v:true



let b:did_ftplugin_haskell_after = 1
