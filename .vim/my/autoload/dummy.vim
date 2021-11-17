scriptencoding utf-8



let s:text = {}

let s:text.lipsum = [
    \ 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
    \ 'incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis',
    \ 'nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    \ 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore',
    \ 'eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt',
    \ 'in culpa qui officia deserunt mollit anim id est laborum.',
    \ ]

let s:text.lipsum1 = join(s:text.lipsum)

let s:text.quickbrownfox = 'The quick brown fox jumps over the lazy dog.'

let s:text.ABC = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

let s:text.abc = 'abcdefghijklmnopqrstuvwxyz'

let s:text.hiragana = 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん'

let s:text.katakana = 'アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン'

let s:text.ihatovo = 'あのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモリーオ市、郊外のぎらぎらひかる草の波。'



function! dummy#insert(type)
    call append(line('.'), get(s:text, a:type, ''))
endfunction


function! dummy#complete(arglead, cmdline, cursorpos) abort
    return sort(filter(keys(s:text), {idx, val -> val[0:len(a:arglead)-1] =~? a:arglead}))
endfunction
