scriptencoding utf-8


hi clear
let g:colors_name = 'ocean'



" Color palette {{{1

if &background ==# 'dark'
    let s:palette = {
        \ 'NONE':      'NONE',
        \ 'fg':        '#b1b1c8',
        \ 'bg':        '#101020',
        \ 'blue':      '#6e6eff',
        \ 'blue-bg':   '#202050',
        \ 'blue2':     '#70b0ff',
        \ 'comment':   '#8686bf',
        \ 'cursor':    '#5b5bb6',
        \ 'gray':      '#353535',
        \ 'gray2':     '#353536',
        \ 'green':     '#c4e088',
        \ 'green-bg':  '#204020',
        \ 'orange':    '#deab52',
        \ 'orange2':   '#ff7100',
        \ 'red':       '#a65f49',
        \ 'red-bg':    '#402020',
        \ 'selection': '#303060',
        \ 'yellow':    '#a68f49',
        \ 'yellow2':   '#a89562',
        \ 'yellow3':   '#5c5241',
        \ }
else
    let s:palette = {
        \ 'NONE':      'NONE',
        \ 'fg':        '#203050',
        \ 'bg':        '#f5f5ff',
        \ 'blue':      '#6e6eff',
        \ 'blue-bg':   '#202050',
        \ 'blue2':     '#6f8fff',
        \ 'comment':   '#a0a0e0',
        \ 'cursor':    '#5b5bb6',
        \ 'gray':      '#bebebe',
        \ 'gray2':     '#bebebf',
        \ 'green':     '#6f9226',
        \ 'green-bg':  '#204020',
        \ 'orange':    '#e79230',
        \ 'orange2':   '#ff7100',
        \ 'red':       '#d77253',
        \ 'red-bg':    '#402020',
        \ 'selection': '#f0f0d0',
        \ 'yellow':    '#cba224',
        \ 'yellow2':   '#af8e29',
        \ 'yellow3':   '#c6b683',
        \ }
endif



" Semantic highlight group {{{1

function! s:hl(group_name, guifg, guibg, attr) abort
    execute printf('hi! ocean%s guifg=%s guibg=%s gui=%s cterm=%s',
       \ a:group_name,
       \ s:palette[a:guifg],
       \ s:palette[a:guibg],
       \ a:attr,
       \ a:attr)
endfunction


call s:hl('AnalysisError',            'red',     'NONE',        'underline')
call s:hl('AnalysisWarning',          'yellow2', 'NONE',        'underline')
call s:hl('Cursor',                   'fg',      'cursor',      'NONE')
call s:hl('DecorationBold',           'NONE',    'NONE',        'bold')
call s:hl('DecorationUnderlined',     'NONE',    'NONE',        'underline')
call s:hl('DiffAdd',                  'NONE',    'blue-bg',     'NONE')
call s:hl('DiffChange',               'NONE',    'green-bg',    'NONE')
call s:hl('DiffDelete',               'NONE',    'red-bg',      'NONE')
call s:hl('DiffText',                 'NONE',    'green-bg',    'underline')
call s:hl('Error',                    'red',     'NONE',        'NONE')
call s:hl('Hidden',                   'bg',      'bg',          'NONE')
call s:hl('Normal',                   'fg',      'bg',          'NONE')
call s:hl('Prompt',                   'comment', 'NONE',        'bold')
call s:hl('Search',                   'bg',      'yellow3',     'NONE')
call s:hl('Special',                  'red',     'NONE',        'NONE')
call s:hl('SpecialKey',               'gray',    'NONE',        'NONE')
call s:hl('SyntaxComment',            'comment', 'NONE',        'NONE')
call s:hl('SyntaxCommentSpecial',     'fg',      'NONE',        'bold')
call s:hl('SyntaxConstant',           'red',     'NONE',        'NONE')
call s:hl('SyntaxIdentifier',         'green',   'NONE',        'NONE')
call s:hl('SyntaxStatement',          'blue',    'NONE',        'bold')
call s:hl('SyntaxStatement2',         'blue',    'NONE',        'NONE')
call s:hl('SyntaxString',             'yellow',  'NONE',        'NONE')
call s:hl('SyntaxType',               'blue2',   'NONE',        'NONE')
call s:hl('Title',                    'orange',  'NONE',        'NONE')
call s:hl('UiCompletion',             'fg',      'gray',        'NONE')
call s:hl('UiSelection',              'NONE',    'selection',   'NONE')
call s:hl('UiStatusLine',             'fg',      'gray',        'NONE')
call s:hl('UiStatusLineNC',           'fg',      'gray2',       'NONE')
call s:hl('UiStatusLineModeCommand',  'bg',      'blue',        'bold')
call s:hl('UiStatusLineModeInsert',   'bg',      'green',       'bold')
call s:hl('UiStatusLineModeNormal',   'bg',      'blue',        'bold')
call s:hl('UiStatusLineModeOperator', 'bg',      'blue',        'bold')
call s:hl('UiStatusLineModeOther',    'bg',      'blue',        'bold')
call s:hl('UiStatusLineModeReplace',  'bg',      'red',         'bold')
call s:hl('UiStatusLineModeTerminal', 'bg',      'blue',        'bold')
call s:hl('UiStatusLineModeVisual',   'bg',      'orange',      'bold')
call s:hl('UiTarget',                 'orange2', 'NONE',        'underline')
call s:hl('Warning',                  'yellow2', 'NONE',        'NONE')

delfunction! s:hl



" Highlight link {{{1

" :sort /hi! link \w\+ \+/

" Vim builtins {{{2

hi! link SpellBad       oceanAnalysisError
hi! link SpellCap       oceanAnalysisError
hi! link SpellLocal     oceanAnalysisWarning
hi! link SpellRare      oceanAnalysisWarning
hi! link Cursor         oceanCursor
hi! link CursorIM       oceanCursor
hi! link Underlined     oceanDecorationUnderlined
hi! link DiffAdd        oceanDiffAdd
hi! link DiffChange     oceanDiffChange
hi! link DiffDelete     oceanDiffDelete
hi! link DiffText       oceanDiffText
hi! link Error          oceanError
hi! link ErrorMsg       oceanError
hi! link EndOfBuffer    oceanHidden
hi! link TabLineFill    oceanHidden
hi! link MatchParen     oceanHidden
hi! link CursorLineNr   oceanNormal
hi! link Normal         oceanNormal
hi! link PMenu          oceanUiCompletion
hi! link PMenuSbar      oceanUiCompletion
hi! link PMenuThumb     oceanUiCompletion
hi! link MoreMsg        oceanPrompt
hi! link Question       oceanPrompt
hi! link IncSearch      oceanSearch
hi! link Search         oceanSearch
hi! link CursorColumn   oceanUiSelection
hi! link CursorLine     oceanUiSelection
hi! link FoldColumn     oceanUiSelection
hi! link LineNr         oceanUiSelection
hi! link PMenuSel       oceanUiSelection
hi! link SignColumn     oceanUiSelection
hi! link Visual         oceanUiSelection
hi! link Special        oceanSpecial
hi! link NonText        oceanSpecialKey
hi! link SpecialKey     oceanSpecialKey
hi! link TabLineSel     oceanUiStatusLine
hi! link VertSplit      oceanUiStatusLine
hi! link TabLine        oceanUiStatusLine
hi! link Comment        oceanSyntaxComment
hi! link Folded         oceanSyntaxComment
hi! link ModeMsg        oceanSyntaxComment
hi! link SpecialComment oceanSyntaxCommentSpecial
hi! link Todo           oceanSyntaxCommentSpecial
hi! link Constant       oceanSyntaxConstant
hi! link Identifier     oceanSyntaxIdentifier
hi! link Statement      oceanSyntaxStatement
hi! link Operator       oceanSyntaxStatement2
hi! link PreProc        oceanSyntaxStatement2
hi! link Character      oceanSyntaxString
hi! link String         oceanSyntaxString
hi! link Directory      oceanSyntaxType
hi! link Type           oceanSyntaxType
hi! link Title          oceanTitle
hi! link WildMenu       oceanTitle
hi! link ColorColumn    oceanUiSelection
hi! link WarningMsg     oceanWarning


" 'statusline' and 'tabline' {{{2

" Cited from ':h hl-StatusLineNC':
" > Note: if this is equal to "StatusLine" Vim will use "^^^" in
" > the status line of the current window.
hi! link StatusLine             oceanUiStatusLine
hi! link StatusLineNC           oceanUiStatusLineNC
hi! link statusLineModeNormal   oceanUiStatusLineModeNormal
hi! link statusLineModeInsert   oceanUiStatusLineModeInsert
hi! link statusLineModeVisual   oceanUiStatusLineModeVisual
hi! link statusLineModeOperator oceanUiStatusLineModeOperator
hi! link statusLineModeReplace  oceanUiStatusLineModeReplace
hi! link statusLineModeCommand  oceanUiStatusLineModeCommand
hi! link statusLineModeTerminal oceanUiStatusLineModeTerminal
hi! link statusLineModeOther    oceanUiStatusLineModeOther


" Third-party plugins {{{2

hi! link YankRoundRegion oceanUiSelection

hi! link OperatorSandwichAdd    oceanUiSelection
hi! link OperatorSandwichBuns   oceanUiSelection
hi! link OperatorSandwichChange oceanUiSelection
hi! link OperatorSandwichDelete oceanUiSelection

hi! link EasyMotionMoveHL oceanSearch
hi! link EasyMotionTarget oceanUiTarget


" File types {{{2

" c {{{3

hi! link cOctalZero oceanConstant

" cpp {{{3

hi! link cppRawStringDelimiter oceanSyntaxString

" html {{{3

hi! link htmlEndTag  oceanSyntaxStatement2
hi! link htmlTag     oceanSyntaxStatement2
hi! link htmlTagName oceanSyntaxStatement2

" php {{{3

hi! link phpParent          oceanNormal
hi! link phpOperator        oceanNormal
hi! link phpRelation        oceanNormal
hi! link phpDocTags         oceanSyntaxCommentSpecial
hi! link phpSpecialFunction oceanSyntaxIdentifier

" ruby {{{3

hi! link rubyDataDirective   oceanSyntaxStatement2
hi! link rubyStringDelimiter oceanSyntaxString
