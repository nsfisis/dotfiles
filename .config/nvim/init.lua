--[========================================================================[--
--                                                                          --
--                 _                __  _       _ _     _                   --
--      _ ____   _(_)_ __ ___      / / (_)_ __ (_) |_  | |_   _  __ _       --
--     | '_ \ \ / / | '_ ` _ \    / /  | | '_ \| | __| | | | | |/ _` |      --
--     | | | \ V /| | | | | | |  / /   | | | | | | |_ _| | |_| | (_| |      --
--     |_| |_|\_/ |_|_| |_| |_| /_/    |_|_| |_|_|\__(_)_|\__,_|\__,_|      --
--                                                                          --
--]========================================================================]--



-- Global settings {{{1

-- Aliases {{{2

local F = vim.fn
local G = vim.g
local O = vim.o
local OPT = vim.opt

local vimrc = require('vimrc')
_G.vimrc = vimrc


-- Global constants {{{2

local my_env = {}

if F.has('unix') then
   my_env.os = 'unix'
elseif F.has('mac') then
   my_env.os = 'mac'
elseif F.has('wsl') then
   my_env.os = 'wsl'
elseif F.has('win32') or F.has('win64') then
   my_env.os = 'windows'
else
   my_env.os = 'unknown'
end

my_env.home = vim.env.HOME or F.expand('~')

my_env.config_home = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. '/.config'

my_env.config_dir = F.stdpath('config')
my_env.cache_dir = F.stdpath('cache')
my_env.data_dir = F.stdpath('data')

my_env.backup_dir = my_env.data_dir .. '/backup'
my_env.yankround_dir = my_env.data_dir .. '/yankround'

my_env.skk_dir = my_env.config_home .. '/skk'
my_env.scratch_dir = my_env.home .. '/scratch'

for k, v in pairs(my_env) do
   if vim.endswith(k, '_dir') and F.isdirectory(v) == 0 then
      F.mkdir(v, 'p')
   end
end




-- The autogroup used in .vimrc {{{2

vim.cmd([[
augroup Vimrc
   autocmd!
augroup END
]])



-- Language {{{2

-- Disable L10N.
vim.cmd('language messages C')
vim.cmd('language time C')




-- Options {{{1

-- Moving around, searching and patterns {{{2

O.wrapscan = false
O.ignorecase = true
O.smartcase = true


-- Displaying text {{{2

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


-- Syntax, highlighting and spelling {{{2

O.background = 'dark'
O.synmaxcol = 500
O.hlsearch = true
O.termguicolors = true
O.colorcolumn = '+1'


-- Multiple windows {{{2

O.winminheight = 0
O.hidden = true
O.switchbuf = 'usetab'


-- Multiple tabpages {{{2

O.showtabline = 2


-- Terminal {{{2

O.title = false


-- Using the mouse {{{2

O.mouse = ''


-- Messages and info {{{2

OPT.shortmess:append('asIc')
O.showmode = false
O.report = 999
O.confirm = true


-- Selecting text {{{2

O.clipboard = 'unnamed'


-- Editing text {{{2

O.undofile = true
O.textwidth = 0
OPT.completeopt:remove('preview')
O.pumheight = 10
OPT.matchpairs:append('<:>')
O.joinspaces = false
OPT.nrformats:append('unsigned')


-- Tabs and indenting {{{2
-- Note: you should also set them for each file types.
--       These following settings are used for unknown file types.

O.tabstop = 4
O.shiftwidth = 4
O.softtabstop = 4
O.expandtab = true
O.smartindent = true
O.copyindent = true
O.preserveindent = true


-- Folding {{{2

O.foldlevelstart = 0
OPT.foldopen:append('insert')
O.foldmethod = 'marker'


-- Diff mode {{{2

OPT.diffopt:append('vertical')
OPT.diffopt:append('foldcolumn:3')


-- Mapping {{{2

O.maxmapdepth = 10
O.timeout = false


-- Reading and writing files {{{2

O.fixendofline = false
O.fileformats = 'unix,dos'
O.backup = true
O.backupdir = my_env.backup_dir
O.autowrite = true


-- Command line editing {{{2

OPT.wildignore:append('*.o')
OPT.wildignore:append('*.obj')
OPT.wildignore:append('*.lib')
O.wildignorecase = true


-- Executing external commands {{{2

O.shell = 'zsh'
O.keywordprg = ''


-- Encoding {{{2

O.fileencodings = 'utf-8,cp932,euc-jp'


-- Misc. {{{2


-- Autocommands {{{1

-- Auto-resize windows when Vim is resized.
vimrc.autocmd('VimResized', '*', function()
   vim.cmd('wincmd =')
end)


-- Calculate 'numberwidth' to fit file size.
-- Note: extra 2 is the room of left and right spaces.
vimrc.autocmd('BufEnter,WinEnter,BufWinEnter', '*', function()
   vim.wo.numberwidth = #tostring(F.line('$')) + 2
end)


-- Jump to the last cursor position when you open a file.
vimrc.autocmd('BufRead', '*', function()
   if 0 < F.line("'\"") and F.line("'\"") <= F.line('$') and
      not O.filetype:match('commit') and not O.filetype:match('rebase')
   then
      vim.cmd('normal g`"')
   end
end)


-- Lua version of https://github.com/mopp/autodirmake.vim
-- License: NYSL
vimrc.autocmd('BufWritePre', '*', function()
   local dir = F.expand('<afile>:p:h')
   if F.isdirectory(dir) ~= 0 then
      return
   end
   vimrc.echo(('"%s" does not exist. Create? [y/N] '):format(dir), 'Question')
   local answer = vimrc.getchar()
   if answer ~= 'y' and answer ~= 'Y' then
      return
   end
   F.mkdir(dir, 'p')
end)


vimrc.register_filetype_autocmds_for_indentation()



-- Mappings {{{1

-- Note: |:noremap| defines mappings in |Normal|, |Visual|, |Operator-Pending|
-- and |Select| mode. Because I don't use |Select| mode, I use |:noremap|
-- instead of |:nnoremap|, |:xnoremap| and |:onoremap| for simplicity.


-- Searching {{{2

-- Fix direction of n and N.
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

F.setreg('j', 'j.')
F.setreg('k', 'k.')
F.setreg('n', 'n.')
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
   local repeat_ = F['repeat']
   local line = F.getline('.')
   local cursor_col = F.col('.')
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
   local line = F.getline('.')
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
   if F.winnr('$') == 1 then
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
   for winnr = 1, F.winnr('$') do
      if winnr ~= F.winnr() and F.win_gettype(winnr) == '' then
         wins[#wins+1] = F.win_getid(winnr)
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
      if wins[1] == F.win_getid() then
         F.win_gotoid(wins[2])
      else
         F.win_gotoid(wins[1])
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
            row = (F.winheight(winid) - 5) / 2,
            col = (F.winwidth(winid) - 9) / 2,
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
      F.win_gotoid(jump_target)
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
   if F.winwidth(F.winnr()) < 150 then
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
   if not G.__ok then
      return
   end

   if O.filetype == 'help' then
      if vim.bo.textwidth > 0 then
         vim.cmd(('vertical resize %d'):format(vim.bo.textwidth))
      end
      -- Move the cursor to the beginning of the line as help tags are often
      -- right-justfied.
      F.cursor(
         0 --[[ stay in the current line ]],
         1 --[[ move to the beginning of the line ]])
   end
end


vim.cmd([[
command! -nargs=+ -complete=command
   \ SmartOpen
   \ call v:lua.vimrc.fn.smart_open(<q-args>)
]])




-- Toggle options {{{2

vimrc.map('n', 'T', '<Nop>')

vimrc.map('n', 'Ta', ':<C-u>AutosaveToggle<CR>', { silent = true })
vimrc.map('n', 'Tb', ':<C-u>if &background == "dark" <Bar>set background=light <Bar>else <Bar>set background=dark <Bar>endif<CR>', { silent = true })
vimrc.map('n', 'Tc', ':<C-u>set cursorcolumn! <Bar>set cursorline!<CR>', { silent = true })
vimrc.map('n', 'Td', ':<C-u>if &diff <Bar>diffoff <Bar>else <Bar>diffthis <Bar>endif<CR>', { silent = true })
vimrc.map('n', 'Te', ':<C-u>set expandtab!<CR>', { silent = true })
vimrc.map('n', 'Th', ':<C-u>set hlsearch!<CR>', { silent = true })
vimrc.map('n', 'Tn', ':<C-u>set number!<CR>', { silent = true })
vimrc.map('n', 'Ts', ':<C-u>set spell!<CR>', { silent = true })
vimrc.map('n', 'T8', ':<C-u>if &textwidth ==# 80 <Bar>set textwidth=0 <Bar>else <Bar>set textwidth=80 <Bar>endif<CR>', { silent = true })
vimrc.map('n', 'T0', ':<C-u>if &textwidth ==# 100 <Bar>set textwidth=0 <Bar>else <Bar>set textwidth=100 <Bar>endif<CR>', { silent = true })
vimrc.map('n', 'T2', ':<C-u>if &textwidth ==# 120 <Bar>set textwidth=0 <Bar>else <Bar>set textwidth=120 <Bar>endif<CR>', { silent = true })
vimrc.map('n', 'Tw', ':<C-u>set wrap!<CR>', { silent = true })

vimrc.remap('n', 'TA', 'Ta')
vimrc.remap('n', 'TB', 'Tb')
vimrc.remap('n', 'TC', 'Tc')
vimrc.remap('n', 'TD', 'Td')
vimrc.remap('n', 'TE', 'Te')
vimrc.remap('n', 'TH', 'Th')
vimrc.remap('n', 'TN', 'Tn')
vimrc.remap('n', 'TS', 'Ts')
vimrc.remap('n', 'TW', 'Tw')



-- Increment/decrement numbers {{{2

-- nnoremap  +  <C-a>
-- nnoremap  -  <C-x>
-- xnoremap  +  <C-a>
-- xnoremap  -  <C-x>
-- xnoremap  g+  g<C-a>
-- xnoremap  g-  g<C-x>



-- Open *scratch* buffer {{{2

local EXTENSION_MAPPING = {
   bash       = 'sh',
   haskell    = 'hs',
   javascript = 'js',
   markdown   = 'md',
   python     = 'py',
   ruby       = 'rb',
   rust       = 'rs',
   typescript = 'ts',
   zsh        = 'sh',
}

local function make_scratch_buffer_name(ft)
   local now = F.localtime()
   if ft == '' then
      ft = 'txt'
   end
   local ext = EXTENSION_MAPPING[ft] or ft
   return my_env.scratch_dir .. '/' .. F.strftime('%Y-%m', now), F.strftime('%d-%H%M%S'), ext
end

function vimrc.fn.open_scratch()
   local ft = vim.trim(vimrc.input('filetype: '))
   local dir, fname, ext = make_scratch_buffer_name(ft)
   if F.isdirectory(dir) == 0 then
      F.mkdir(dir, 'p')
   end
   vim.cmd(('SmartTabEdit %s/%s.%s'):format(dir, fname, ext))
   if vim.bo.filetype ~= ft then
      vim.cmd('setlocal filetype=' .. ft)
   end
   vim.b._scratch_ = true
   if vim.fn.exists(':AutosaveEnable') == 2 then
      vim.cmd('AutosaveEnable')
   end
end

vim.cmd([[
command!
   \ Scratch
   \ call v:lua.vimrc.fn.open_scratch()
]])

vimrc.map('n', '<Space>s', '<Cmd>Scratch<CR>', { silent = true })



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







-- Abbreviations {{{2

vimrc.iabbrev('retrun', 'return')
vimrc.iabbrev('reutrn', 'return')
vimrc.iabbrev('tihs', 'this')



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
vimrc.remap('!', 'jk', '<ESC>')



vimrc.map('n', '<C-c>', ':<C-u>nohlsearch<CR>', { silent = true })



function vimrc.map_callbacks.insert_blank_line(offset)
   for i = 1, vim.v.count1 do
      F.append(F.line('.') - offset, '')
   end
end

vimrc.map('n', '<Plug>(my-insert-blank-lines-after)',
   'call v:lua.vimrc.map_callbacks.insert_blank_line(0)')
vimrc.map('n', '<Plug>(my-insert-blank-lines-before)',
   'call v:lua.vimrc.map_callbacks.insert_blank_line(1)')

vimrc.map_plug('n', 'go', '(my-insert-blank-lines-after)')
vimrc.map_plug('n', 'gO', '(my-insert-blank-lines-before)')


vimrc.map('n', '<Space>w', '<Cmd>update<CR>')

vimrc.map('n', 'Z', '<Cmd>wqall<CR>', { nowait = true })


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



function vimrc.fn.smart_tabedit(mods, args)
   local is_empty_buffer = (
      F.bufname() == ''
      and not vim.bo.modified
      and F.line('$') <= 1
      and F.getline('.') == ''
   )

   if is_empty_buffer then
      vim.cmd(mods .. ' edit ' .. args)
   else
      vim.cmd(mods .. ' tabedit ' .. args)
   end
end


-- If the current buffer is empty, open a file with the current window;
-- otherwise open a new tab.
vim.cmd([[
command! -bar -complete=file -nargs=*
   \ SmartTabEdit
   \ call v:lua.vimrc.fn.smart_tabedit(<q-mods>, <q-args>)
]])



-- Appearance {{{1

-- Color scheme {{{2

if not pcall(function() vim.cmd('colorscheme ocean') end) then
   -- Load "desert", one of the built-in colorschemes, instead of mine
   -- when nvim failed to load it.
   vim.cmd('colorscheme desert')
end



-- Statusline {{{2

O.statusline = '%!v:lua.vimrc.statusline.build()'

vimrc.statusline = {}

function vimrc.statusline.build()
   local winid = G.statusline_winid
   local bufnr = F.winbufnr(winid)
   local is_active = winid == F.win_getid()
   local left
   if is_active then
      local mode, mode_hl = vimrc.statusline.mode()
      left = string.format('%%#statusLineMode%s# %s %%#statusLine#', mode_hl, mode)
   else
      left = ''
   end
   local ro = vimrc.statusline.readonly(bufnr)
   local fname = vimrc.statusline.filename(bufnr)
   local mod = vimrc.statusline.modified(bufnr)
   local linenum = vimrc.statusline.linenum(winid)
   local fenc = vimrc.statusline.fenc(bufnr)
   local ff = vimrc.statusline.ff(bufnr)
   local ft = vimrc.statusline.filetype(bufnr)
   return string.format(
      '%s %s%s%s %%= %s %s%s %s ',
      left,
      ro and ro .. ' ' or '',
      fname,
      mod and ' ' .. mod or '',
      linenum,
      fenc,
      ff,
      ft)
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
   local vim_mode_and_hl = mode_map[F.mode(true)] or { '-', 'Other' }
   local vim_mode = vim_mode_and_hl[1]
   local hl = vim_mode_and_hl[2]

   -- Calling `eskk#statusline()` makes Vim autoload eskk. If you call it
   -- without checking `g:loaded_autoload_eskk`, eskk is loaded on an early
   -- stage of the initialization (probably the first rendering of status line),
   -- which slows down Vim startup. Loading eskk can be delayed by checking both
   -- of `g:loaded_eskk` and `g:loaded_autoload_eskk`.
   local skk_mode
   if G.loaded_eskk and G.loaded_autoload_eskk then
      skk_mode = F['eskk#statusline'](' (%s)', '')
   else
      skk_mode = ''
   end

   return vim_mode .. skk_mode, hl
end

function vimrc.statusline.readonly(bufnr)
   local ro = F.getbufvar(bufnr, '&readonly')
   if ro == 1 then
      return '[RO]'
   else
      return nil
   end
end

function vimrc.statusline.filename(bufnr)
   local name = F.bufname(bufnr)
   if name == '' then
      return '[No Name]'
   end
   if vim.b[bufnr]._scratch_ then
      return '*scratch*'
   end

   local other_paths = {}
   for b = 1, F.bufnr('$') do
      if F.bufexists(b) and b ~= bufnr then
         other_paths[#other_paths+1] = F.split(F.bufname(b), '[\\/]')
      end
   end
   local this_path = F.split(name, '[\\/]')
   local i = 0
   while true do
      local this_path_part = this_path[#this_path+i] or ''
      local unique = true
      local no_parts_remained = true
      for _, other_path in ipairs(other_paths) do
         local other_path_part = other_path[#other_path+i] or ''
         if vim.stricmp(this_path_part, other_path_part) == 0 then
            unique = false
            break
         end
         if other_path_part ~= '' then
            no_parts_remained = false
         end
      end
      if unique then
         break
      end
      if this_path_part == '' and no_parts_remained then
         break
      end
      i = i - 1
   end

   if i <= -(#this_path) then
      i = -(#this_path) + 1
   end

   local ret = ''
   for k = i, 0 do
      if #this_path < 1 - k then
         break
      end
      if k == i or k == 0 then
         ret = ret .. '/' .. this_path[#this_path+k]
      else
         ret = ret .. '/' .. F.matchlist(this_path[#this_path+k], '.')[1]
      end
   end
   return ret:sub(2)
end

function vimrc.statusline.modified(bufnr)
   local mod = F.getbufvar(bufnr, '&modified')
   local ma = F.getbufvar(bufnr, '&modifiable')
   if mod == 1 then
      return '[+]'
   elseif ma == 0 then
      return '[-]'
   else
      return nil
   end
end

function vimrc.statusline.linenum(winid)
   return F.line('.', winid) .. '/' .. F.line('$', winid)
end

function vimrc.statusline.fenc(bufnr)
   local fenc = F.getbufvar(bufnr, '&fileencoding')
   local bom = F.getbufvar(bufnr, '&bomb')  -- BOMB!!

   if fenc == '' then
      local fencs = F.split(O.fileencodings, ',')
      fenc = fencs[1] or O.encoding
   end
   if fenc == 'utf-8' then
      return bom == 1 and 'U8[BOM]' or 'U8'
   elseif fenc == 'utf-16' then
      return 'U16[BE]'
   elseif fenc == 'utf-16le' then
      return 'U16[LE]'
   elseif fenc == 'ucs-4' then
      return 'U32[BE]'
   elseif fenc == 'ucs-4le' then
      return 'U32[LE]'
   else
      return fenc:upper()
   end
end

function vimrc.statusline.ff(bufnr)
   local ff = F.getbufvar(bufnr, '&fileformat')
   if ff == 'unix' then
      return ''
   elseif ff == 'dos' then
      return ' (CRLF)'
   elseif ff == 'mac' then
      return ' (CR)'
   else
      return ' (Unknown)'
   end
end

function vimrc.statusline.filetype(bufnr)
   local ft = F.getbufvar(bufnr, '&filetype')
   if ft == '' then
      return '[None]'
   else
      return ft
   end
end



-- Tabline {{{2

O.tabline = '%!v:lua.vimrc.tabline.build()'

vimrc.tabline = {}

function vimrc.tabline.build()
   local tal = ''
   for tabnr = 1, F.tabpagenr('$') do
      local is_active = tabnr == F.tabpagenr()
      local buflist = F.tabpagebuflist(tabnr)
      local bufnr = buflist[F.tabpagewinnr(tabnr)]
      tal = tal .. string.format(
         '%%#%s# %s ',
         is_active and 'TabLineSel' or 'TabLine',
         vimrc.statusline.filename(bufnr))
   end
   return tal .. '%#TabLineFill#'
end



-- Plugins {{{1

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
   -- Makes folding text cool.
   'LeafCage/foldCC.vim',
   -- Show indent.
   'Yggdroot/indentLine',
   -- Highlight matched parentheses.
   'itchyny/vim-parenmatch',
   -- Tree-sitter integration.
   'nvim-treesitter/nvim-treesitter',
   -- Highlight specified words.
   't9md/vim-quickhl',
   -- Filetypes {{{2
   -- Faster replacement for bundled filetype.vim
   'nathom/filetype.nvim',
   -- C/C++
   'rhysd/vim-clang-format',
   -- HTML/CSS
   'mattn/emmet-vim',
   -- Python
   'tell-k/vim-autopep8',
   -- Rust
   'rust-lang/rust.vim',
   -- QoL {{{2
   -- Capture the output of a command.
   'tyru/capture.vim',
   -- Write git commit message.
   'rhysd/committia.vim',
   -- Neovim clone of EasyMotion
   'phaazon/hop.nvim',
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



-- Plugins configuration {{{1

-- Disable standard plugins. {{{2

G.loaded_gzip             = 1
G.loaded_matchparen       = 1
G.loaded_netrw            = 1
G.loaded_netrwPlugin      = 1
G.loaded_spellfile_plugin = 1
G.loaded_tarPlugin        = 1
G.loaded_zipPlugin        = 1



-- altr {{{2

-- C/C++
F['altr#define']('%.c', '%.cpp', '%.cc', '%.h', '%.hh', '%.hpp')
-- Vim
F['altr#define']('autoload/%.vim', 'doc/%.txt', 'plugin/%.vim')

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



-- autopep8 {{{2

G.autopep8_on_save = true
G.autopep8_disable_show_diff = true

vim.cmd([[
command!
   \ Autopep8Disable
   \ let g:autopep8_on_save = 0
]])



-- caw {{{2

G.caw_no_default_keymappings = true

vimrc.map_plug('n', 'm//', '(caw:hatpos:toggle)')
vimrc.map_plug('x', 'm//', '(caw:hatpos:toggle)')
vimrc.map_plug('n', 'm/w', '(caw:wrap:comment)')
vimrc.map_plug('x', 'm/w', '(caw:wrap:comment)')
vimrc.map_plug('n', 'm/W', '(caw:wrap:uncomment)')
vimrc.map_plug('x', 'm/W', '(caw:wrap:uncomment)')
vimrc.map_plug('n', 'm/b', '(caw:box:comment)')
vimrc.map_plug('x', 'm/b', '(caw:box:comment)')



-- clang-format {{{2

G['clang_format#auto_format'] = true

vimrc.autocmd('FileType', 'javascript,typescript', function()
   vim.cmd('ClangFormatAutoDisable')
end)



-- ctrlp {{{2

G.ctrlp_map = '<Space>f'
G.ctrlp_match_func = { match = 'ctrlp_matchfuzzy#matcher' }



-- dirvish {{{2

-- Prevent dirvish from mapping hyphen key to "<Plug>(dirvish_up)".
-- nmap  <Plug>(nomap-dirvish_up)  <Plug>(dirvish_up)



-- easyalign {{{2

vimrc.map_plug('n', '=', '(EasyAlign)')
vimrc.map_plug('x', '=', '(EasyAlign)')



-- emmet {{{2

G.user_emmet_install_global = false
vimrc.autocmd('FileType', 'html,css', function()
   vim.cmd('EmmetInstall')
end)



-- eskk {{{2

G['eskk#dictionary'] = {
   path = my_env.skk_dir .. '/jisyo',
   sorted = false,
   encoding = 'utf-8',
}

G['eskk#large_dictionary'] = {
   path = my_env.skk_dir .. '/jisyo.L',
   sorted = true,
   encoding = 'euc-jp',
}

G['eskk#backup_dictionary'] = G['eskk#dictionary'].path .. ".bak"

G['eskk#kakutei_when_unique_candidate'] = true
G['eskk#enable_completion'] = false
G['eskk#egg_like_newline'] = true

-- Change default markers because they are EAW (East Asian Width) characters.
G['eskk#marker_henkan'] = '[!]'
G['eskk#marker_okuri'] = '-'
G['eskk#marker_henkan_select'] = '[#]'
G['eskk#marker_jisyo_touroku'] = '[?]'



vim.cmd([=[
function My_eskk_initialize_pre()
   for [orgtable, mode] in [['rom_to_hira', 'hira'], ['rom_to_kata', 'kata']]
      let t = eskk#table#new(orgtable . '*', orgtable)
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
      call eskk#register_mode_table(mode, t)
   endfor
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

   map!  jk  <Plug>(eskk:disable)<ESC>

   " Custom highlight for henkan markers.
   syntax match skkMarker '\[[!#?]\]'
   hi link skkMarker Special
endfunction


autocmd Vimrc User eskk-initialize-post call My_eskk_initialize_post()
]=])



-- filetype.nvim {{{2

require('filetype').setup({
   overrides = {
      -- My settings here
   },
})



-- foldcc {{{2

O.foldtext = 'FoldCCtext()'
G.foldCCtext_head = 'repeat(">", v:foldlevel) . " "'



-- hop {{{2

require('hop').setup {
   keys = 'asdfghweryuiocvbnmjkl;',
}

-- Emulate `g:EasyMotion_startofline = 0` in hop.nvim.
function vimrc.map_callbacks.hop_jk(opts)
   local hop = require('hop')
   local jump_target = require('hop.jump_target')

   local column = F.col('.')
   local match
   if column == 1 then
      match = function(_)
         return 0, 1, false
      end
   else
      local pat = vim.regex('\\%' .. column .. 'c')
      match = function(s)
         return pat:match_str(s)
      end
   end
   setmetatable(opts, { __index = hop.opts })
   hop.hint_with(
      jump_target.jump_targets_by_scanning_lines({
         oneshot = true,
         match = match,
      }),
      opts
   )
end

vimrc.map('', '<Plug>(hop-f)', "<Cmd>lua require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR,  current_line_only = true })<CR>", { silent = true })
vimrc.map('', '<Plug>(hop-F)', "<Cmd>lua require('hop').hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = true })<CR>", { silent = true })
vimrc.map('', '<Plug>(hop-t)', "<Cmd>lua require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR,  current_line_only = true })<CR>", { silent = true })
vimrc.map('', '<Plug>(hop-T)', "<Cmd>lua require('hop').hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = true })<CR>", { silent = true })

vimrc.map('', '<Plug>(hop-s2)', "<Cmd>lua require('hop').hint_char2()<CR>", { silent = true })
vimrc.map('', '<Plug>(hop-n)', "<Cmd>lua require('hop').hint_patterns({ direction = require('hop.hint').HintDirection.AFTER_CURSOR  }, vim.fn.getreg('/'))<CR>", { silent = true })
vimrc.map('', '<Plug>(hop-N)', "<Cmd>lua require('hop').hint_patterns({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR }, vim.fn.getreg('/'))<CR>", { silent = true })
vimrc.map('', '<Plug>(hop-j)', "<Cmd>lua vimrc.map_callbacks.hop_jk({ direction = require('hop.hint').HintDirection.AFTER_CURSOR  })<CR>", { silent = true })
vimrc.map('', '<Plug>(hop-k)', "<Cmd>lua vimrc.map_callbacks.hop_jk({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR })<CR>", { silent = true })

vimrc.map_plug('n', 'f', '(hop-f)')
vimrc.map_plug('o', 'f', '(hop-f)')
vimrc.map_plug('x', 'f', '(hop-f)')
vimrc.map_plug('n', 'F', '(hop-F)')
vimrc.map_plug('o', 'F', '(hop-F)')
vimrc.map_plug('x', 'F', '(hop-F)')
vimrc.map_plug('o', 't', '(hop-t)')
vimrc.map_plug('x', 't', '(hop-t)')
vimrc.map_plug('o', 'T', '(hop-T)')
vimrc.map_plug('x', 'T', '(hop-T)')

-- Note: Don't use the following key sequences! It is used 'vim-sandwich'.
--  * sa
--  * sd
--  * sr
vimrc.map_plug('n', 'ss', '(hop-s2)')
vimrc.map_plug('o', 'ss', '(hop-s2)')
vimrc.map_plug('x', 'ss', '(hop-s2)')
vimrc.map_plug('n', 'sn', '(hop-n)')
vimrc.map_plug('o', 'sn', '(hop-n)')
vimrc.map_plug('x', 'sn', '(hop-n)')
vimrc.map_plug('n', 'sN', '(hop-N)')
vimrc.map_plug('o', 'sN', '(hop-N)')
vimrc.map_plug('x', 'sN', '(hop-N)')
vimrc.map_plug('n', 'sj', '(hop-j)')
vimrc.map_plug('o', 'sj', '(hop-j)')
vimrc.map_plug('x', 'sj', '(hop-j)')
vimrc.map_plug('n', 'sk', '(hop-k)')
vimrc.map_plug('o', 'sk', '(hop-k)')
vimrc.map_plug('x', 'sk', '(hop-k)')



-- indentline {{{2

G.indentLine_conceallevel = 1
G.indentLine_fileTypeExclude = { 'help' }



-- jplus {{{2

G['jplus#input_config'] = {
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
G.quickhl_manual_colors = {
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

G.quickrun_no_default_key_mappings = true

G.quickrun_config = {
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
F['repeat#setreg']('', '')


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
G.rg_window_location = 'silent! echo'
G.rg_jump_to_first = true

vim.cmd([[
command! -bang -nargs=* -complete=file -bar
   \ RG
   \ Rg<bang> <args>
]])


-- rust {{{2

G.rustfmt_autosave = true




-- sandwich {{{2

F['operator#sandwich#set']('add', 'all', 'highlight', 2)
F['operator#sandwich#set']('delete', 'all', 'highlight', 0)
F['operator#sandwich#set']('replace', 'all', 'highlight', 2)





-- submode {{{2

-- Global settings {{{3
G.submode_always_show_submode = true
G.submode_keyseqs_to_leave = { '<C-c>', '<ESC>' }
G.submode_keep_leaving_key = true


-- yankround {{{3
F['submode#enter_with']('YankRound', 'nv', 'rs', 'gp', '<Plug>(yankround-p)')
F['submode#enter_with']('YankRound', 'nv', 'rs', 'gP', '<Plug>(yankround-P)')
F['submode#map']('YankRound', 'nv', 'rs', 'p', '<Plug>(yankround-prev)')
F['submode#map']('YankRound', 'nv', 'rs', 'P', '<Plug>(yankround-next)')

-- swap {{{3
F['submode#enter_with']('Swap', 'n', 'r', 'g>', '<Plug>(swap-next)')
F['submode#map']('Swap', 'n', 'r', '<', '<Plug>(swap-prev)')
F['submode#enter_with']('Swap', 'n', 'r', 'g<', '<Plug>(swap-prev)')
F['submode#map']('Swap', 'n', 'r', '>', '<Plug>(swap-next)')

-- Resizing a window (height) {{{3
F['submode#enter_with']('WinResizeH', 'n', '', 'trh')
F['submode#enter_with']('WinResizeH', 'n', '', 'trh')
F['submode#map']('WinResizeH', 'n', '', '+', '<C-w>+')
F['submode#map']('WinResizeH', 'n', '', '-', '<C-w>-')

-- Resizing a window (width) {{{3
F['submode#enter_with']('WinResizeW', 'n', '', 'trw')
F['submode#enter_with']('WinResizeW', 'n', '', 'trw')
F['submode#map']('WinResizeW', 'n', '', '+', '<C-w>>')
F['submode#map']('WinResizeW', 'n', '', '-', '<C-w><Lt>')

-- Super undo/redo {{{3
F['submode#enter_with']('Undo/Redo', 'n', '', 'gu', 'g-')
F['submode#map']('Undo/Redo', 'n', '', 'u', 'g-')
F['submode#enter_with']('Undo/Redo', 'n', '', 'gU', 'g+')
F['submode#map']('Undo/Redo', 'n', '', 'U', 'g+')



-- swap {{{2

G.swap_no_default_key_mappings = true



-- textobj-continuousline {{{2

G.textobj_continuous_line_no_default_key_mappings = true

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

G.textobj_lastpaste_no_default_key_mappings = true

vimrc.map_plug('o', 'iP', '(textobj-lastpaste-i)')
vimrc.map_plug('x', 'iP', '(textobj-lastpaste-i)')
vimrc.map_plug('o', 'aP', '(textobj-lastpaste-a)')
vimrc.map_plug('x', 'aP', '(textobj-lastpaste-a)')



-- textobj-space {{{2

G.textobj_space_no_default_key_mappings = true

vimrc.map_plug('o', 'a<Space>', '(textobj-space-a)')
vimrc.map_plug('x', 'a<Space>', '(textobj-space-a)')
vimrc.map_plug('o', 'i<Space>', '(textobj-space-i)')
vimrc.map_plug('x', 'i<Space>', '(textobj-space-i)')


-- textobj-wiw {{{2

G.textobj_wiw_no_default_key_mappings = true

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



-- nvim-treesitter {{{2

require('nvim-treesitter.configs').setup {
   ensure_installed = 'maintained',
   sync_install = false,
   highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
   },
   --[[
   incremental_selection = {
      enable = true,
      keymaps = {
         init_selection = 'TODO',
         node_incremental = 'TODO',
         scope_incremental = 'TODO',
         node_decremental = 'TODO',
      },
   },
   --]]
   indent = {
      enable = true,
   },
}



-- window-adjuster {{{2

vimrc.map('n', 'tRw', ':<C-u>AdjustScreenWidth<CR>', { silent = true })
vimrc.map('n', 'tRh', ':<C-u>AdjustScreenHeight<CR>', { silent = true })
vimrc.map('n', 'tRr', ':<C-u>AdjustScreenWidth <Bar> AdjustScreenHeight<CR>', { silent = true })





-- yankround {{{2

G.yankround_dir = my_env.yankround_dir
G.yankround_use_region_hl = true
