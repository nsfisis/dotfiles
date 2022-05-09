vim.cmd('hi clear')
vim.g.colors_name = 'ocean'



-- Color palette {{{1

local palette
if vim.o.background == 'dark' then
   palette = {
      NONE      = 'NONE',
      fg        = '#b1b1c8',
      bg        = '#101020',
      blue      = '#6e6eff',
      blue_bg   = '#202050',
      blue2     = '#70b0ff',
      comment   = '#8686bf',
      cursor    = '#5b5bb6',
      gray      = '#353535',
      gray2     = '#202020',
      green     = '#c4e088',
      green_bg  = '#204020',
      orange    = '#deab52',
      orange2   = '#ff7100',
      red       = '#a65f49',
      red_bg    = '#402020',
      selection = '#303060',
      yellow    = '#a68f49',
      yellow2   = '#a89562',
      yellow3   = '#5c5241',
   }
else
   palette = {
      NONE      = 'NONE',
      fg        = '#203050',
      bg        = '#f5f5ff',
      blue      = '#6e6eff',
      blue_bg   = '#202050',
      blue2     = '#6f8fff',
      comment   = '#a0a0e0',
      cursor    = '#5b5bb6',
      gray      = '#bebebe',
      gray2     = '#171717',
      green     = '#6f9226',
      green_bg  = '#204020',
      orange    = '#e79230',
      orange2   = '#ff7100',
      red       = '#d77253',
      red_bg    = '#402020',
      selection = '#f0f0d0',
      yellow    = '#cba224',
      yellow2   = '#af8e29',
      yellow3   = '#c6b683',
   }
end


-- Set colors for `Normal` group. {{{1

-- Why do I highlight `Normal` first?
--   Because setting colors for it may change `background` option, which causes
--   the highlight groups that depend on `background` to change.
--
-- Why do I set `ctermfg` and `ctermbg` here?
--   Because Vim doesn't notify background/foreground colors to a terminal
--   unless `ctermfg` or `ctermbg` is explicitly configured to `Normal`
--   highlight group.
--
-- See also `:h :hi-normal-cterm`.
vim.cmd(('hi! Normal ctermfg=0 ctermbg=0 guifg=%s guibg=%s'):format(palette.fg, palette.bg))


-- Semantic highlight group {{{1

local function hl(group_name, guifg, guibg, attr)
   vim.cmd(('hi! ocean%s guifg=%s guibg=%s gui=%s cterm=%s'):format(
      group_name,
      palette[guifg],
      palette[guibg],
      attr,
      attr)
   )
end



hl('AnalysisError',            'red',     'NONE',        'underline')
hl('AnalysisWarning',          'yellow2', 'NONE',        'underline')
hl('Cursor',                   'fg',      'cursor',      'NONE')
hl('DecorationBold',           'NONE',    'NONE',        'bold')
hl('DecorationUnderlined',     'NONE',    'NONE',        'underline')
hl('DiffAdd',                  'NONE',    'blue_bg',     'NONE')
hl('DiffChange',               'NONE',    'green_bg',    'NONE')
hl('DiffDelete',               'NONE',    'red_bg',      'NONE')
hl('DiffText',                 'NONE',    'green_bg',    'underline')
hl('Error',                    'red',     'NONE',        'NONE')
hl('Hidden',                   'bg',      'bg',          'NONE')
hl('Normal',                   'fg',      'bg',          'NONE')
hl('Prompt',                   'comment', 'NONE',        'bold')
hl('Search',                   'bg',      'yellow3',     'NONE')
hl('Special',                  'red',     'NONE',        'NONE')
hl('SpecialKey',               'gray',    'NONE',        'NONE')
hl('SyntaxComment',            'comment', 'NONE',        'NONE')
hl('SyntaxCommentSpecial',     'fg',      'NONE',        'bold')
hl('SyntaxConstant',           'red',     'NONE',        'NONE')
hl('SyntaxIdentifier',         'green',   'NONE',        'NONE')
hl('SyntaxStatement',          'blue',    'NONE',        'bold')
hl('SyntaxStatement2',         'blue',    'NONE',        'NONE')
hl('SyntaxString',             'yellow',  'NONE',        'NONE')
hl('SyntaxType',               'blue2',   'NONE',        'NONE')
hl('Title',                    'orange',  'NONE',        'NONE')
hl('UiCompletion',             'fg',      'gray',        'NONE')
hl('UiSelection',              'NONE',    'selection',   'NONE')
hl('UiStatusLine',             'fg',      'gray',        'NONE')
hl('UiStatusLineModeCommand',  'bg',      'blue',        'bold')
hl('UiStatusLineModeInsert',   'bg',      'green',       'bold')
hl('UiStatusLineModeNormal',   'bg',      'blue',        'bold')
hl('UiStatusLineModeOperator', 'bg',      'blue',        'bold')
hl('UiStatusLineModeOther',    'bg',      'blue',        'bold')
hl('UiStatusLineModeReplace',  'bg',      'red',         'bold')
hl('UiStatusLineModeTerminal', 'bg',      'blue',        'bold')
hl('UiStatusLineModeVisual',   'bg',      'orange',      'bold')
hl('UiStatusLineNC',           'comment', 'gray2',       'NONE')
hl('UiTabLine',                'fg',      'gray',        'NONE')
hl('UiTabLineNC',              'comment', 'bg',          'NONE')
hl('UiTarget',                 'orange2', 'NONE',        'underline')
hl('Warning',                  'yellow2', 'NONE',        'NONE')



-- Highlight link {{{1

local function link(from, to)
   vim.cmd(('hi! link %s ocean%s'):format(from, to))
end



-- :sort /, \+/

-- Vim builtins {{{2

link('SpellBad',       'AnalysisError')
link('SpellCap',       'AnalysisError')
link('SpellLocal',     'AnalysisWarning')
link('SpellRare',      'AnalysisWarning')
link('Cursor',         'Cursor')
link('CursorIM',       'Cursor')
link('Underlined',     'DecorationUnderlined')
link('DiffAdd',        'DiffAdd')
link('DiffChange',     'DiffChange')
link('DiffDelete',     'DiffDelete')
link('DiffText',       'DiffText')
link('Error',          'Error')
link('ErrorMsg',       'Error')
link('EndOfBuffer',    'Hidden')
link('MatchParen',     'Hidden')
link('CursorLineNr',   'Normal')
link('MoreMsg',        'Prompt')
link('Question',       'Prompt')
link('IncSearch',      'Search')
link('Search',         'Search')
link('Special',        'Special')
link('NonText',        'SpecialKey')
link('SpecialKey',     'SpecialKey')
link('Comment',        'SyntaxComment')
link('Folded',         'SyntaxComment')
link('ModeMsg',        'SyntaxComment')
link('SpecialComment', 'SyntaxCommentSpecial')
link('Todo',           'SyntaxCommentSpecial')
link('Constant',       'SyntaxConstant')
link('Identifier',     'SyntaxIdentifier')
link('Statement',      'SyntaxStatement')
link('Operator',       'SyntaxStatement2')
link('PreProc',        'SyntaxStatement2')
link('Character',      'SyntaxString')
link('String',         'SyntaxString')
link('Directory',      'SyntaxType')
link('Type',           'SyntaxType')
link('Title',          'Title')
link('WildMenu',       'Title')
link('PMenu',          'UiCompletion')
link('PMenuSbar',      'UiCompletion')
link('PMenuThumb',     'UiCompletion')
link('CursorColumn',   'UiSelection')
link('CursorLine',     'UiSelection')
link('FoldColumn',     'UiSelection')
link('LineNr',         'UiSelection')
link('PMenuSel',       'UiSelection')
link('SignColumn',     'UiSelection')
link('Visual',         'UiSelection')
link('ColorColumn',    'UiSelection')
link('VertSplit',      'UiStatusLine')
link('WarningMsg',     'Warning')


-- Tree-sitter {{{2

link('TSText', 'Normal')


-- 'statusline' and 'tabline' {{{2

-- Cited from ':h hl-StatusLineNC':
-- > Note: if this is equal to "StatusLine" Vim will use "^^^" in
-- > the status line of the current window.
link('StatusLine',             'UiStatusLine')
link('StatusLineNC',           'UiStatusLineNC')
link('statusLineModeNormal',   'UiStatusLineModeNormal')
link('statusLineModeInsert',   'UiStatusLineModeInsert')
link('statusLineModeVisual',   'UiStatusLineModeVisual')
link('statusLineModeOperator', 'UiStatusLineModeOperator')
link('statusLineModeReplace',  'UiStatusLineModeReplace')
link('statusLineModeCommand',  'UiStatusLineModeCommand')
link('statusLineModeTerminal', 'UiStatusLineModeTerminal')
link('statusLineModeOther',    'UiStatusLineModeOther')


link('TabLineSel',  'UiTabLine')
link('TabLine',     'UiTabLineNC')
link('TabLineFill', 'Hidden')


-- Third-party plugins {{{2

link('YankRoundRegion', 'UiSelection')

link('OperatorSandwichAdd',    'UiSelection')
link('OperatorSandwichBuns',   'UiSelection')
link('OperatorSandwichChange', 'UiSelection')
link('OperatorSandwichDelete', 'UiSelection')

link('HopNextKey', 'UiTarget')
link('HopNextKey1', 'UiTarget')
link('HopNextKey2', 'UiTarget')


-- File types {{{2

-- c {{{3

link('cOctalZero', 'Constant')

-- cpp {{{3

link('cppRawStringDelimiter', 'SyntaxString')

-- html {{{3

link('htmlEndTag',  'SyntaxStatement2')
link('htmlTag',     'SyntaxStatement2')
link('htmlTagName', 'SyntaxStatement2')

-- php {{{3

link('phpParent',          'Normal')
link('phpOperator',        'Normal')
link('phpRelation',        'Normal')
link('phpDocTags',         'SyntaxCommentSpecial')
link('phpSpecialFunction', 'SyntaxIdentifier')

-- ruby {{{3

link('rubyDataDirective',   'SyntaxStatement2')
link('rubyStringDelimiter', 'SyntaxString')

-- sh {{{3

link('shQuote',       'SyntaxString')
link('shDerefSimple', 'SyntaxIdentifier')
link('shDerefVar',    'SyntaxIdentifier')

-- sql {{{3

link('sqlKeyword', 'SyntaxStatement2')





