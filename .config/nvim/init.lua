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



-- Environment {{{2

local my_env = require('my_env')
my_env.mkdir()



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

-- Go elsewhere without dividing the undo history.
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


vimrc.cabbrev('S', '%s')



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


-- Lua function cannot be set to 'operatorfunc' for now.
vim.cmd([[
   function! Vimrc_insert_black_line_below(type = '') abort
      if a:type ==# ''
         set operatorfunc=Vimrc_insert_black_line_below
         return 'g@ '
      else
         for i in range(v:count1)
            call append(line('.'), '')
         endfor
      endif
   endfunction
   function! Vimrc_insert_black_line_above(type = '') abort
      if a:type ==# ''
         set operatorfunc=Vimrc_insert_black_line_above
         return 'g@ '
      else
         for i in range(v:count1)
            call append(line('.') - 1, '')
         endfor
      endif
   endfunction
]])
vim.keymap.set('n', 'go', F.Vimrc_insert_black_line_below, { expr = true })
vim.keymap.set('n', 'gO', F.Vimrc_insert_black_line_above, { expr = true })


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

-- Disable standard plugins. {{{2

G.loaded_gzip             = 1
G.loaded_matchparen       = 1
G.loaded_netrw            = 1
G.loaded_netrwPlugin      = 1
G.loaded_spellfile_plugin = 1
G.loaded_tarPlugin        = 1
G.loaded_zipPlugin        = 1



-- Load and configure third-party plugins. {{{2

vim.api.nvim_create_user_command(
   'PackerSync',
   function() require('plugins').sync() end,
   {
      desc = '[packer.nvim] Synchronize plugins',
   }
)
vimrc.autocmd('BufWritePost', {
   pattern = {'plugins.lua'},
   callback = function()
      vimrc.autocmd('User', {
         pattern = 'PackerCompileDone',
         command = 'echo "[packer] Finished compiling lazy-loaders!"'
      })
      require('plugins').compile()
   end,
})
