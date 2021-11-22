--[==========================================================================[--
--                                                                            --
--                  _                __  _       _ _     _                    --
--       _ ____   _(_)_ __ ___      / / (_)_ __ (_) |_  | |_   _  __ _        --
--      | '_ \ \ / / | '_ ` _ \    / /  | | '_ \| | __| | | | | |/ _` |       --
--      | | | \ V /| | | | | | |  / /   | | | | | | |_ _| | |_| | (_| |       --
--      |_| |_|\_/ |_|_| |_| |_| /_/    |_|_| |_|_|\__(_)_|\__,_|\__,_|       --
--                                                                            --
--]==========================================================================]--



-- Global settings {{{1

-- Global constants {{{2

local my_env = {}

if vim.fn.has('unix') then
   my_env.os = 'unix'
elseif vim.fn.has('mac') then
   my_env.os = 'mac'
elseif vim.fn.has('wsl') then
   my_env.os = 'wsl'
elseif vim.fn.has('win32') or vim.fn.has('win64') then
   my_env.os = 'windows'
else
   my_env.os = 'unknown'
end

my_env.config_home = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. '/.config'
my_env.cache_home = vim.env.XDG_CACHE_HOME or vim.env.HOME .. '/.cache'
my_env.data_home = vim.env.XDG_DATA_HOME or vim.env.HOME .. '/.local/share'

my_env.config_dir = my_env.config_home .. '/nvim'
my_env.cache_dir = my_env.cache_home .. '/nvim'
my_env.data_dir = my_env.data_home .. '/nvim'

my_env.my_dir = my_env.config_dir .. '/my'
my_env.yankround_dir = my_env.data_dir .. '/yankround'
my_env.skk_dir = my_env.config_home .. '/skk'

for k, v in pairs(my_env) do
   if vim.endswith(k, '_dir') and not vim.fn.isdirectory(v) then
      vim.fn.mkdir(v, 'p')
   end
end




-- The autogroup used in .vimrc {{{2

vim.cmd([[
augroup Vimrc
   autocmd!
augroup END
]])


-- Note: |:autocmd| does not accept |-bar|.

local vimrc = {}
vimrc.autocmd_callbacks = {}
_G.vimrc = vimrc

function vimrc.autocmd(event, filter, callback)
   local callback_id = #vimrc.autocmd_callbacks + 1
   vimrc.autocmd_callbacks[callback_id] = callback
   vim.cmd(('autocmd Vimrc %s %s lua vimrc.autocmd_callbacks[%d]()'):format(
      event,
      filter,
      callback_id))
end



-- Language {{{2

-- Disable L10N.

vim.cmd('language messages C')
vim.cmd('language time C')





-- Options {{{1

-- * Use |:set|, not |:setglobal|.
--   |:setglobal| does not set local options, so options are not set in
--   the starting buffer you specified as commandline arguments like
--   "$ vim ~/.vimrc".

-- Moving around, searching and patterns {{{2

vim.o.wrapscan = false
vim.o.ignorecase = true
vim.o.smartcase = true



-- Displaying text {{{2

vim.o.scrolloff = 7
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.breakindentopt = vim.o.breakindentopt .. ',sbr'
vim.o.showbreak = '> '
vim.o.sidescrolloff = 20
vim.o.fillchars = 'stl: ,stlnc: ,vert: ,fold: ,diff: '
vim.o.cmdheight = 2
vim.o.list = true
-- \u00ac \xc2\xac
-- \u25b8 \xe2\x96\xb8
-- \u00b7 \xc2\xb7
-- \u00bb \xc2\xbb
-- \u00ab \xc2\xab
vim.o.listchars = 'eol:\xc2\xac,tab:\xe2\x96\xb8 ,trail:\xc2\xb7,extends:\xc2\xbb,precedes:\xc2\xab'
vim.o.concealcursor = 'cnv'



-- Syntax, highlighting and spelling {{{2

vim.o.background = 'dark'
vim.o.synmaxcol = 500
vim.o.hlsearch = true
-- Execute nohlsearch to avoid highlighting last searched pattern when reloading
-- .vimrc.
vim.cmd('nohlsearch')
vim.o.termguicolors = true
vim.o.colorcolumn = '+1'


-- Multiple windows {{{2

vim.o.winminheight = 0
vim.o.hidden = true
vim.o.switchbuf = 'usetab'



-- Multiple tabpages {{{2

vim.o.showtabline = 2



-- Terminal {{{2

vim.o.title = false



-- Using the mouse {{{2

vim.o.mouse = ''



-- Messages and info {{{2

vim.o.shortmess = vim.o.shortmess .. 'asIc'
vim.o.showmode = false
vim.o.report = 999
vim.o.confirm = true



-- Selecting text {{{2

vim.o.clipboard = 'unnamed'



-- Editing text {{{2

vim.o.undofile = true
vim.o.textwidth = 0
vim.cmd('set completeopt-=preview')
vim.o.pumheight = 10
vim.o.matchpairs = vim.o.matchpairs .. ',<:>'
vim.o.joinspaces = false
vim.o.nrformats = vim.o.nrformats .. ',unsigned'



-- Tabs and indenting {{{2
-- Note: you should also set them for each file types.
--       These following settings are global, used for unknown file types.

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.copyindent = true
vim.o.preserveindent = true



-- Folding {{{2

vim.o.foldlevelstart = 0
vim.o.foldopen = vim.o.foldopen .. ',insert'
vim.o.foldmethod = 'marker'



-- Diff mode {{{2

vim.o.diffopt = vim.o.diffopt .. ',vertical'
vim.o.diffopt = vim.o.diffopt .. ',foldcolumn:3'



-- Mapping {{{2

vim.o.maxmapdepth = 10
vim.o.timeout = false



-- Reading and writing files {{{2

vim.o.fixendofline = false
-- Note: if 'fileformat' is empty, the first item of 'fileformats' is used.
vim.o.fileformats = 'unix,dos'
-- Note: these settings make one backup. If you want more backups, see
--       |'backupext'|.
vim.o.backup = true
vim.o.autowrite = true



-- Command line editing {{{2
vim.o.wildignore = vim.o.wildignore .. ',*.o,*.obj,*.lib'
vim.o.wildignorecase = true



-- Executing external commands {{{2

vim.o.shell = 'zsh'
vim.o.keywordprg = ''



-- Encoding {{{2

-- Note: if 'fileencoding' is empty, 'encoding' is used.
vim.o.fileencodings = 'utf-8,cp932,euc-jp'



-- Misc. {{{2

vim.o.sessionoptions = vim.o.sessionoptions .. ',localoptions'
vim.o.sessionoptions = vim.o.sessionoptions .. ',resize'
vim.o.sessionoptions = vim.o.sessionoptions .. ',winpos'



-- Installed plugins {{{1

local paq = require('paq')
paq({
   -- Text editing {{{2
   -- IME {{{3
   -- SKK (Simple Kana to Kanji conversion program) for Vim.
   'vim-skk/eskk.vim',
   -- Operators {{{3
   -- Support for user-defined operators.
   'kana/vim-operator-user',
   -- Extract expression and make assingment statement.
   'tek/vim-operator-assign',
   -- Replace text without updating registers.
   'kana/vim-operator-replace',
   -- Reverse text.
   'tyru/operator-reverse.vim',
   -- Search in a specific region.
   'osyo-manga/vim-operator-search',
   -- Shiffle text.
   'pekepeke/vim-operator-shuffle',
   -- Sort text characterwise and linewise.
   'emonkak/vim-operator-sort',
   -- Super surround.
   'machakann/vim-sandwich',
   -- Non-operators {{{3
   -- Comment out.
   'tyru/caw.vim',
   -- Align text.
   'junegunn/vim-easy-align',
   -- Text objects {{{2
   -- Support for user-defined text objects.
   'kana/vim-textobj-user',
   -- Text object for blockwise.
   'osyo-manga/vim-textobj-blockwise',
   -- Text object for comment.
   'thinca/vim-textobj-comment',
   -- Text object for continuous line.
   'rhysd/vim-textobj-continuous-line',
   -- Text object for entire file.
   'kana/vim-textobj-entire',
   -- Text object for function.
   'kana/vim-textobj-function',
   -- Text object for indent.
   'kana/vim-textobj-indent',
   -- Text object for last inserted text.
   'rhysd/vim-textobj-lastinserted',
   -- Text object for last pasted text.
   'gilligan/textobj-lastpaste',
   -- Text object for last searched pattern.
   'kana/vim-textobj-lastpat',
   -- Text object for line.
   'kana/vim-textobj-line',
   -- Text object for parameter.
   'sgur/vim-textobj-parameter',
   -- Text object for space.
   'saihoooooooo/vim-textobj-space',
   -- Text object for syntax.
   'kana/vim-textobj-syntax',
   -- Text object for URL.
   'mattn/vim-textobj-url',
   -- Text object for words in words.
   'h1mesuke/textobj-wiw',
   -- Search {{{2
   -- Extend * and #.
   'haya14busa/vim-asterisk',
   -- Extend incremental search.
   'haya14busa/incsearch.vim',
   -- NOTE: it is a fork version of jremmen/vim-ripgrep
   -- Integration with ripgrep, fast alternative of grep command.
   'nsfisis/vim-ripgrep',
   -- Files {{{2
   -- Switch to related files.
   'kana/vim-altr',
   -- Fast Fuzzy Finder.
   'ctrlpvim/ctrlp.vim',
   -- CtrlP's matcher by builtin `matchfuzzy()`.
   'mattn/ctrlp-matchfuzzy',
   -- Filer for minimalists.
   'justinmk/vim-dirvish',
   -- Appearance {{{2
   -- Show highlight.
   'cocopon/colorswatch.vim',
   -- NOTE: it is a fork of godlygeek/csapprox
   -- Make gui-only color schemes 256colors-compatible.
   'nsfisis/csapprox',
   -- Makes folding text cool.
   'LeafCage/foldCC.vim',
   -- Show indent.
   'Yggdroot/indentLine',
   -- Highlight matched parentheses.
   'itchyny/vim-parenmatch',
   -- Highlight specified words.
   't9md/vim-quickhl',
   -- Filetypes {{{2
   -- Syntax {{{3
   -- HCL
   'b4b4r07/vim-hcl',
   -- JavaScript
   'pangloss/vim-javascript',
   -- JSON5
   'GutenYe/json5.vim',
   -- MoonScript
   'leafo/moonscript-vim',
   -- Nginx conf
   'chr4/nginx.vim',
   -- Rust
   'rust-lang/rust.vim',
   -- TOML
   'cespare/vim-toml',
   -- TypeScript
   'leafgarland/typescript-vim',
   -- Tools {{{3
   -- C/C++: clang-format
   'rhysd/vim-clang-format',
   -- Python: autopep8
   'tell-k/vim-autopep8',
   -- QoL {{{2
   -- If a directory is missing, make it automatically.
   'mopp/autodirmake.vim',
   -- Capture the output of a command.
   'tyru/capture.vim',
   -- Write git commit message.
   'rhysd/committia.vim',
   -- Motion on speed.
   'easymotion/vim-easymotion',
   -- Integration with EditorConfig (https://editorconfig.org)
   'editorconfig/editorconfig-vim',
   -- Extend J.
   'osyo-manga/vim-jplus',
   -- Improve behaviors of I, A and gI in Blockwise-Visual mode.
   'kana/vim-niceblock',
   -- Edit QuickFix and reflect to original buffers.
   'thinca/vim-qfreplace',
   -- Run anything.
   'thinca/vim-quickrun',
   -- Extend dot-repeat.
   'tpope/vim-repeat',
   -- Split one line format and Join multiline format.
   'AndrewRadev/splitjoin.vim',
   -- Introduce user-defined mode.
   'kana/vim-submode',
   -- Swap arguments.
   'machakann/vim-swap',
   -- Adjust window size.
   'rhysd/vim-window-adjuster',
   -- Remember yank history and paste them.
   'LeafCage/yankround.vim',
   -- }}}
})

vim.o.runtimepath = vim.o.runtimepath .. ',' .. my_env.my_dir


-- Utilities {{{1

function vimrc.hi(group, attributes)
   vim.cmd(('highlight! %s %s'):format(group, attributes))
end


function vimrc.hi_link(from, to)
   vim.cmd(('highlight! link %s %s'):format(from, to))
end


function vimrc.map(mode, lhs, rhs, opts)
   if opts == nil then
      opts = {}
   end
   if opts.noremap == nil then
      opts.noremap = true
   end
   vim.api.nvim_set_keymap(
      mode,
      lhs,
      rhs,
      opts)
end


vimrc.map_callbacks = {}

function vimrc.map_expr(mode, lhs, rhs, opts)
   if opts == nil then
      opts = {}
   end
   if opts.noremap == nil then
      opts.noremap = true
   end
   opts.expr = true
   local callback_id = #vimrc.map_callbacks + 1
   vimrc.map_callbacks[callback_id] = rhs
   vim.api.nvim_set_keymap(
      mode,
      lhs,
      ('v:lua.vimrc.map_callbacks[%d]()'):format(callback_id),
      opts)
end


function vimrc.map_cmd(mode, lhs, rhs, opts)
   if opts == nil then
      opts = {}
   end
   opts.noremap = true
   opts.silent = true
   vim.api.nvim_set_keymap(
      mode,
      lhs,
      (':<C-u>%s<CR>'):format(rhs),
      opts)
end


function vimrc.map_plug(mode, lhs, rhs, opts)
   if opts == nil then
      opts = {}
   end
   vim.api.nvim_set_keymap(
      mode,
      lhs,
      '<Plug>' .. rhs,
      opts)
end


-- Wrapper of |getchar()|.
function vimrc.getchar()
   local ch = vim.fn.getchar()
   while ch == "\\<CursorHold>" do
      ch = vim.fn.getchar()
   end
   return type(ch) == 'number' and vim.fn.nr2char(ch) or ch
end


-- Wrapper of |:echo| and |:echohl|.
function vimrc.echo(message, hl)
   if not hl then
      hl = 'None'
   end
   vim.cmd('redraw')
   vim.cmd('echohl ' .. hl)
   vim.cmd('echo "' .. message .. '"')
   vim.cmd('echohl None')
end


-- Wrapper of |getchar()|.
function vimrc.getchar_with_prompt(prompt)
   vimrc.echo(prompt, 'Question')
   return vimrc.getchar()
end


-- Wrapper of |input()|.
-- Only when it is used in a mapping, |inputsave()| and |inputstore()| are
-- required.
function vimrc.input(prompt)
   vim.fn.inputsave()
   local result = vim.fn.input(prompt)
   vim.fn.inputrestore()
   return result
end


function vimrc.term(s)
   return vim.api.nvim_replace_termcodes(s, true, true, true)
end



-- Autocommands {{{1

-- Auto-resize windows when Vim is resized.
vimrc.autocmd('VimResized', '*', function()
   vim.cmd('wincmd =')
end)


-- Calculate 'numberwidth' to fit file size.
-- Note: extra 2 is the room of left and right spaces.
vimrc.autocmd('BufEnter,WinEnter,BufWinEnter', '*', function()
   vim.wo.numberwidth = #tostring(vim.fn.line('$')) + 2
end)


-- Jump to the last cursor position when you open a file.
vimrc.autocmd('BufRead', '*', function()
   if 0 < vim.fn.line("'\"") and vim.fn.line("'\"") <= vim.fn.line('$') and
      not vim.o.filetype:match('commit') and not vim.o.filetype:match('rebase')
   then
      vim.cmd('normal g`"')
   end
end)



-- Mappings {{{1

-- Note: |:noremap| defines mappings in |Normal|, |Visual|, |Operator-Pending|
-- and |Select| mode. Because I don't use |Select| mode, I use |:noremap| as
-- substitute of |:nnoremap|, |:xnoremap| and |:onoremap| for simplicity.


-- Fix the search direction. {{{2

vimrc.map('', 'n', "v:searchforward ? 'n' : 'N'", { expr = true })
vimrc.map('', 'N', "v:searchforward ? 'N' : 'n'", { expr = true })

vimrc.map('', 'gn', "v:searchforward ? 'gn' : 'gN'", { expr = true })
vimrc.map('', 'gN', "v:searchforward ? 'gN' : 'gn'", { expr = true })



vimrc.map('n', '&', ':%&&<CR>', { silent = true })
vimrc.map('x', '&', ':%&&<CR>', { silent = true })



-- Registers and macros. {{{2


-- Access an resister in the same way in Insert and Commandline mode.
vimrc.map('n', '<C-r>', '"')
vimrc.map('x', '<C-r>', '"')



vimrc.map('n', '@j', 'j.')
vimrc.map('n', '@k', 'k.')
vimrc.map('n', '@n', 'n.')
vimrc.map('n', '@N', 'N.')

-- Repeat the last executed macro as many times as possible.
-- a => all
vimrc.map('n', '@a', '9999@@')
vimrc.map('n', '@a', '9999@@')


-- Execute the last executed macro again.
vimrc.map('n', '`', '@@')



-- Emacs like key mappings in Insert and CommandLine mode. {{{2

vimrc.map('i', '<C-d>', '<Del>')

-- Go elsewhere without deviding the undo history.
vimrc.map_expr('i', '<C-a>', function()
   local repeat_ = vim.fn['repeat']
   local line = vim.fn.getline('.')
   local cursor_col = vim.fn.col('.')
   local space_idx = vim.regex('^\\S'):match_str(line)

   if cursor_col == space_idx + 1 then
      return repeat_("\\<C-g>U\\<Left>", cursor_col - 1)
   else
      if cursor_col < space_idx then
         return repeat_("\\<C-g>U\\<Right>", space_idx - cursor_col + 1)
      else
         return repeat_("\\<C-g>U\\<Left>", cursor_col - 1 - space_idx)
      end
   end
end)
vimrc.map('i', '<C-e>', "repeat('<C-g>U<Right>', col('$') - col('.'))", { expr = true })
vimrc.map('i', '<C-b>', '<C-g>U<Left>')
vimrc.map('i', '<C-f>', '<C-g>U<Right>')

-- Delete something deviding the undo history.
vimrc.map('i', '<C-u>', '<C-g>u<C-u>')
vimrc.map('i', '<C-w>', '<C-g>u<C-w>')

vimrc.map('c', '<C-a>', '<Home>')
vimrc.map('c', '<C-e>', '<End>')
vimrc.map('c', '<C-f>', '<Right>')
vimrc.map('c', '<C-b>', '<Left>')
vimrc.map('c', '<C-n>', '<Down>')
vimrc.map('c', '<C-p>', '<Up>')
vimrc.map('c', '<C-d>', '<Del>')

vimrc.map('c', '<Left>', '<Nop>')
vimrc.map('i', '<Left>', '<Nop>')
vimrc.map('c', '<Right>', '<Nop>')
vimrc.map('i', '<Right>', '<Nop>')



vimrc.map_expr('n', 'gA', function()
   local line = vim.fn.getline('.')
   if vim.endswith(line, ';;') then -- for OCaml
      return 'A\\<C-g>U\\<Left>\\<C-g>U\\<Left>'
   elseif vim.regex('[,;)]$'):match_str(line) then
      return 'A\\<C-g>U\\<Left>'
   else
      return 'A'
   end
end)



-- QuickFix or location list. {{{2

vimrc.map_cmd('n', 'bb', 'cc')

vimrc.map('n', 'bn', ':<C-u><C-r>=v:count1<CR>cnext<CR>', { silent = true })
vimrc.map('n', 'bp', ':<C-u><C-r>=v:count1<CR>cprevious<CR>', { silent = true })

vimrc.map_cmd('n', 'bf', 'cfirst')
vimrc.map_cmd('n', 'bl', 'clast')

vimrc.map_cmd('n', 'bS', 'colder')
vimrc.map_cmd('n', 'bs', 'cnewer')



-- Operators {{{2

-- Throw deleted text into the black hole register ("_).
vimrc.map('n', 'c', '"_c')
vimrc.map('x', 'c', '"_c')
vimrc.map('n', 'C', '"_C')
vimrc.map('x', 'C', '"_C')


vimrc.map('', 'g=', '=')


vimrc.map('', 'ml', 'gu')
vimrc.map('', 'mu', 'gU')

vimrc.map('', 'gu', '<Nop>')
vimrc.map('', 'gU', '<Nop>')
vimrc.map('x', 'u', '<Nop>')
vimrc.map('x', 'U', '<Nop>')


vimrc.map('x', 'x', '"_x')


vimrc.map('n', 'Y', 'y$')
-- In Blockwise-Visual mode, select text linewise.
-- By default, select text characterwise, neither blockwise nor linewise.
vimrc.map('x', 'Y', "mode() ==# 'V' ? 'y' : 'Vy'", { expr = true })



-- Swap the keys entering Replace mode and Visual-Replace mode.
vimrc.map('n', 'R', 'gR')
vimrc.map('n', 'gR', 'R')
vimrc.map('n', 'r', 'gr')
vimrc.map('n', 'gr', 'r')


vimrc.map('n', 'U', '<C-r>')




-- Motions {{{2

vimrc.map('', 'H', '^')
vimrc.map('', 'L', '$')
vimrc.map('', 'M', '%')

vimrc.map('', 'gw', 'b')
vimrc.map('', 'gW', 'B')

vimrc.map('', 'k', 'gk')
vimrc.map('', 'j', 'gj')
vimrc.map('', 'gk', 'k')
vimrc.map('', 'gj', 'j')

vimrc.map('n', 'gff', 'gF')



-- Tabpages and windows. {{{2

vimrc.fn = {}

function vimrc.fn.move_current_window_to_tabpage()
   if vim.fn.winnr('$') == 1 then
      -- Leave the current window and open it in a new tabpage.
      -- Because :wincmd T fails when the current tabpage has only one window.
      vim.cmd('tab split')
   else
      -- Close the current window and re-open it in a new tabpage.
      vim.cmd('wincmd T')
   end
end


function vimrc.fn.bdelete_bang_with_confirm()
   if string.lower(vimrc.getchar_with_prompt('Delete? (y/n) ')) == 'y' then
      vim.cmd('bdelete!')
   else
      vimrc.echo('Canceled')
   end
end


function vimrc.fn.choose_window_interactively()
   local indicators = {
      'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ';',
      '1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
   }

   -- List normal windows up to 20.
   local wins = {}
   for winnr = 1, vim.fn.winnr('$') do
      if winnr ~= vim.fn.winnr() and vim.fn.win_gettype(winnr) == '' then
         wins[#wins+1] = vim.fn.win_getid(winnr)
      end
   end
   if #indicators < #wins then
      for i = #indicators+1, #wins do
         wins[i] = nil
      end
   end

   -- Handle special cases.
   if #wins == 0 then
      return
   end
   if #wins == 1 then
      if wins[1] == vim.fn.win_getid() then
         vim.fn.win_gotoid(wins[2])
      else
         vim.fn.win_gotoid(wins[1])
      end
      return
   end

   -- Show popups.
   local popups = {}
   for i = 1, #wins do
      local winid = wins[i]
      local indicator = indicators[i]
      local buf_id = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf_id, 0, -1, true, { '  ' .. indicator .. '  ' })
      local popup = vim.api.nvim_open_win(
         buf_id,
         false,
         {
            relative = 'win',
            win = winid,
            row = (vim.fn.winheight(winid) - 5) / 2,
            col = (vim.fn.winwidth(winid) - 9) / 2,
            width = 5,
            height = 1,
            focusable = false,
            style = 'minimal',
            border = 'solid',
            noautocmd = true,
         })
      popups[#popups+1] = {
         winid = popup,
         indicator = indicator,
         target_winid = winid,
      }
   end

   -- Prompt
   local result = vimrc.getchar_with_prompt('Select window: ')

   -- Jump
   local jump_target = -1
   for i, popup in ipairs(popups) do
      if string.upper(result) == popup.indicator then
         jump_target = popup.target_winid
      end
   end
   if jump_target ~= -1 then
      vim.fn.win_gotoid(jump_target)
   end

   -- Close popups
   for i, popup in ipairs(popups) do
      vim.api.nvim_win_close(popup.winid, true)
   end
end


vimrc.map('n', 'tt', ':<C-u>tabnew<CR>', { silent = true })
vimrc.map('n', 'tT', ':<C-u>call v:lua.vimrc.fn.move_current_window_to_tabpage()<CR>', { silent = true })

vimrc.map('n', 'tn', ":<C-u><C-r>=(tabpagenr() + v:count1 - 1) % tabpagenr('$') + 1<CR>tabnext<CR>", { silent = true })
vimrc.map('n', 'tp', ":<C-u><C-r>=(tabpagenr('$') * 10 + tabpagenr() - v:count1 - 1) % tabpagenr('$') + 1<CR>tabnext<CR>", { silent = true })

vimrc.map('n', 'tN', ':<C-u>tabmove +<CR>', { silent = true })
vimrc.map('n', 'tP', ':<C-u>tabmove -<CR>', { silent = true })

vimrc.map('n', 'tsh', ':<C-u>leftabove vsplit<CR>', { silent = true })
vimrc.map('n', 'tsj', ':<C-u>rightbelow split<CR>', { silent = true })
vimrc.map('n', 'tsk', ':<C-u>leftabove split<CR>', { silent = true })
vimrc.map('n', 'tsl', ':<C-u>rightbelow vsplit<CR>', { silent = true })

vimrc.map('n', 'tsH', ':<C-u>topleft vsplit<CR>', { silent = true })
vimrc.map('n', 'tsJ', ':<C-u>botright split<CR>', { silent = true })
vimrc.map('n', 'tsK', ':<C-u>topleft split<CR>', { silent = true })
vimrc.map('n', 'tsL', ':<C-u>botright vsplit<CR>', { silent = true })

vimrc.map('n', 'twh', ':<C-u>leftabove vnew<CR>', { silent = true })
vimrc.map('n', 'twj', ':<C-u>rightbelow new<CR>', { silent = true })
vimrc.map('n', 'twk', ':<C-u>leftabove new<CR>', { silent = true })
vimrc.map('n', 'twl', ':<C-u>rightbelow vnew<CR>', { silent = true })

vimrc.map('n', 'twH', ':<C-u>topleft vnew<CR>', { silent = true })
vimrc.map('n', 'twJ', ':<C-u>botright new<CR>', { silent = true })
vimrc.map('n', 'twK', ':<C-u>topleft new<CR>', { silent = true })
vimrc.map('n', 'twL', ':<C-u>botright vnew<CR>', { silent = true })

vimrc.map('n', 'th', '<C-w>h')
vimrc.map('n', 'tj', '<C-w>j')
vimrc.map('n', 'tk', '<C-w>k')
vimrc.map('n', 'tl', '<C-w>l')

vimrc.map('n', 'tH', '<C-w>H')
vimrc.map('n', 'tJ', '<C-w>J')
vimrc.map('n', 'tK', '<C-w>K')
vimrc.map('n', 'tL', '<C-w>L')

vimrc.map('n', 'tx', '<C-w>x')

-- r => manual resize.
-- R => automatic resize.
vimrc.map('n', 'tRH', '<C-w>_')
vimrc.map('n', 'tRW', '<C-w><Bar>')
vimrc.map('n', 'tRR', '<C-w>_<C-w><Bar>')

vimrc.map('n', 't=', '<C-w>=')

vimrc.map('n', 'tq', ':<C-u>bdelete<CR>', { silent = true })
vimrc.map('n', 'tQ', ':<C-u>call v:lua.vimrc.fn.bdelete_bang_with_confirm()<CR>', { silent = true })

vimrc.map('n', 'tc', '<C-w>c')

vimrc.map('n', 'to', '<C-w>o')
vimrc.map('n', 'tO', ':<C-u>tabonly<CR>', { silent = true })

vimrc.map('n', 'tg', ':<C-u>call v:lua.vimrc.fn.choose_window_interactively()<CR>', { silent = true })



function vimrc.fn.smart_open(command)
   local modifiers
   if vim.fn.winwidth(vim.fn.winnr()) < 150 then
      modifiers = 'topleft'
   else
      modifiers = 'vertical botright'
   end

   vim.cmd(([[
   try
      %s %s
      let g:__ok = v:true
   catch
      echohl Error
      echo v:exception
      echohl None
      let g:__ok = v:false
   endtry
   ]]):format(modifiers, command))
   if not vim.g.__ok then
      return
   end

   if vim.o.filetype == 'help' then
      if vim.bo.textwidth > 0 then
         vim.cmd(('vertical resize %d'):format(vim.bo.textwidth))
      end
      -- Move the cursor to the beginning of the line as help tags are often
      -- right-justfied.
      vim.fn.cursor(
         0 --[[ stay in the current line ]],
         1 --[[ move to the beginning of the line ]])
   end
end


vim.cmd([[
command! -nargs=+ -complete=command
   \ SmartOpen
   \ call v:lua.vimrc.fn.smart_open(<q-args>)
]])




-- Increment/decrement numbers {{{2

-- nnoremap  +  <C-a>
-- nnoremap  -  <C-x>
-- xnoremap  +  <C-a>
-- xnoremap  -  <C-x>
-- xnoremap  g+  g<C-a>
-- xnoremap  g-  g<C-x>



-- Disable unuseful or dangerous mappings. {{{2

-- Disable Select mode.
vimrc.map('n', 'gh', '<Nop>')
vimrc.map('n', 'gH', '<Nop>')
vimrc.map('n', 'g<C-h>', '<Nop>')

-- Disable Ex mode.
vimrc.map('n', 'Q', '<Nop>')
vimrc.map('n', 'gQ', '<Nop>')

vimrc.map('n', 'ZZ', '<Nop>')
vimrc.map('n', 'ZQ', '<Nop>')


-- Help {{{2

-- Search help.
vimrc.map('n', '<C-h>', ':<C-u>SmartOpen help<Space>')



-- For writing Vim script. {{{2

vimrc.map('n', 'XV', ':<C-u>tabedit $MYVIMRC<CR>', { silent = true })

-- See |numbered-function|.
vimrc.map('n', 'XF', ':<C-u>function {<C-r>=v:count<CR>}<CR>', { silent = true })

vimrc.map('n', 'XM', ':<C-u>messages<CR>', { silent = true })




-- Misc. {{{2

vimrc.map('o', 'gv', ':<C-u>normal! gv<CR>', { silent = true })

-- Swap : and ;.
vimrc.map('n', ';', ':')
vimrc.map('n', ':', ';')
vimrc.map('x', ';', ':')
vimrc.map('x', ':', ';')
vimrc.map('n', '@;', '@:')
vimrc.map('x', '@;', '@:')
vimrc.map('!', '<C-r>;', '<C-r>:')


-- Since <ESC> may be mapped to something else somewhere, it should be :map, not
-- :noremap.
vimrc.map('!', 'jk', '<ESC>', { noremap = false })



vimrc.map('n', '<C-c>', ':<C-u>nohlsearch<CR>', { silent = true })



function vimrc.map_callbacks.insert_blank_line(offset)
   for i = 1, vim.v.count1 do
      vim.fn.append(vim.fn.line('.') - offset, '')
   end
end

vimrc.map('n', '<Plug>(my-insert-blank-lines-after)',
   'call v:lua.vimrc.map_callbacks.insert_blank_line(0)')
vimrc.map('n', '<Plug>(my-insert-blank-lines-before)',
   'call v:lua.vimrc.map_callbacks.insert_blank_line(1)')

vimrc.map_plug('n', 'go', '(my-insert-blank-lines-after)')
vimrc.map_plug('n', 'gO', '(my-insert-blank-lines-before)')


vimrc.map('n', '<Space>w', ':<C-u>write<CR>', { silent = true })


-- Abbreviations {{{1

vim.cmd('inoreabbrev retrun return')
vim.cmd('inoreabbrev reutrn return')
vim.cmd('inoreabbrev tihs this')



-- Commands {{{1

-- Reverse a selected range in line-wise.
-- Note: directly calling `g/^/m` will overwrite the current search pattern with
-- '^' and highlight it, which is not expected.
-- :h :keeppatterns
vim.cmd([[
command! -bar -range=%
   \ Reverse
   \ keeppatterns <line1>,<line2>g/^/m<line1>-1
]])



-- ftplugin {{{1

-- This command do the followings:
--     * Execute |:setlocal| for each options.
--     * Set information to restore the original setting to b:|undo_ftplugin|.

-- This command is used in my/ftplugin/*.vim.

-- Note: specify only single option.

vim.cmd([[
function My_ftplugin_setlocal(qargs)
   execute 'setlocal' a:qargs

   let option_name = substitute(a:qargs, '\L.*', '', '')

   if option_name ==# 'shiftwidth' && exists(':IndentLinesReset') ==# 2
      IndentLinesReset
   end

   if exists('b:undo_ftplugin')
      let b:undo_ftplugin .= '|setlocal ' .. option_name .. '<'
   else
      let b:undo_ftplugin = 'setlocal ' .. option_name .. '<'
   end
endfunction
]])

vim.cmd([[
command! -nargs=+
   \ FtpluginSetLocal
   \ call My_ftplugin_setlocal(<q-args>)
]])




-- Appearance {{{1

-- Color scheme {{{2

vim.cmd([[
try
    colorscheme ocean
catch
    " Loading colorscheme failed.
    " The color scheme, "desert", is one of the built-in ones. Probably, it
    " will be loaded without any errors.
    colorscheme desert
endtry
]])



-- Statusline {{{2

vim.o.statusline = '%!v:lua.vimrc.statusline.build()'

vimrc.statusline = {}

function vimrc.statusline.build()
   local winid = vim.g.statusline_winid
   local bufnr = vim.fn.winbufnr(winid)
   local is_active = winid == vim.fn.win_getid()
   if is_active then
      local mode, mode_hl = vimrc.statusline.mode()
      local ro = vimrc.statusline.readonly(bufnr)
      local fname = vimrc.statusline.filename(bufnr)
      local mod = vimrc.statusline.modified(bufnr)
      local linenum = vimrc.statusline.linenum(winid)
      local fenc = vimrc.statusline.fenc_ff(bufnr)
      local ft = vimrc.statusline.filetype(bufnr)
      return string.format(
         '%%#statusLineMode%s# %s %%#statusLineLeft# %s%s%s %%#StatusLine#%%=%%#statusLineRight# %s | %s | %s ',
         mode_hl,
         mode,
         ro and ro .. ' ' or '',
         fname,
         mod and ' ' .. mod or '',
         linenum,
         fenc,
         ft)
   else
      local ro = vimrc.statusline.readonly(bufnr)
      local fname = vimrc.statusline.filename(bufnr)
      local mod = vimrc.statusline.modified(bufnr)
      local linenum = vimrc.statusline.linenum(winid)
      local fenc = vimrc.statusline.fenc_ff(bufnr)
      local ft = vimrc.statusline.filetype(bufnr)
      return string.format(
         '%%#statusLineLeft# %s%s%s %%#StatusLine#%%=%%#statusLineRight# %s | %s | %s ',
         ro and ro .. ' ' or '',
         fname,
         mod and ' ' .. mod or '',
         linenum,
         fenc,
         ft)
   end
end

function vimrc.statusline.mode()
   local mode_map = {
      n                       = { 'N',  'Normal'   },
      no                      = { 'O',  'Operator' },
      nov                     = { 'Oc', 'Operator' },
      noV                     = { 'Ol', 'Operator' },
      [vimrc.term('no<C-v>')] = { 'Ob', 'Operator' },
      niI                     = { 'In', 'Insert'   },
      niR                     = { 'Rn', 'Replace'  },
      niV                     = { 'Rn', 'Replace'  },
      v                       = { 'V',  'Visual'   },
      V                       = { 'Vl', 'Visual'   },
      [vimrc.term('<C-v>')]   = { 'Vb', 'Visual'   },
      s                       = { 'S',  'Visual'   },
      S                       = { 'Sl', 'Visual'   },
      [vimrc.term('<C-s>')]   = { 'Sb', 'Visual'   },
      i                       = { 'I',  'Insert'   },
      ic                      = { 'I?', 'Insert'   },
      ix                      = { 'I?', 'Insert'   },
      R                       = { 'R',  'Replace'  },
      Rc                      = { 'R?', 'Replace'  },
      Rv                      = { 'R',  'Replace'  },
      Rx                      = { 'R?', 'Replace'  },
      c                       = { 'C',  'Command'  },
      cv                      = { 'C',  'Command'  },
      ce                      = { 'C',  'Command'  },
      r                       = { '-',  'Other'    },
      rm                      = { '-',  'Other'    },
      ['r?']                  = { '-',  'Other'    },
      ['!']                   = { '-',  'Other'    },
      t                       = { 'T',  'Terminal' },
   }
   local vim_mode_and_hl = mode_map[vim.fn.mode(true)] or { '-', 'Other' }
   local vim_mode = vim_mode_and_hl[1]
   local hl = vim_mode_and_hl[2]

   -- Calling `eskk#statusline()` makes Vim autoload eskk. If you call it
   -- without checking `g:loaded_autoload_eskk`, eskk is loaded on an early
   -- stage of the initialization (probably the first rendering of status line),
   -- which slows down Vim startup. Loading eskk can be delayed by checking both
   -- of `g:loaded_eskk` and `g:loaded_autoload_eskk`.
   local skk_mode
   if vim.g.loaded_eskk and vim.g.loaded_autoload_eskk then
      skk_mode = vim.fn['eskk#statusline'](' (%s)', '')
   else
      skk_mode = ''
   end

   return vim_mode .. skk_mode, hl
end

function vimrc.statusline.readonly(bufnr)
   local ro = vim.fn.getbufvar(bufnr, '&readonly')
   if ro == 1 then
      return '[RO]'
   else
      return nil
   end
end

function vimrc.statusline.filename(bufnr)
   local name = vim.fn.bufname(bufnr)
   if name == '' then
      return '[No Name]'
   else
      return name
   end
end

function vimrc.statusline.modified(bufnr)
   local mod = vim.fn.getbufvar(bufnr, '&modified')
   local ma = vim.fn.getbufvar(bufnr, '&modifiable')
   if mod == 1 then
      return '[+]'
   elseif ma == 0 then
      return '[-]'
   else
      return nil
   end
end

function vimrc.statusline.linenum(winid)
   return vim.fn.line('.', winid) .. '/' .. vim.fn.line('$', winid)
end

function vimrc.statusline.fenc_ff(bufnr)
   local fenc = vim.fn.getbufvar(bufnr, '&fileencoding')
   local ff = vim.fn.getbufvar(bufnr, '&fileformat')
   local bom = vim.fn.getbufvar(bufnr, '&bomb')  -- BOMB!!

   if fenc == '' then
      local fencs = vim.fn.split(vim.o.fileencodings, ',')
      fenc = fencs[1] or vim.o.encoding
   elseif fenc == 'utf-8' then
      fenc = bom and 'U8[BOM]' or 'U8'
   elseif fenc == 'utf-16' then
      fenc = 'U16[BE]'
   elseif fenc == 'utf-16le' then
      fenc = 'U16[LE]'
   elseif fenc == 'ucs-4' then
      fenc = 'U32[BE]'
   elseif fenc == 'ucs-4le' then
      fenc = 'U32[LE]'
   else
      fenc = fenc:upper()
   end

   if ff == 'unix' then
      ff = ''
   elseif ff == 'dos' then
      ff = ' (CRLF)'
   elseif ff == 'mac' then
      ff = ' (CR)'
   else
      ff = ' (Unknown)'
   end

   return fenc .. ff
end

function vimrc.statusline.filetype(bufnr)
   local ft = vim.fn.getbufvar(bufnr, '&filetype')
   if ft == '' then
      return '[None]'
   else
      return ft
   end
end
-- Plugins configuration {{{1

-- Disable standard plugins. {{{2

vim.g.loaded_gzip             = 1
vim.g.loaded_matchparen       = 1
vim.g.loaded_netrw            = 1
vim.g.loaded_netrwPlugin      = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tarPlugin        = 1
vim.g.loaded_zipPlugin        = 1



-- altr {{{2

-- C/C++
vim.fn['altr#define']('%.c', '%.cpp', '%.cc', '%.h', '%.hh', '%.hpp')
-- Vim
vim.fn['altr#define']('autoload/%.vim', 'doc/%.txt', 'plugin/%.vim')

-- Go to File Alternative
vimrc.map_plug('n', 'gfa', '(altr-forward)')




-- asterisk {{{2

vim.cmd([[
function My_asterisk(ret, keeppos)
   let g:asterisk#keeppos = a:keeppos
   return a:ret
endfunction
]])

-- Do not keep the relative cursor position.
vim.cmd([[
nmap <expr>  *  My_asterisk('<Plug>(asterisk-z*)', 0)
omap <expr>  *  My_asterisk('<Plug>(asterisk-z*)', 0)
xmap <expr>  *  My_asterisk('<Plug>(asterisk-z*)', 0)
nmap <expr>  g*  My_asterisk('<Plug>(asterisk-gz*)', 0)
omap <expr>  g*  My_asterisk('<Plug>(asterisk-gz*)', 0)
xmap <expr>  g*  My_asterisk('<Plug>(asterisk-gz*)', 0)
]])

-- Keep the relative cursor position (use offset like /s+1).
-- Note: I fix the search direction in typing 'n' and 'N', so there is no
-- difference between '*' and '#'.
vim.cmd([[
nmap <expr>  #  My_asterisk('<Plug>(asterisk-z*)', 1)
omap <expr>  #  My_asterisk('<Plug>(asterisk-z*)', 1)
xmap <expr>  #  My_asterisk('<Plug>(asterisk-z*)', 1)
nmap <expr>  g#  My_asterisk('<Plug>(asterisk-gz*)', 1)
omap <expr>  g#  My_asterisk('<Plug>(asterisk-gz*)', 1)
xmap <expr>  g#  My_asterisk('<Plug>(asterisk-gz*)', 1)
]])



-- autodirmake {{{2

vim.g['autodirmake#msg_highlight'] = 'Question'



-- autopep8 {{{2

vim.g.autopep8_on_save = true
vim.g.autopep8_disable_show_diff = true

vim.cmd([[
command!
   \ Autopep8Disable
   \ let g:autopep8_on_save = 0
]])



-- caw {{{2

vim.g.caw_no_default_keymappings = true

vimrc.map_plug('n', 'm//', '(caw:hatpos:toggle)')
vimrc.map_plug('x', 'm//', '(caw:hatpos:toggle)')
vimrc.map_plug('n', 'm/w', '(caw:wrap:comment)')
vimrc.map_plug('x', 'm/w', '(caw:wrap:comment)')
vimrc.map_plug('n', 'm/W', '(caw:wrap:uncomment)')
vimrc.map_plug('x', 'm/W', '(caw:wrap:uncomment)')
vimrc.map_plug('n', 'm/b', '(caw:box:comment)')
vimrc.map_plug('x', 'm/b', '(caw:box:comment)')



-- clang-format {{{2

vim.g['clang_format#auto_format'] = true

vimrc.autocmd('FileType', 'javascript,typescript', function()
   vim.cmd('ClangFormatAutoDisable')
end)



-- ctrlp {{{2

vim.g.ctrlp_map = '<Space>f'
vim.g.ctrlp_match_func = { match = 'ctrlp_matchfuzzy#matcher' }



-- dirvish {{{2

-- Prevent dirvish from mapping hyphen key to "<Plug>(dirvish_up)".
-- nmap  <Plug>(nomap-dirvish_up)  <Plug>(dirvish_up)



-- easyalign {{{2

vimrc.map_plug('n', '=', '(EasyAlign)')
vimrc.map_plug('x', '=', '(EasyAlign)')



-- easymotion {{{2

vim.g.EasyMotion_keys = 'asdfghweryuiocvbnmjkl;'
vim.g.EasyMotion_space_jump_first = true
vim.g.EasyMotion_do_shade = false
vim.g.EasyMotion_do_mappings = false
vim.g.EasyMotion_smartcase = true
vim.g.EasyMotion_verbose = false
vim.g.EasyMotion_startofline = false

vimrc.map_plug('n', 'f', '(easymotion-fl)')
vimrc.map_plug('o', 'f', '(easymotion-fl)')
vimrc.map_plug('x', 'f', '(easymotion-fl)')
vimrc.map_plug('n', 'F', '(easymotion-Fl)')
vimrc.map_plug('o', 'F', '(easymotion-Fl)')
vimrc.map_plug('x', 'F', '(easymotion-Fl)')
vimrc.map_plug('o', 't', '(easymotion-tl)')
vimrc.map_plug('x', 't', '(easymotion-tl)')
vimrc.map_plug('o', 'T', '(easymotion-Tl)')
vimrc.map_plug('x', 'T', '(easymotion-Tl)')

-- Note: Don't use the following key sequences! It is used 'vim-sandwich'.
--  * sa
--  * sd
--  * sr
vimrc.map_plug('n', 'ss', '(easymotion-s2)')
vimrc.map_plug('o', 'ss', '(easymotion-s2)')
vimrc.map_plug('x', 'ss', '(easymotion-s2)')
vimrc.map_plug('n', 'sw', '(easymotion-bd-w)')
vimrc.map_plug('o', 'sw', '(easymotion-bd-w)')
vimrc.map_plug('x', 'sw', '(easymotion-bd-w)')
vimrc.map_plug('n', 'sn', '(easymotion-n)')
vimrc.map_plug('o', 'sn', '(easymotion-n)')
vimrc.map_plug('x', 'sn', '(easymotion-n)')
vimrc.map_plug('n', 'sN', '(easymotion-N)')
vimrc.map_plug('o', 'sN', '(easymotion-N)')
vimrc.map_plug('x', 'sN', '(easymotion-N)')
vimrc.map_plug('n', 'sj', '(easymotion-j)')
vimrc.map_plug('o', 'sj', '(easymotion-j)')
vimrc.map_plug('x', 'sj', '(easymotion-j)')
vimrc.map_plug('n', 'sk', '(easymotion-k)')
vimrc.map_plug('o', 'sk', '(easymotion-k)')
vimrc.map_plug('x', 'sk', '(easymotion-k)')



-- eskk {{{2

vim.g['eskk#dictionary'] = {
   path = my_env.skk_dir .. '/jisyo',
   sorted = false,
   encoding = 'utf-8',
}

vim.g['eskk#large_dictionary'] = {
   path = my_env.skk_dir .. '/jisyo.L',
   sorted = true,
   encoding = 'euc-jp',
}

vim.g['eskk#backup_dictionary'] = vim.g['eskk#dictionary'].path .. ".bak"

vim.g['eskk#kakutei_when_unique_candidate'] = true
vim.g['eskk#enable_completion'] = false
vim.g['eskk#egg_like_newline'] = true

-- Change default markers because they are EAW (East Asian Width) characters.
vim.g['eskk#marker_henkan'] = '[!]'
vim.g['eskk#marker_okuri'] = '-'
vim.g['eskk#marker_henkan_select'] = '[#]'
vim.g['eskk#marker_jisyo_touroku'] = '[?]'



vim.cmd([[
function My_eskk_initialize_pre()
   let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
   call t.add_map('z ', '　')
   call t.add_map('0.', '0.')
   call t.add_map('1.', '1.')
   call t.add_map('2.', '2.')
   call t.add_map('3.', '3.')
   call t.add_map('4.', '4.')
   call t.add_map('5.', '5.')
   call t.add_map('6.', '6.')
   call t.add_map('7.', '7.')
   call t.add_map('8.', '8.')
   call t.add_map('9.', '9.')
   call eskk#register_mode_table('hira', t)
endfunction


autocmd Vimrc User eskk-initialize-pre call My_eskk_initialize_pre()


function My_eskk_initialize_post()
   " I don't use hankata mode for now.
   EskkUnmap -type=mode:hira:toggle-hankata
   EskkUnmap -type=mode:kata:toggle-hankata

   " I don't use abbrev mode for now.
   EskkUnmap -type=mode:hira:to-abbrev
   EskkUnmap -type=mode:kata:to-abbrev

   " I don't use ascii mode for now.
   EskkUnmap -type=mode:hira:to-ascii
   EskkUnmap -type=mode:kata:to-ascii

   " Instead, l key disable SKK input.
   EskkMap -type=disable l
   EskkMap -type=disable l

   " Custom highlight for henkan markers.
   syntax match skkMarker '\[[!#?]\]'
   hi link skkMarker Special
endfunction


autocmd Vimrc User eskk-initialize-post call My_eskk_initialize_post()
]])



-- foldcc {{{2

vim.o.foldtext = 'FoldCCtext()'
vim.g.foldCCtext_head = 'repeat(">", v:foldlevel) . " "'



-- incsearch {{{2

vimrc.map_plug('n', '/', '(incsearch-forward)')
vimrc.map_plug('o', '/', '(incsearch-forward)')
vimrc.map_plug('x', '/', '(incsearch-forward)')
vimrc.map_plug('n', '?', '(incsearch-backward)')
vimrc.map_plug('o', '?', '(incsearch-backward)')
vimrc.map_plug('x', '?', '(incsearch-backward)')
vimrc.map_plug('n', 'g/', '(incsearch-stay)')
vimrc.map_plug('o', 'g/', '(incsearch-stay)')
vimrc.map_plug('x', 'g/', '(incsearch-stay)')



-- indentline {{{2

vim.g.indentLine_conceallevel = 1
vim.g.indentLine_fileTypeExclude = { 'help' }



-- jplus {{{2

vim.g['jplus#input_config'] = {
   __DEFAULT__ = { delimiter_format = ' %d ' },
   __EMPTY__ = { delimiter_format = '' },
   [' '] = { delimiter_format = ' ' },
   [','] = { delimiter_format = '%d ' },
   [';'] = { delimiter_format = '%d ' },
   l = { delimiter_format = '' },
   L = { delimiter_format = '' },
}

vimrc.map_plug('n', 'J', '(jplus-getchar)')
vimrc.map_plug('x', 'J', '(jplus-getchar)')
vimrc.map_plug('n', 'gJ', '(jplus-input)')
vimrc.map_plug('x', 'gJ', '(jplus-input)')



-- vim-lsp {{{2

-- TODO



-- niceblock {{{2

vimrc.map_plug('x', 'I', '(niceblock-I)')
vimrc.map_plug('x', 'gI', '(niceblock-gI)')
vimrc.map_plug('x', 'A', '(niceblock-A)')






-- operator-replace {{{2

vimrc.map_plug('n', '<C-p>', '(operator-replace)')
vimrc.map_plug('o', '<C-p>', '(operator-replace)')
vimrc.map_plug('x', '<C-p>', '(operator-replace)')



-- operator-search {{{2

-- Note: m/ is the prefix of comment out.
vimrc.map_plug('n', 'm?', '(operator-search)')
vimrc.map_plug('o', 'm?', '(operator-search)')
vimrc.map_plug('x', 'm?', '(operator-search)')



-- qfreplace {{{2

vimrc.map('n', 'br', ':<C-u>Qfreplace SmartOpen<CR>', { silent = true })



-- quickhl {{{2

-- TODO: CUI
vim.g.quickhl_manual_colors = {
   'guifg=#101020 guibg=#8080c0 gui=bold',
   'guifg=#101020 guibg=#80c080 gui=bold',
   'guifg=#101020 guibg=#c08080 gui=bold',
   'guifg=#101020 guibg=#80c0c0 gui=bold',
   'guifg=#101020 guibg=#c0c080 gui=bold',
   'guifg=#101020 guibg=#a0a0ff gui=bold',
   'guifg=#101020 guibg=#a0ffa0 gui=bold',
   'guifg=#101020 guibg=#ffa0a0 gui=bold',
   'guifg=#101020 guibg=#a0ffff gui=bold',
   'guifg=#101020 guibg=#ffffa0 gui=bold',
}

vimrc.map_plug('n', '"', '(quickhl-manual-this)')
vimrc.map_plug('x', '"', '(quickhl-manual-this)')
vimrc.map('n', '<C-c>', ':<C-u>nohlsearch <Bar> QuickhlManualReset<CR>', { silent = true })



-- quickrun {{{2

vim.g.quickrun_no_default_key_mappings = true

vim.g.quickrun_config = {
   cpp = {
      cmdopt = '--std=c++17 -Wall -Wextra',
   },
   d = {
      exec = 'dub run',
   },
   haskell = {
      exec = {'stack build', 'stack exec %{matchstr(globpath(".,..,../..,../../..", "*.cabal"), "\\w\\+\\ze\\.cabal")}'},
   },
   python = {
      command = 'python3',
   },
}


vimrc.map_plug('n', 'BB', '(quickrun)')
vimrc.map_plug('x', 'BB', '(quickrun)')




-- repeat {{{2

vimrc.map_plug('n', 'U', '(RepeatRedo)')
-- Autoload vim-repeat immediately in order to make <Plug>(RepeatRedo) available.
-- repeat#setreg() does nothing here.
vim.fn['repeat#setreg']('', '')


-- Make them repeatable with vim-repeat.
vim.cmd([[
nnoremap <silent>  <Plug>(my-insert-blank-lines-after)
   \ :<C-u>call v:lua.vimrc.map_callbacks.insert_blank_line(0)<Bar>
   \ silent! call repeat#set("\<Lt>Plug>(my-insert-blank-lines-after)")<CR>
nnoremap <silent>  <Plug>(my-insert-blank-lines-before)
   \ :<C-u>call v:lua.vimrc.map_callbacks.insert_blank_line(1)<Bar>
   \ silent! call repeat#set("\<Lt>Plug>(my-insert-blank-lines-before)")<CR>
]])



-- ripgrep {{{2

-- Workaround: do not open quickfix window.
-- exe g:rg_window_location 'copen'
vim.g.rg_window_location = 'silent! echo'
vim.g.rg_jump_to_first = true

vim.cmd([[
command! -bang -nargs=* -complete=file -bar
   \ RG
   \ Rg<bang> <args>
]])


-- rust {{{2

vim.g.rustfmt_autosave = true




-- sandwich {{{2

vim.fn['operator#sandwich#set']('add', 'all', 'highlight', 2)
vim.fn['operator#sandwich#set']('delete', 'all', 'highlight', 0)
vim.fn['operator#sandwich#set']('replace', 'all', 'highlight', 2)





-- splitjoin {{{2

-- Note: Don't use J{any sign}, 'Jl' and 'JL'. They will conflict with 'vim-jplus'.
vim.g.splitjoin_split_mapping = ''
vim.g.splitjoin_join_mapping = ''

vimrc.map('n', 'JS', ':<C-u>SplitjoinSplit<CR>', { silent = true })
vimrc.map('n', 'JJ', ':<C-u>SplitjoinJoin<CR>', { silent = true })



-- submode {{{2

-- Global settings {{{3
vim.g.submode_always_show_submode = true
vim.g.submode_keyseqs_to_leave = { '<C-c>', '<ESC>' }
vim.g.submode_keep_leaving_key = true


-- yankround {{{3
vim.fn['submode#enter_with']('YankRound', 'nv', 'rs', 'gp', '<Plug>(yankround-p)')
vim.fn['submode#enter_with']('YankRound', 'nv', 'rs', 'gP', '<Plug>(yankround-P)')
vim.fn['submode#map']('YankRound', 'nv', 'rs', 'p', '<Plug>(yankround-prev)')
vim.fn['submode#map']('YankRound', 'nv', 'rs', 'P', '<Plug>(yankround-next)')

-- swap {{{3
vim.fn['submode#enter_with']('Swap', 'n', 'r', 'g>', '<Plug>(swap-next)')
vim.fn['submode#map']('Swap', 'n', 'r', '<', '<Plug>(swap-prev)')
vim.fn['submode#enter_with']('Swap', 'n', 'r', 'g<', '<Plug>(swap-prev)')
vim.fn['submode#map']('Swap', 'n', 'r', '>', '<Plug>(swap-next)')

-- Resizing a window (height) {{{3
vim.fn['submode#enter_with']('WinResizeH', 'n', '', 'trh')
vim.fn['submode#enter_with']('WinResizeH', 'n', '', 'trh')
vim.fn['submode#map']('WinResizeH', 'n', '', '+', '<C-w>+')
vim.fn['submode#map']('WinResizeH', 'n', '', '-', '<C-w>-')

-- Resizing a window (width) {{{3
vim.fn['submode#enter_with']('WinResizeW', 'n', '', 'trw')
vim.fn['submode#enter_with']('WinResizeW', 'n', '', 'trw')
vim.fn['submode#map']('WinResizeW', 'n', '', '+', '<C-w>>')
vim.fn['submode#map']('WinResizeW', 'n', '', '-', '<C-w><Lt>')

-- Super undo/redo {{{3
vim.fn['submode#enter_with']('Undo/Redo', 'n', '', 'gu', 'g-')
vim.fn['submode#map']('Undo/Redo', 'n', '', 'u', 'g-')
vim.fn['submode#enter_with']('Undo/Redo', 'n', '', 'gU', 'g+')
vim.fn['submode#map']('Undo/Redo', 'n', '', 'U', 'g+')



-- swap {{{2

vim.g.swap_no_default_key_mappings = true



-- textobj-continuousline {{{2

vim.g.textobj_continuous_line_no_default_key_mappings = true

vimrc.map_plug('o', 'aL', '(textobj-continuous-cpp-a)')
vimrc.map_plug('x', 'aL', '(textobj-continuous-cpp-a)')
vimrc.map_plug('o', 'iL', '(textobj-continuous-cpp-i)')
vimrc.map_plug('x', 'iL', '(textobj-continuous-cpp-i)')

vim.cmd([[
autocmd Vimrc FileType vim omap <buffer>  aL  <Plug>(textobj-continuous-vim-a)
autocmd Vimrc FileType vim xmap <buffer>  aL  <Plug>(textobj-continuous-vim-a)
autocmd Vimrc FileType vim omap <buffer>  iL  <Plug>(textobj-continuous-vim-i)
autocmd Vimrc FileType vim xmap <buffer>  iL  <Plug>(textobj-continuous-vim-i)
]])



-- textobj-lastpaste {{{2

vim.g.textobj_lastpaste_no_default_key_mappings = true

vimrc.map_plug('o', 'iP', '(textobj-lastpaste-i)')
vimrc.map_plug('x', 'iP', '(textobj-lastpaste-i)')
vimrc.map_plug('o', 'aP', '(textobj-lastpaste-a)')
vimrc.map_plug('x', 'aP', '(textobj-lastpaste-a)')



-- textobj-space {{{2

vim.g.textobj_space_no_default_key_mappings = true

vimrc.map_plug('o', 'a<Space>', '(textobj-space-a)')
vimrc.map_plug('x', 'a<Space>', '(textobj-space-a)')
vimrc.map_plug('o', 'i<Space>', '(textobj-space-i)')
vimrc.map_plug('x', 'i<Space>', '(textobj-space-i)')


-- textobj-wiw {{{2

vim.g.textobj_wiw_no_default_key_mappings = true

vimrc.map_plug('n', '<C-w>', '(textobj-wiw-n)')
vimrc.map_plug('o', '<C-w>', '(textobj-wiw-n)')
vimrc.map_plug('x', '<C-w>', '(textobj-wiw-n)')
vimrc.map_plug('n', 'g<C-w>', '(textobj-wiw-p)')
vimrc.map_plug('o', 'g<C-w>', '(textobj-wiw-p)')
vimrc.map_plug('x', 'g<C-w>', '(textobj-wiw-p)')
vimrc.map_plug('n', '<C-e>', '(textobj-wiw-N)')
vimrc.map_plug('o', '<C-e>', '(textobj-wiw-N)')
vimrc.map_plug('x', '<C-e>', '(textobj-wiw-N)')
vimrc.map_plug('n', 'g<C-e>', '(textobj-wiw-P)')
vimrc.map_plug('o', 'g<C-e>', '(textobj-wiw-P)')
vimrc.map_plug('x', 'g<C-e>', '(textobj-wiw-P)')

vimrc.map_plug('o', 'a<C-w>', '(textobj-wiw-a)')
vimrc.map_plug('x', 'a<C-w>', '(textobj-wiw-a)')
vimrc.map_plug('o', 'i<C-w>', '(textobj-wiw-i)')
vimrc.map_plug('x', 'i<C-w>', '(textobj-wiw-i)')



-- window-adjuster {{{2

vimrc.map('n', 'tRw', ':<C-u>AdjustScreenWidth<CR>', { silent = true })
vimrc.map('n', 'tRh', ':<C-u>AdjustScreenHeight<CR>', { silent = true })
vimrc.map('n', 'tRr', ':<C-u>AdjustScreenWidth <Bar> AdjustScreenHeight<CR>', { silent = true })





-- yankround {{{2

vim.g.yankround_dir = my_env.yankround_dir
vim.g.yankround_use_region_hl = true





-- Modelines {{{1

-- vim: expandtab:softtabstop=3:shiftwidth=3:textwidth=80:colorcolumn=+1:
-- vim: foldenable:foldmethod=marker:foldlevel=0:
