local F = vim.fn
local O = vim.o
local vimrc = require('vimrc')
local A = vimrc.autocmd


vimrc.create_augroup_for_vimrc()


-- Auto-resize windows when Vim is resized.
A('VimResized', {
   command = 'wincmd =',
})


-- Calculate 'numberwidth' to fit file size.
-- Note: extra 2 is the room of left and right spaces.
A({'BufEnter', 'WinEnter', 'BufWinEnter'}, {
   callback = function()
      vim.wo.numberwidth = #tostring(F.line('$')) + 2
   end,
})


-- Jump to the last cursor position when you open a file.
A('BufRead', {
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
A('BufWritePre', {
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
