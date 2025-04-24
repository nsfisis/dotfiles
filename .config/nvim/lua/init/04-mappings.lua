local F = vim.fn
local G = vim.g
local O = vim.o
local K = vim.keymap

local vimrc = require('vimrc')
local my_env = require('vimrc.my_env')


-- Note: |:noremap| defines mappings in |Normal|, |Visual|, |Operator-Pending|
-- and |Select| mode. Because I don't use |Select| mode, I use |:noremap|
-- instead of |:nnoremap|, |:xnoremap| and |:onoremap| for simplicity.


-- Searching {{{1

-- Fix direction of n and N.
K.set('', 'n', "v:searchforward ? 'n' : 'N'", { expr=true })
K.set('', 'N', "v:searchforward ? 'N' : 'n'", { expr=true })

K.set('', 'gn', "v:searchforward ? 'gn' : 'gN'", { expr=true })
K.set('', 'gN', "v:searchforward ? 'gN' : 'gn'", { expr=true })

K.set({'n', 'x'}, '&', '<Cmd>%&&<CR>')


-- Registers and macros. {{{1

-- Access an resister in the same way in Insert and Commandline mode.
K.set({'n', 'x'}, '<C-r>', '"')

F.setreg('j', 'j.')
F.setreg('k', 'k.')
F.setreg('n', 'n.')
F.setreg('m', 'N.')
K.set('n', '@N', '@m')

-- Repeat the last executed macro as many times as possible.
-- a => all
K.set('n', '@a', '9999@@')

-- Execute the last executed macro again.
K.set('n', '`', '@@')


-- Emacs like key mappings in Insert and CommandLine mode. {{{1

K.set('i', '<C-d>', '<Del>')

-- Go elsewhere without dividing the undo history.
K.set('i', '<C-b>', '<C-g>U<Left>')
K.set('i', '<C-f>', '<C-g>U<Right>')

-- Delete something deviding the undo history.
K.set('i', '<C-u>', '<C-g>u<C-u>')
K.set('i', '<C-w>', '<C-g>u<C-w>')

K.set('c', '<C-a>', '<Home>')
K.set('c', '<C-e>', '<End>')
K.set('c', '<C-f>', '<Right>')
K.set('c', '<C-b>', '<Left>')
K.set('c', '<C-n>', '<Down>')
K.set('c', '<C-p>', '<Up>')
K.set('c', '<C-d>', '<Del>')

K.set({'c', 'i'}, '<Left>', '<Nop>')
K.set({'c', 'i'}, '<Right>', '<Nop>')



K.set('n', 'gA', function()
   local line = F.getline('.')
   if vim.endswith(line, ';;') then -- for OCaml
      return 'A<C-g>U<Left><C-g>U<Left>'
   elseif vim.regex('[,;)]$'):match_str(line) then
      return 'A<C-g>U<Left>'
   else
      return 'A'
   end
end, { expr=true, replace_keycodes=true })



-- QuickFix or location list. {{{1

K.set('n', 'bb', '<Cmd>cc<CR>')

K.set('n', 'bn', ':<C-u><C-r>=v:count1<CR>cnext<CR>', { silent = true })
K.set('n', 'bp', ':<C-u><C-r>=v:count1<CR>cprevious<CR>', { silent = true })

K.set('n', 'bf', '<Cmd>cfirst<CR>')
K.set('n', 'bl', '<Cmd>clast<CR>')

K.set('n', 'bS', '<Cmd>colder<CR>')
K.set('n', 'bs', '<Cmd>cnewer<CR>')



-- Operators {{{1

-- Throw deleted text into the black hole register ("_).
K.set({'n', 'x'}, 'c', '"_c')
K.set({'n', 'x'}, 'C', '"_C')


K.set('', 'g=', '=')


K.set('', 'ml', 'gu')
K.set('', 'mu', 'gU')

K.set('', 'gu', '<Nop>')
K.set('', 'gU', '<Nop>')
K.set('x', 'u', '<Nop>')
K.set('x', 'U', '<Nop>')


K.set('x', 'x', '"_x')


K.set('n', 'Y', 'y$')
-- In Blockwise-Visual mode, select text linewise.
-- By default, select text characterwise, neither blockwise nor linewise.
K.set('x', 'Y', "mode() ==# 'V' ? 'y' : 'Vy'", { expr=true })



-- Swap the keys entering Replace mode and Visual-Replace mode.
K.set('n', 'R', 'gR')
K.set('n', 'gR', 'R')
K.set('n', 'r', 'gr')
K.set('n', 'gr', 'r')


K.set('n', 'U', '<C-r>')




-- Motions {{{1

K.set('', 'H', '^')
K.set('', 'L', '$')
K.set('', 'M', '%')

K.set('', 'gw', 'b')
K.set('', 'gW', 'B')

K.set('', 'k', 'gk')
K.set('', 'j', 'gj')
K.set('', 'gk', 'k')
K.set('', 'gj', 'j')

K.set('n', 'gff', 'gF')



-- Completions {{{1

-- '/' works as '<C-x><C-f>' does during file completion.
-- https://zenn.dev/kawarimidoll/articles/54e38aa7f55aff
K.set('i', '/', function()
   local complete_info = vim.fn.complete_info({'mode', 'selected'})
   if complete_info.mode == 'files' and 0 <= complete_info.selected then
      return '<C-x><C-f>'
   else
      return '/'
   end
end, { expr = true })



-- Tabpages and windows. {{{1

local function move_current_window_to_tabpage()
   if F.winnr('$') == 1 then
      -- Leave the current window and open it in a new tabpage.
      -- Because :wincmd T fails when the current tabpage has only one window.
      vim.cmd('tab split')
   else
      -- Close the current window and re-open it in a new tabpage.
      vim.cmd('wincmd T')
   end
end


local function choose_window_interactively()
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


K.set('n', 'tt', '<Cmd>tabnew<CR>')
K.set('n', 'tT', move_current_window_to_tabpage)

K.set('n', 'tn', ":<C-u><C-r>=(tabpagenr() + v:count1 - 1) % tabpagenr('$') + 1<CR>tabnext<CR>", { silent=true })
K.set('n', 'tp', ":<C-u><C-r>=(tabpagenr('$') * 10 + tabpagenr() - v:count1 - 1) % tabpagenr('$') + 1<CR>tabnext<CR>", { silent=true })

K.set('n', 'tN', '<Cmd>tabmove +<CR>')
K.set('n', 'tP', '<Cmd>tabmove -<CR>')

K.set('n', 'tsh', '<Cmd>leftabove vsplit<CR>')
K.set('n', 'tsj', '<Cmd>rightbelow split<CR>')
K.set('n', 'tsk', '<Cmd>leftabove split<CR>')
K.set('n', 'tsl', '<Cmd>rightbelow vsplit<CR>')

K.set('n', 'tsH', '<Cmd>topleft vsplit<CR>')
K.set('n', 'tsJ', '<Cmd>botright split<CR>')
K.set('n', 'tsK', '<Cmd>topleft split<CR>')
K.set('n', 'tsL', '<Cmd>botright vsplit<CR>')

K.set('n', 'twh', '<Cmd>leftabove vnew<CR>')
K.set('n', 'twj', '<Cmd>rightbelow new<CR>')
K.set('n', 'twk', '<Cmd>leftabove new<CR>')
K.set('n', 'twl', '<Cmd>rightbelow vnew<CR>')

K.set('n', 'twH', '<Cmd>topleft vnew<CR>')
K.set('n', 'twJ', '<Cmd>botright new<CR>')
K.set('n', 'twK', '<Cmd>topleft new<CR>')
K.set('n', 'twL', '<Cmd>botright vnew<CR>')

K.set('n', 'th', '<C-w>h')
K.set('n', 'tj', '<C-w>j')
K.set('n', 'tk', '<C-w>k')
K.set('n', 'tl', '<C-w>l')

K.set('n', 'tH', '<C-w>H')
K.set('n', 'tJ', '<C-w>J')
K.set('n', 'tK', '<C-w>K')
K.set('n', 'tL', '<C-w>L')

K.set('n', 'tx', '<C-w>x')

-- r => manual resize.
-- R => automatic resize.
K.set('n', 'tRH', '<C-w>_')
K.set('n', 'tRW', '<C-w><Bar>')
K.set('n', 'tRR', '<C-w>_<C-w><Bar>')

K.set('n', 't=', '<C-w>=')

K.set('n', 'tq', '<Cmd>bdelete<CR>')

K.set('n', 'tc', '<C-w>c')

K.set('n', 'to', '<C-w>o')
K.set('n', 'tO', '<Cmd>tabonly<CR>')

K.set('n', 'tg', choose_window_interactively)



-- Toggle options {{{1

K.set('n', 'T', '<Nop>')

K.set('n', 'Ta', '<Cmd>AutosaveToggle<CR>')
K.set('n', 'Tb', '<Cmd>if &background == "dark" <Bar>set background=light <Bar>else <Bar>set background=dark <Bar>endif<CR>')
K.set('n', 'Tc', '<Cmd>set cursorcolumn! <Bar>set cursorline!<CR>')
K.set('n', 'Td', '<Cmd>if &diff <Bar>diffoff <Bar>else <Bar>diffthis <Bar>endif<CR>')
K.set('n', 'Te', '<Cmd>set expandtab!<CR>')
K.set('n', 'Th', '<Cmd>set hlsearch!<CR>')
K.set('n', 'Tl', '<Cmd>if &laststatus ==# 3 <Bar>set laststatus=2 <Bar>else <Bar>set laststatus=3 <Bar>endif<CR>')
K.set('n', 'Tn', '<Cmd>set number!<CR>')
K.set('n', 'Ts', '<Cmd>set spell!<CR>')
K.set('n', 'T8', '<Cmd>if &textwidth ==# 80 <Bar>set textwidth=0 <Bar>else <Bar>set textwidth=80 <Bar>endif<CR>')
K.set('n', 'T0', '<Cmd>if &textwidth ==# 100 <Bar>set textwidth=0 <Bar>else <Bar>set textwidth=100 <Bar>endif<CR>')
K.set('n', 'T2', '<Cmd>if &textwidth ==# 120 <Bar>set textwidth=0 <Bar>else <Bar>set textwidth=120 <Bar>endif<CR>')
K.set('n', 'Tw', '<Cmd>set wrap!<CR>')

K.set('n', 'TA', 'Ta', { remap = true })
K.set('n', 'TB', 'Tb', { remap = true })
K.set('n', 'TC', 'Tc', { remap = true })
K.set('n', 'TD', 'Td', { remap = true })
K.set('n', 'TE', 'Te', { remap = true })
K.set('n', 'TH', 'Th', { remap = true })
K.set('n', 'TL', 'Tl', { remap = true })
K.set('n', 'TN', 'Tn', { remap = true })
K.set('n', 'TS', 'Ts', { remap = true })
K.set('n', 'TW', 'Tw', { remap = true })



-- Increment/decrement numbers {{{1

-- nnoremap  +  <C-a>
-- nnoremap  -  <C-x>
-- xnoremap  +  <C-a>
-- xnoremap  -  <C-x>
-- xnoremap  g+  g<C-a>
-- xnoremap  g-  g<C-x>



-- Open *scratch* buffer {{{1

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

local function open_scratch()
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
   function() open_scratch() end,
   {
      desc = 'Open a *scratch* buffer',
   }
)

K.set('n', '<Space>s', '<Cmd>Scratch<CR>')



-- Disable unuseful or dangerous mappings. {{{1

-- Disable Select mode.
K.set('n', 'gh', '<Nop>')
K.set('n', 'gH', '<Nop>')
K.set('n', 'g<C-h>', '<Nop>')

-- Disable Ex mode.
K.set('n', 'Q', '<Nop>')
K.set('n', 'gQ', '<Nop>')

K.set('n', 'ZZ', '<Nop>')
K.set('n', 'ZQ', '<Nop>')


-- Help {{{1

-- Search help.
K.set('n', '<C-h>', ':<C-u>SmartOpen help<Space>')



-- For writing Vim script. {{{1

K.set('n', 'XV', '<Cmd>SmartTabEdit $MYVIMRC<CR>')

-- See |numbered-function|.
K.set('n', 'XF', ':<C-u>function {<C-r>=v:count<CR>}<CR>', { silent=true })

K.set('n', 'XM', '<Cmd>messages<CR>')







-- Abbreviations {{{1

vimrc.iabbrev('TOOD', 'TODO')
vimrc.iabbrev('retrun', 'return')
vimrc.iabbrev('reutrn', 'return')
vimrc.iabbrev('tihs', 'this')


vimrc.cabbrev('S', '%s')



-- Misc. {{{1

K.set('o', 'gv', ':<C-u>normal! gv<CR>', { silent=true })

-- Swap : and ;.
K.set('n', ';', ':')
K.set('n', ':', ';')
K.set('x', ';', ':')
K.set('x', ':', ';')
K.set('n', '@;', '@:')
K.set('x', '@;', '@:')
K.set('!', '<C-r>;', '<C-r>:')


-- Since <ESC> may be mapped to something else somewhere, it should be :map, not
-- :noremap.
K.set('!', 'jk', '<ESC>', { remap=true })



K.set('n', '<C-c>', ':<C-u>nohlsearch<CR>', { silent=true })


-- "remap" flag is needed because [<Space> and ]<Space> are implemented by Lua functions.
K.set('n', 'go', ']<Space>', { remap = true })
K.set('n', 'gO', '[<Space>', { remap = true })


K.set('n', '<Space>w', '<Cmd>update<CR>')

K.set('n', 'Z', '<Cmd>wqall<CR>', { nowait = true })


-- `s` is used as a prefix key of plugin sandwich and hop.
K.set('n', 's', '<Nop>')
K.set('x', 's', '<Nop>')
