scriptencoding utf-8


hi clear
let g:colors_name = 'ocean'



let s:dark = {
    \ 'NONE'        : 'NONE',
    \ 'bg'          : '#101020',
    \ 'fg'          : '#b1b1c8',
    \ 'gray1'       : '#a7a7a7',
    \ 'gray2'       : '#353535',
    \ 'gray3'       : '#464646',
    \ 'gray4'       : '#252525',
    \ 'red'         : '#a65f49',
    \ 'red2'        : '#2e1f28',
    \ 'orange'      : '#deab52',
    \ 'yellow'      : '#a68f49',
    \ 'yellow2'     : '#a89562',
    \ 'yellow3'     : '#5c5241',
    \ 'green'       : '#c4e088',
    \ 'blue'        : '#6e6eff',
    \ 'blue2'       : '#70b0ff',
    \ 'diff_add'    : '#202050',
    \ 'diff_change' : '#204020',
    \ 'diff_delete' : '#402020',
    \ 'diff_text'   : '#3e6333',
    \ 'visual'      : '#303060',
    \ 'comment'     : '#8686bf',
    \ 'cursor'      : '#5b5bb6',
    \ }

let s:light = {
    \ 'NONE'        : 'NONE',
    \ 'bg'          : '#f5f5ff',
    \ 'fg'          : '#203050',
    \ 'gray1'       : '#4f4f4f',
    \ 'gray2'       : '#bebebe',
    \ 'gray3'       : '#aeaeae',
    \ 'gray4'       : '#cecece',
    \ 'red'         : '#d77253',
    \ 'red2'        : '#dcc8c2',
    \ 'orange'      : '#e79230',
    \ 'yellow'      : '#cba224',
    \ 'yellow2'     : '#af8e29',
    \ 'yellow3'     : '#c6b683',
    \ 'green'       : '#6f9226',
    \ 'blue'        : '#6e6eff',
    \ 'blue2'       : '#6f8fff',
    \ 'diff_add'    : '#202050',
    \ 'diff_change' : '#204020',
    \ 'diff_delete' : '#402020',
    \ 'diff_text'   : '#c4ff88',
    \ 'visual'      : '#f0f0d0',
    \ 'comment'     : '#a0a0e0',
    \ 'cursor'      : '#5b5bb6',
    \ }


function! s:hi(group_name, guifg, guibg, ...) abort
    let attributes = get(a:000, 0, 'NONE')
    " Even if 'termguicolors' is enabled the attribute "gui" is ignored,
    " instead, "cterm" is used.
    execute printf('hi %s guifg=%s guibg=%s gui=%s cterm=%s',
        \ a:group_name,
        \ s:pallete[a:guifg], s:pallete[a:guibg], attributes, attributes)
endfunction

command! -nargs=*
    \ Hi
    \ call s:hi(<f-args>)



let s:pallete = &background ==# 'dark' ? s:dark : s:light

Hi ColorColumn    NONE    red2
Hi Comment        comment NONE
Hi Constant       red     NONE
Hi Cursor         fg      cursor
Hi DiffAdd        NONE    diff_add
Hi DiffChange     NONE    diff_change
Hi DiffDelete     NONE    diff_delete
Hi DiffText       NONE    diff_text
Hi EndOfBuffer    bg      bg
Hi Error          red     NONE
Hi Identifier     green   NONE
Hi LineNr         gray1   visual
Hi MatchParen     NONE    NONE
Hi MoreMsg        comment NONE
Hi Normal         fg      bg
Hi PMenu          fg      gray2
Hi PMenuSbar      NONE    gray2
Hi PMenuSel       fg      visual
Hi PMenuThumb     NONE    gray4
Hi PreProc        orange  NONE
Hi Search         bg      yellow3 bold
Hi Special        red     NONE
Hi SpecialComment comment NONE    bold
Hi SpecialKey     gray2   NONE
Hi SpellBad       red     NONE    underline
Hi SpellCap       red     NONE    underline
Hi SpellLocal     yellow2 NONE    underline
Hi SpellRare      yellow2 NONE    underline
Hi Statement      blue    NONE
Hi StatusLine     gray1   gray2
Hi StatusLineNC   gray1   gray3
Hi String         yellow  NONE
Hi Title          orange  NONE
Hi Todo           fg      NONE    bold
Hi Type           blue2   NONE
Hi Underlined     NONE    NONE    underline
Hi Visual         NONE    visual
Hi WarningMsg     yellow2 NONE    bold


hi! link Character    String
hi! link CursorColumn CursorLine
hi! link CursorIM     Cursor
hi! link CursorLine   Visual
hi! link CursorLineNr Normal
hi! link Directory    Type
hi! link ErrorMsg     Error
hi! link FoldColumn   LineNr
hi! link Folded       Comment
hi! link IncSearch    Search
hi! link ModeMsg      Comment
hi! link NonText      SpecialKey
hi! link Operator     Identifier
hi! link Question     MoreMsg
hi! link SignColumn   LineNr
hi! link TabLine      StatusLineNC
hi! link TabLineFill  EndOfBuffer
hi! link TabLineSel   StatusLine
hi! link VertSplit    StatusLine
hi! link WildMenu     Title



unlet s:pallete
unlet s:dark
unlet s:light
delfunction s:hi
delcommand Hi
