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

local uniquify = require('uniquify')
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




-- The augroup used in .vimrc {{{2

vimrc.create_augroup_for_vimrc()



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
vimrc.autocmd('VimResized', {
   command = 'wincmd =',
})


-- Calculate 'numberwidth' to fit file size.
-- Note: extra 2 is the room of left and right spaces.
vimrc.autocmd({'BufEnter', 'WinEnter', 'BufWinEnter'}, {
   callback = function()
      vim.wo.numberwidth = #tostring(F.line('$')) + 2
   end,
})


-- Jump to the last cursor position when you open a file.
vimrc.autocmd('BufRead', {
   callback = function()
      if 0 < F.line("'\"") and F.line("'\"") <= F.line('$') and
         not O.filetype:match('commit') and not O.filetype:match('rebase')
      then
         vim.cmd('normal g`"')
      end
   end,
})


-- Lua version of https://github.com/mopp/autodirmake.vim
-- License: NYSL
vimrc.autocmd('BufWritePre', {
   callback = function()
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
   end,
})


vimrc.register_filetype_autocmds_for_indentation()



-- Mappings {{{1

-- Note: |:noremap| defines mappings in |Normal|, |Visual|, |Operator-Pending|
-- and |Select| mode. Because I don't use |Select| mode, I use |:noremap|
-- instead of |:nnoremap|, |:xnoremap| and |:onoremap| for simplicity.


-- Searching {{{2

-- Fix direction of n and N.
vim.keymap.set('', 'n', "v:searchforward ? 'n' : 'N'", { expr=true })
vim.keymap.set('', 'N', "v:searchforward ? 'N' : 'n'", { expr=true })

vim.keymap.set('', 'gn', "v:searchforward ? 'gn' : 'gN'", { expr=true })
vim.keymap.set('', 'gN', "v:searchforward ? 'gN' : 'gn'", { expr=true })

vim.keymap.set({'n', 'x'}, '&', '<Cmd>%&&<CR>')


-- Registers and macros. {{{2

-- Access an resister in the same way in Insert and Commandline mode.
vim.keymap.set({'n', 'x'}, '<C-r>', '"')

F.setreg('j', 'j.')
F.setreg('k', 'k.')
F.setreg('n', 'n.')
F.setreg('m', 'N.')
vim.keymap.set('n', '@N', '@m')

-- Repeat the last executed macro as many times as possible.
-- a => all
vim.keymap.set('n', '@a', '9999@@')

-- Execute the last executed macro again.
vim.keymap.set('n', '`', '@@')


-- Emacs like key mappings in Insert and CommandLine mode. {{{2

vim.keymap.set('i', '<C-d>', '<Del>')

-- Go elsewhere without deviding the undo history.
vim.keymap.set('i', '<C-a>', "repeat('<C-g>U<Left>', col('.') - 1)", { expr=true })
vim.keymap.set('i', '<C-e>', "repeat('<C-g>U<Right>', col('$') - col('.'))", { expr=true })
vim.keymap.set('i', '<C-b>', '<C-g>U<Left>')
vim.keymap.set('i', '<C-f>', '<C-g>U<Right>')

-- Delete something deviding the undo history.
vim.keymap.set('i', '<C-u>', '<C-g>u<C-u>')
vim.keymap.set('i', '<C-w>', '<C-g>u<C-w>')

vim.keymap.set('c', '<C-a>', '<Home>')
vim.keymap.set('c', '<C-e>', '<End>')
vim.keymap.set('c', '<C-f>', '<Right>')
vim.keymap.set('c', '<C-b>', '<Left>')
vim.keymap.set('c', '<C-n>', '<Down>')
vim.keymap.set('c', '<C-p>', '<Up>')
vim.keymap.set('c', '<C-d>', '<Del>')

vim.keymap.set({'c', 'i'}, '<Left>', '<Nop>')
vim.keymap.set({'c', 'i'}, '<Right>', '<Nop>')



vim.keymap.set('n', 'gA', function()
   local line = F.getline('.')
   if vim.endswith(line, ';;') then -- for OCaml
      return 'A<C-g>U<Left><C-g>U<Left>'
   elseif vim.regex('[,;)]$'):match_str(line) then
      return 'A<C-g>U<Left>'
   else
      return 'A'
   end
end, { expr=true, replace_keycodes=true })



-- QuickFix or location list. {{{2

vim.keymap.set('n', 'bb', '<Cmd>cc<CR>')

vim.keymap.set('n', 'bn', ':<C-u><C-r>=v:count1<CR>cnext<CR>', { silent = true })
vim.keymap.set('n', 'bp', ':<C-u><C-r>=v:count1<CR>cprevious<CR>', { silent = true })

vim.keymap.set('n', 'bf', '<Cmd>cfirst<CR>')
vim.keymap.set('n', 'bl', '<Cmd>clast<CR>')

vim.keymap.set('n', 'bS', '<Cmd>colder<CR>')
vim.keymap.set('n', 'bs', '<Cmd>cnewer<CR>')



-- Operators {{{2

-- Throw deleted text into the black hole register ("_).
vim.keymap.set({'n', 'x'}, 'c', '"_c')
vim.keymap.set({'n', 'x'}, 'C', '"_C')


vim.keymap.set('', 'g=', '=')


vim.keymap.set('', 'ml', 'gu')
vim.keymap.set('', 'mu', 'gU')

vim.keymap.set('', 'gu', '<Nop>')
vim.keymap.set('', 'gU', '<Nop>')
vim.keymap.set('x', 'u', '<Nop>')
vim.keymap.set('x', 'U', '<Nop>')


vim.keymap.set('x', 'x', '"_x')


vim.keymap.set('n', 'Y', 'y$')
-- In Blockwise-Visual mode, select text linewise.
-- By default, select text characterwise, neither blockwise nor linewise.
vim.keymap.set('x', 'Y', "mode() ==# 'V' ? 'y' : 'Vy'", { expr=true })



-- Swap the keys entering Replace mode and Visual-Replace mode.
vim.keymap.set('n', 'R', 'gR')
vim.keymap.set('n', 'gR', 'R')
vim.keymap.set('n', 'r', 'gr')
vim.keymap.set('n', 'gr', 'r')


vim.keymap.set('n', 'U', '<C-r>')




-- Motions {{{2

vim.keymap.set('', 'H', '^')
vim.keymap.set('', 'L', '$')
vim.keymap.set('', 'M', '%')

vim.keymap.set('', 'gw', 'b')
vim.keymap.set('', 'gW', 'B')

vim.keymap.set('', 'k', 'gk')
vim.keymap.set('', 'j', 'gj')
vim.keymap.set('', 'gk', 'k')
vim.keymap.set('', 'gj', 'j')

vim.keymap.set('n', 'gff', 'gF')



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


vim.keymap.set('n', 'tt', '<Cmd>tabnew<CR>')
vim.keymap.set('n', 'tT', vimrc.fn.move_current_window_to_tabpage)

vim.keymap.set('n', 'tn', ":<C-u><C-r>=(tabpagenr() + v:count1 - 1) % tabpagenr('$') + 1<CR>tabnext<CR>", { silent=true })
vim.keymap.set('n', 'tp', ":<C-u><C-r>=(tabpagenr('$') * 10 + tabpagenr() - v:count1 - 1) % tabpagenr('$') + 1<CR>tabnext<CR>", { silent=true })

vim.keymap.set('n', 'tN', '<Cmd>tabmove +<CR>')
vim.keymap.set('n', 'tP', '<Cmd>tabmove -<CR>')

vim.keymap.set('n', 'tsh', '<Cmd>leftabove vsplit<CR>')
vim.keymap.set('n', 'tsj', '<Cmd>rightbelow split<CR>')
vim.keymap.set('n', 'tsk', '<Cmd>leftabove split<CR>')
vim.keymap.set('n', 'tsl', '<Cmd>rightbelow vsplit<CR>')

vim.keymap.set('n', 'tsH', '<Cmd>topleft vsplit<CR>')
vim.keymap.set('n', 'tsJ', '<Cmd>botright split<CR>')
vim.keymap.set('n', 'tsK', '<Cmd>topleft split<CR>')
vim.keymap.set('n', 'tsL', '<Cmd>botright vsplit<CR>')

vim.keymap.set('n', 'twh', '<Cmd>leftabove vnew<CR>')
vim.keymap.set('n', 'twj', '<Cmd>rightbelow new<CR>')
vim.keymap.set('n', 'twk', '<Cmd>leftabove new<CR>')
vim.keymap.set('n', 'twl', '<Cmd>rightbelow vnew<CR>')

vim.keymap.set('n', 'twH', '<Cmd>topleft vnew<CR>')
vim.keymap.set('n', 'twJ', '<Cmd>botright new<CR>')
vim.keymap.set('n', 'twK', '<Cmd>topleft new<CR>')
vim.keymap.set('n', 'twL', '<Cmd>botright vnew<CR>')

vim.keymap.set('n', 'th', '<C-w>h')
vim.keymap.set('n', 'tj', '<C-w>j')
vim.keymap.set('n', 'tk', '<C-w>k')
vim.keymap.set('n', 'tl', '<C-w>l')

vim.keymap.set('n', 'tH', '<C-w>H')
vim.keymap.set('n', 'tJ', '<C-w>J')
vim.keymap.set('n', 'tK', '<C-w>K')
vim.keymap.set('n', 'tL', '<C-w>L')

vim.keymap.set('n', 'tx', '<C-w>x')

-- r => manual resize.
-- R => automatic resize.
vim.keymap.set('n', 'tRH', '<C-w>_')
vim.keymap.set('n', 'tRW', '<C-w><Bar>')
vim.keymap.set('n', 'tRR', '<C-w>_<C-w><Bar>')

vim.keymap.set('n', 't=', '<C-w>=')

vim.keymap.set('n', 'tq', '<Cmd>bdelete<CR>')

vim.keymap.set('n', 'tc', '<C-w>c')

vim.keymap.set('n', 'to', '<C-w>o')
vim.keymap.set('n', 'tO', '<Cmd>tabonly<CR>')

vim.keymap.set('n', 'tg', vimrc.fn.choose_window_interactively)



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

vim.api.nvim_create_user_command(
   'SmartOpen',
   function(opts) vimrc.fn.smart_open(opts.args) end,
   {
      desc = 'Smartly open a new buffer',
      nargs = '+',
      complete = 'command',
   }
)




-- Toggle options {{{2

vim.keymap.set('n', 'T', '<Nop>')

vim.keymap.set('n', 'Ta', '<Cmd>AutosaveToggle<CR>')
vim.keymap.set('n', 'Tb', ':<C-u>if &background == "dark" <Bar>set background=light <Bar>else <Bar>set background=dark <Bar>endif<CR>', { silent=true })
vim.keymap.set('n', 'Tc', ':<C-u>set cursorcolumn! <Bar>set cursorline!<CR>', { silent=true })
vim.keymap.set('n', 'Td', ':<C-u>if &diff <Bar>diffoff <Bar>else <Bar>diffthis <Bar>endif<CR>', { silent=true })
vim.keymap.set('n', 'Te', '<Cmd>set expandtab!<CR>')
vim.keymap.set('n', 'Th', '<Cmd>set hlsearch!<CR>')
vim.keymap.set('n', 'Tn', '<Cmd>set number!<CR>')
vim.keymap.set('n', 'Ts', '<Cmd>set spell!<CR>')
vim.keymap.set('n', 'T8', ':<C-u>if &textwidth ==# 80 <Bar>set textwidth=0 <Bar>else <Bar>set textwidth=80 <Bar>endif<CR>', { silent=true })
vim.keymap.set('n', 'T0', ':<C-u>if &textwidth ==# 100 <Bar>set textwidth=0 <Bar>else <Bar>set textwidth=100 <Bar>endif<CR>', { silent=true })
vim.keymap.set('n', 'T2', ':<C-u>if &textwidth ==# 120 <Bar>set textwidth=0 <Bar>else <Bar>set textwidth=120 <Bar>endif<CR>', { silent=true })
vim.keymap.set('n', 'Tw', '<Cmd>set wrap!<CR>')

vim.keymap.set('n', 'TA', 'Ta', { remap=true })
vim.keymap.set('n', 'TB', 'Tb', { remap=true })
vim.keymap.set('n', 'TC', 'Tc', { remap=true })
vim.keymap.set('n', 'TD', 'Td', { remap=true })
vim.keymap.set('n', 'TE', 'Te', { remap=true })
vim.keymap.set('n', 'TH', 'Th', { remap=true })
vim.keymap.set('n', 'TN', 'Tn', { remap=true })
vim.keymap.set('n', 'TS', 'Ts', { remap=true })
vim.keymap.set('n', 'TW', 'Tw', { remap=true })



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
   return my_env.scratch_dir .. '/' .. F.strftime('%Y-%m', now), F.strftime('%Y-%m-%d-%H%M%S'), ext
end

function vimrc.fn.open_scratch()
   local ok, ft = pcall(function() return vimrc.input('filetype: ') end)
   if not ok then
      vimrc.echo('Canceled', 'ErrorMsg')
      return
   end
   ft = vim.trim(ft)
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

vim.api.nvim_create_user_command(
   'Scratch',
   function() vimrc.fn.open_scratch() end,
   {
      desc = 'Open a *scratch* buffer',
   }
)

vim.keymap.set('n', '<Space>s', '<Cmd>Scratch<CR>')



-- Disable unuseful or dangerous mappings. {{{2

-- Disable Select mode.
vim.keymap.set('n', 'gh', '<Nop>')
vim.keymap.set('n', 'gH', '<Nop>')
vim.keymap.set('n', 'g<C-h>', '<Nop>')

-- Disable Ex mode.
vim.keymap.set('n', 'Q', '<Nop>')
vim.keymap.set('n', 'gQ', '<Nop>')

vim.keymap.set('n', 'ZZ', '<Nop>')
vim.keymap.set('n', 'ZQ', '<Nop>')


-- Help {{{2

-- Search help.
vim.keymap.set('n', '<C-h>', ':<C-u>SmartOpen help<Space>')



-- For writing Vim script. {{{2

vim.keymap.set('n', 'XV', '<Cmd>SmartTabEdit $MYVIMRC<CR>')

-- See |numbered-function|.
vim.keymap.set('n', 'XF', ':<C-u>function {<C-r>=v:count<CR>}<CR>', { silent=true })

vim.keymap.set('n', 'XM', '<Cmd>messages<CR>')







-- Abbreviations {{{2

vimrc.iabbrev('TOOD', 'TODO')
vimrc.iabbrev('retrun', 'return')
vimrc.iabbrev('reutrn', 'return')
vimrc.iabbrev('tihs', 'this')



-- Misc. {{{2

vim.keymap.set('o', 'gv', ':<C-u>normal! gv<CR>', { silent=true })

-- Swap : and ;.
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', ':', ';')
vim.keymap.set('x', ';', ':')
vim.keymap.set('x', ':', ';')
vim.keymap.set('n', '@;', '@:')
vim.keymap.set('x', '@;', '@:')
vim.keymap.set('!', '<C-r>;', '<C-r>:')


-- Since <ESC> may be mapped to something else somewhere, it should be :map, not
-- :noremap.
vim.keymap.set('!', 'jk', '<ESC>', { remap=true })



vim.keymap.set('n', '<C-c>', ':<C-u>nohlsearch<CR>', { silent=true })



function vimrc.map_callbacks.insert_blank_line(offset)
   for i = 1, vim.v.count1 do
      F.append(F.line('.') - offset, '')
   end
end

vim.keymap.set('n', '<Plug>(my-insert-blank-lines-after)',
   'call v:lua.vimrc.map_callbacks.insert_blank_line(0)')
vim.keymap.set('n', '<Plug>(my-insert-blank-lines-before)',
   'call v:lua.vimrc.map_callbacks.insert_blank_line(1)')

vim.keymap.set('n', 'go', '<Plug>(my-insert-blank-lines-after)')
vim.keymap.set('n', 'gO', '<Plug>(my-insert-blank-lines-before)')


vim.keymap.set('n', '<Space>w', '<Cmd>update<CR>')

vim.keymap.set('n', 'Z', '<Cmd>wqall<CR>', { nowait = true })


-- `s` is used as a prefix key of plugin sandwich and hop.
vim.keymap.set('n', 's', '<Nop>')
vim.keymap.set('x', 's', '<Nop>')


-- Commands {{{1

-- Reverse a selected range in line-wise.
-- Note: directly calling `g/^/m` will overwrite the current search pattern with
-- '^' and highlight it, which is not expected.
-- :h :keeppatterns
vim.api.nvim_create_user_command(
   'Reverse',
   'keeppatterns <line1>,<line2>g/^/m<line1>-1',
   {
      desc = 'Reverse lines',
      bar = true,
      range = '%',
   }
)



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
vim.api.nvim_create_user_command(
   'SmartTabEdit',
   function(opts) vimrc.fn.smart_tabedit(opts.mods, opts.args) end,
   {
      desc = 'Smartly open a file',
      nargs = '*',
      complete = 'file',
   }
)



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
   local extra_info = vimrc.statusline.extra_info(bufnr, winid)
   local linenum = vimrc.statusline.linenum(winid)
   local fenc = vimrc.statusline.fenc(bufnr)
   local eol = vimrc.statusline.eol(bufnr)
   local ff = vimrc.statusline.ff(bufnr)
   local ft = vimrc.statusline.filetype(bufnr)
   return string.format(
      '%s %s%s%s %%= %s%s %s%s%s %s ',
      left,
      ro and ro .. ' ' or '',
      fname,
      mod and ' ' .. mod or '',
      extra_info == '' and '' or extra_info .. ' ',
      linenum,
      fenc,
      eol,
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
   if F.bufname(bufnr) == '' then
      return '[No Name]'
   end
   if vim.b[bufnr]._scratch_ then
      return '*scratch*'
   end

   local this_path = F.expand(('#%s:p'):format(bufnr))
   local other_paths = {}
   for b = 1, F.bufnr('$') do
      if F.bufexists(b) and b ~= bufnr then
         other_paths[#other_paths+1] = F.bufname(b)
      end
   end

   return uniquify.uniquify(this_path, other_paths)
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

function vimrc.statusline.extra_info(bufnr, winid)
   local autosave = F.getbufvar(bufnr, 'autosave_timer_id', -1) ~= -1
   local spell = F.getwinvar(winid, '&spell') == 1
   return (autosave and '(A)' or '') .. (spell and '(S)' or '')
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

function vimrc.statusline.eol(bufnr)
   local eol = F.getbufvar(bufnr, '&endofline')
   return eol == 0 and '[noeol]' or ''
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
   -- Libraries {{{2
   -- telescope.nvim depends on it.
   'nvim-lua/plenary.nvim',
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
   -- Filer for minimalists.
   'justinmk/vim-dirvish',
   -- Appearance {{{2
   -- Show highlight.
   'cocopon/colorswatch.vim',
   -- Makes folding text cool.
   'LeafCage/foldCC.vim',
   -- Show indentation guide.
   'lukas-reineke/indent-blankline.nvim',
   -- Highlight matched parentheses.
   'itchyny/vim-parenmatch',
   -- Tree-sitter integration.
   'nvim-treesitter/nvim-treesitter',
   -- Tree-sitter debugging.
   'nvim-treesitter/playground',
   -- Highlight specified words.
   't9md/vim-quickhl',
   -- Yet another tree-sitter indentation.
   -- TODO: uninstall it once the official nvim-treesitter provides sane indentation.
   'yioneko/nvim-yati',
   -- Filetypes {{{2
   -- Faster replacement for bundled filetype.vim
   'nathom/filetype.nvim',
   -- C/C++
   'rhysd/vim-clang-format',
   -- HTML/CSS
   'mattn/emmet-vim',
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
   -- Fuzzy finder.
   'nvim-telescope/telescope.nvim',
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
vim.keymap.set('n', 'gfa', '<Plug>(altr-forward)')




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



-- caw {{{2

G.caw_no_default_keymappings = true

vim.keymap.set('n', 'm//', '<Plug>(caw:hatpos:toggle)')
vim.keymap.set('x', 'm//', '<Plug>(caw:hatpos:toggle)')
vim.keymap.set('n', 'm/w', '<Plug>(caw:wrap:comment)')
vim.keymap.set('x', 'm/w', '<Plug>(caw:wrap:comment)')
vim.keymap.set('n', 'm/W', '<Plug>(caw:wrap:uncomment)')
vim.keymap.set('x', 'm/W', '<Plug>(caw:wrap:uncomment)')
vim.keymap.set('n', 'm/b', '<Plug>(caw:box:comment)')
vim.keymap.set('x', 'm/b', '<Plug>(caw:box:comment)')



-- clang-format {{{2

G['clang_format#auto_format'] = true

vimrc.autocmd('FileType', {
   pattern = {'javascript', 'typescript'},
   command = 'ClangFormatAutoDisable',
})



-- committia {{{2

do
   local committia_hooks = {}

   function committia_hooks.edit_open(_info)
      vim.wo.spell = true
   end

   G.committia_hooks = committia_hooks
end



-- dirvish {{{2

-- Prevent dirvish from mapping hyphen key to "<Plug>(dirvish_up)".
-- nmap  <Plug>(nomap-dirvish_up)  <Plug>(dirvish_up)



-- easyalign {{{2

vim.keymap.set('n', '=', '<Plug>(EasyAlign)')
vim.keymap.set('x', '=', '<Plug>(EasyAlign)')



-- emmet {{{2

G.user_emmet_install_global = false
vimrc.autocmd('FileType', {
   pattern = {'html', 'css'},
   command = 'EmmetInstall',
})



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

G['eskk#backup_dictionary'] = G['eskk#dictionary'].path .. '.bak'

-- NOTE:
-- Boolean values are not accepted because eskk#utils#set_default() checks types.
G['eskk#enable_completion'] = 0
G['eskk#egg_like_newline'] = 1

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
      call t.add_map(':', ':')
      call t.add_map('z:', '：')
      " Workaround: 'zl' does not work as 'l' key leaves from SKK mode.
      call t.add_map('zL', '→')
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

   " I type <C-m> for new line.
   EskkMap -type=kakutei <C-m>

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

vim.keymap.set('', '<Plug>(hop-f)', "<Cmd>lua require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR,  current_line_only = true })<CR>", { silent=true })
vim.keymap.set('', '<Plug>(hop-F)', "<Cmd>lua require('hop').hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = true })<CR>", { silent=true })
vim.keymap.set('', '<Plug>(hop-t)', "<Cmd>lua require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR,  current_line_only = true })<CR>", { silent=true })
vim.keymap.set('', '<Plug>(hop-T)', "<Cmd>lua require('hop').hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = true })<CR>", { silent=true })

vim.keymap.set('', '<Plug>(hop-s2)', "<Cmd>lua require('hop').hint_char2()<CR>", { silent=true })
vim.keymap.set('', '<Plug>(hop-n)', "<Cmd>lua require('hop').hint_patterns({ direction = require('hop.hint').HintDirection.AFTER_CURSOR  }, vim.fn.getreg('/'))<CR>", { silent=true })
vim.keymap.set('', '<Plug>(hop-N)', "<Cmd>lua require('hop').hint_patterns({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR }, vim.fn.getreg('/'))<CR>", { silent=true })
vim.keymap.set('', '<Plug>(hop-j)', "<Cmd>lua vimrc.map_callbacks.hop_jk({ direction = require('hop.hint').HintDirection.AFTER_CURSOR  })<CR>", { silent=true })
vim.keymap.set('', '<Plug>(hop-k)', "<Cmd>lua vimrc.map_callbacks.hop_jk({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR })<CR>", { silent=true })

vim.keymap.set('n', 'f', '<Plug>(hop-f)')
vim.keymap.set('o', 'f', '<Plug>(hop-f)')
vim.keymap.set('x', 'f', '<Plug>(hop-f)')
vim.keymap.set('n', 'F', '<Plug>(hop-F)')
vim.keymap.set('o', 'F', '<Plug>(hop-F)')
vim.keymap.set('x', 'F', '<Plug>(hop-F)')
vim.keymap.set('o', 't', '<Plug>(hop-t)')
vim.keymap.set('x', 't', '<Plug>(hop-t)')
vim.keymap.set('o', 'T', '<Plug>(hop-T)')
vim.keymap.set('x', 'T', '<Plug>(hop-T)')

-- Note: Don't use the following key sequences! It is used 'vim-sandwich'.
--  * sa
--  * sd
--  * sr
vim.keymap.set('n', 'ss', '<Plug>(hop-s2)')
vim.keymap.set('o', 'ss', '<Plug>(hop-s2)')
vim.keymap.set('x', 'ss', '<Plug>(hop-s2)')
vim.keymap.set('n', 'sn', '<Plug>(hop-n)')
vim.keymap.set('o', 'sn', '<Plug>(hop-n)')
vim.keymap.set('x', 'sn', '<Plug>(hop-n)')
vim.keymap.set('n', 'sN', '<Plug>(hop-N)')
vim.keymap.set('o', 'sN', '<Plug>(hop-N)')
vim.keymap.set('x', 'sN', '<Plug>(hop-N)')
vim.keymap.set('n', 'sj', '<Plug>(hop-j)')
vim.keymap.set('o', 'sj', '<Plug>(hop-j)')
vim.keymap.set('x', 'sj', '<Plug>(hop-j)')
vim.keymap.set('n', 'sk', '<Plug>(hop-k)')
vim.keymap.set('o', 'sk', '<Plug>(hop-k)')
vim.keymap.set('x', 'sk', '<Plug>(hop-k)')



-- indent-blankline.nvim {{{2

require("indent_blankline").setup {
   char_blankline = ' ',
   show_first_indent_level = false,
}



-- jplus {{{2

G['jplus#input_config'] = {
   __DEFAULT__ = { delimiter_format = ' %d ' },
   __EMPTY__ = { delimiter_format = '' },
   [' '] = { delimiter_format = ' ' },
   [','] = { delimiter_format = '%d ' },
   [':'] = { delimiter_format = '%d ' },
   [';'] = { delimiter_format = '%d ' },
   l = { delimiter_format = '' },
   L = { delimiter_format = '' },
}

vim.keymap.set('n', 'J', '<Plug>(jplus-getchar)')
vim.keymap.set('x', 'J', '<Plug>(jplus-getchar)')
vim.keymap.set('n', 'gJ', '<Plug>(jplus-input)')
vim.keymap.set('x', 'gJ', '<Plug>(jplus-input)')



-- vim-lsp {{{2

-- TODO



-- niceblock {{{2

vim.keymap.set('x', 'I', '<Plug>(niceblock-I)')
vim.keymap.set('x', 'gI', '<Plug>(niceblock-gI)')
vim.keymap.set('x', 'A', '<Plug>(niceblock-A)')






-- operator-replace {{{2

vim.keymap.set('n', '<C-p>', '<Plug>(operator-replace)')
vim.keymap.set('o', '<C-p>', '<Plug>(operator-replace)')
vim.keymap.set('x', '<C-p>', '<Plug>(operator-replace)')



-- operator-search {{{2

-- Note: m/ is the prefix of comment out.
vim.keymap.set('n', 'm?', '<Plug>(operator-search)')
vim.keymap.set('o', 'm?', '<Plug>(operator-search)')
vim.keymap.set('x', 'm?', '<Plug>(operator-search)')



-- qfreplace {{{2

vim.keymap.set('n', 'br', ':<C-u>Qfreplace SmartOpen<CR>', { silent=true })



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

vim.keymap.set('n', '"', '<Plug>(quickhl-manual-this)')
vim.keymap.set('x', '"', '<Plug>(quickhl-manual-this)')
vim.keymap.set('n', '<C-c>', ':<C-u>nohlsearch <Bar> QuickhlManualReset<CR>', { silent=true })



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


vim.keymap.set('n', 'BB', '<Plug>(quickrun)')
vim.keymap.set('x', 'BB', '<Plug>(quickrun)')




-- repeat {{{2

vim.keymap.set('n', 'U', '<Plug>(RepeatRedo)')
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

vim.api.nvim_create_user_command(
   'RG',
   'Rg<bang> <args>',
   {
      bang = true,
      bar = true,
      nargs = '*',
      complete = 'file',
   }
)


-- rust {{{2

G.rustfmt_autosave = true




-- sandwich {{{2

F['operator#sandwich#set']('add', 'all', 'highlight', 2)
F['operator#sandwich#set']('delete', 'all', 'highlight', 0)
F['operator#sandwich#set']('replace', 'all', 'highlight', 2)

do
   local rs = F['sandwich#get_recipes']()

   rs[#rs+1] = {
      buns = {'「', '」'},
      input = {'j[', 'j]'},
   }
   rs[#rs+1] = {
      buns = {'『', '』'},
      input = {'j{', 'j}'},
   }
   rs[#rs+1] = {
      buns = {'【', '】'},
      input = {'j(', 'j)'},
   }

   G['sandwich#recipes'] = rs
end



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

vim.keymap.set('o', 'aL', '<Plug>(textobj-continuous-cpp-a)')
vim.keymap.set('x', 'aL', '<Plug>(textobj-continuous-cpp-a)')
vim.keymap.set('o', 'iL', '<Plug>(textobj-continuous-cpp-i)')
vim.keymap.set('x', 'iL', '<Plug>(textobj-continuous-cpp-i)')

vimrc.autocmd('FileType', {
   pattern = 'vim',
   command = 'omap <buffer>  aL  <Plug>(textobj-continuous-vim-a)',
})
vimrc.autocmd('FileType', {
   pattern = 'vim',
   command = 'xmap <buffer>  aL  <Plug>(textobj-continuous-vim-a)',
})
vimrc.autocmd('FileType', {
   pattern = 'vim',
   command = 'omap <buffer>  iL  <Plug>(textobj-continuous-vim-i)',
})
vimrc.autocmd('FileType', {
   pattern = 'vim',
   command = 'xmap <buffer>  iL  <Plug>(textobj-continuous-vim-i)',
})



-- textobj-lastpaste {{{2

G.textobj_lastpaste_no_default_key_mappings = true

vim.keymap.set('o', 'iP', '<Plug>(textobj-lastpaste-i)')
vim.keymap.set('x', 'iP', '<Plug>(textobj-lastpaste-i)')
vim.keymap.set('o', 'aP', '<Plug>(textobj-lastpaste-a)')
vim.keymap.set('x', 'aP', '<Plug>(textobj-lastpaste-a)')



-- textobj-space {{{2

G.textobj_space_no_default_key_mappings = true

vim.keymap.set('o', 'a<Space>', '<Plug>(textobj-space-a)')
vim.keymap.set('x', 'a<Space>', '<Plug>(textobj-space-a)')
vim.keymap.set('o', 'i<Space>', '<Plug>(textobj-space-i)')
vim.keymap.set('x', 'i<Space>', '<Plug>(textobj-space-i)')


-- textobj-wiw {{{2

G.textobj_wiw_no_default_key_mappings = true

vim.keymap.set('n', '<C-w>', '<Plug>(textobj-wiw-n)')
vim.keymap.set('o', '<C-w>', '<Plug>(textobj-wiw-n)')
vim.keymap.set('x', '<C-w>', '<Plug>(textobj-wiw-n)')
vim.keymap.set('n', 'g<C-w>', '<Plug>(textobj-wiw-p)')
vim.keymap.set('o', 'g<C-w>', '<Plug>(textobj-wiw-p)')
vim.keymap.set('x', 'g<C-w>', '<Plug>(textobj-wiw-p)')
vim.keymap.set('n', '<C-e>', '<Plug>(textobj-wiw-N)')
vim.keymap.set('o', '<C-e>', '<Plug>(textobj-wiw-N)')
vim.keymap.set('x', '<C-e>', '<Plug>(textobj-wiw-N)')
vim.keymap.set('n', 'g<C-e>', '<Plug>(textobj-wiw-P)')
vim.keymap.set('o', 'g<C-e>', '<Plug>(textobj-wiw-P)')
vim.keymap.set('x', 'g<C-e>', '<Plug>(textobj-wiw-P)')

vim.keymap.set('o', 'a<C-w>', '<Plug>(textobj-wiw-a)')
vim.keymap.set('x', 'a<C-w>', '<Plug>(textobj-wiw-a)')
vim.keymap.set('o', 'i<C-w>', '<Plug>(textobj-wiw-i)')
vim.keymap.set('x', 'i<C-w>', '<Plug>(textobj-wiw-i)')



-- nvim-treesitter {{{2

require('nvim-treesitter.configs').setup {
   ensure_installed = 'all',
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
   yati = {
      enable = true,
   },
}



-- window-adjuster {{{2

vim.keymap.set('n', 'tRw', '<Cmd>AdjustScreenWidth<CR>')
vim.keymap.set('n', 'tRh', '<Cmd>AdjustScreenHeight<CR>')
vim.keymap.set('n', 'tRr', ':<C-u>AdjustScreenWidth <Bar> AdjustScreenHeight<CR>', { silent=true })





-- yankround {{{2

G.yankround_dir = my_env.yankround_dir
G.yankround_use_region_hl = true
