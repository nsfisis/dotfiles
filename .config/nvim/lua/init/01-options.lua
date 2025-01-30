local O = vim.o
local OPT = vim.opt
local my_env = require('vimrc.my_env')


-- Moving around, searching and patterns {{{1

O.wrapscan = false
O.ignorecase = true
O.smartcase = true


-- Displaying text {{{1

O.scrolloff = 7
O.linebreak = true
O.breakindent = true
OPT.breakindentopt:append('sbr')
O.showbreak = '> '
O.sidescrolloff = 20
OPT.fillchars = {
   vert = ' ',
   fold = ' ',
   diff = ' ',
}
O.cmdheight = 1
O.list = true
OPT.listchars = {
   eol = '\xc2\xac', -- u00ac
   tab = '\xe2\x96\xb8 ', -- u25b8
   trail = '\xc2\xb7', -- u00b7
   extends = '\xc2\xbb', -- u00bb
   precedes = '\xc2\xab', -- u00ab
}
O.concealcursor = 'cnv'


-- Syntax, highlighting and spelling {{{1

O.background = 'dark'
O.synmaxcol = 500
O.hlsearch = true
O.termguicolors = true
O.colorcolumn = '+1'
OPT.spelloptions:append('camel')


-- Multiple windows {{{1

O.winminheight = 0
O.hidden = true
O.switchbuf = 'usetab'


-- Multiple tabpages {{{1

O.showtabline = 2


-- Terminal {{{1

O.title = false


-- Using the mouse {{{1

O.mouse = ''


-- Messages and info {{{1

OPT.shortmess:append('asIc')
O.showmode = false
O.report = 999
O.confirm = true


-- Selecting text {{{1

O.clipboard = 'unnamed'


-- Editing text {{{1

O.undofile = true
O.textwidth = 0
OPT.completeopt:remove('preview')
O.pumheight = 10
OPT.matchpairs:append('<:>')
O.joinspaces = false
OPT.nrformats:append('unsigned')


-- Tabs and indenting {{{1
-- Note: you should also set them for each file types.
--       These following settings are used for unknown file types.

O.tabstop = 4
O.shiftwidth = 4
O.softtabstop = 4
O.expandtab = true
O.autoindent = true
O.smartindent = true
O.copyindent = true
O.preserveindent = true


-- Folding {{{1

O.foldlevelstart = 0
OPT.foldopen:append('insert')
O.foldmethod = 'marker'


-- Diff mode {{{1

OPT.diffopt:append('vertical')
OPT.diffopt:append('foldcolumn:3')


-- Mapping {{{1

O.maxmapdepth = 10
O.timeout = false


-- Reading and writing files {{{1

O.fixendofline = false
O.fileformats = 'unix,dos'
O.backup = true
O.backupdir = my_env.backup_dir
O.autowrite = true


-- Command line editing {{{1

OPT.wildignore:append('*.o')
OPT.wildignore:append('*.obj')
OPT.wildignore:append('*.lib')
O.wildignorecase = true


-- Executing external commands {{{1

O.shell = 'fish'
O.keywordprg = ''


-- Encoding {{{1

O.fileencodings = 'utf-8,cp932,euc-jp'


-- Misc. {{{1

O.exrc = true
