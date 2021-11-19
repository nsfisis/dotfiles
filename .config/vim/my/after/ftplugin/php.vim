scriptencoding utf-8


if exists('b:did_ftplugin_php_after')
    finish
endif



FtpluginSetLocal expandtab
FtpluginSetLocal shiftwidth=2
FtpluginSetLocal softtabstop=2



" If a buffer is empty, insert `<?php` tag and 2 blank lines, and position the
" cursor at the end of the buffer (line 3, column 0).
"
" Example:
" <?php
"
" [cursor]
if line('$') ==# 1 && empty(getline(1))
    call setline(1, ['<?php', '', ''])
    call cursor(3, 0)
endif



let b:did_ftplugin_php_after = 1
