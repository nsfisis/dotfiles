local F = vim.fn
local C = vim.api.nvim_create_user_command


-- :Reverse {{{1

-- Reverse a selected range in line-wise.
-- Note: directly calling `g/^/m` will overwrite the current search pattern with
-- '^' and highlight it, which is not expected.
-- :h :keeppatterns
C(
   'Reverse',
   'keeppatterns <line1>,<line2>g/^/m<line1>-1',
   {
      desc = 'Reverse lines',
      bar = true,
      range = '%',
   }
)


-- :SmartTabEdit {{{1

-- If the current buffer is empty, open a file with the current window;
-- otherwise open a new tab.
C(
   'SmartTabEdit',
   function(opts)
      local is_empty_buffer = (
         F.bufname() == ''
         and not vim.bo.modified
         and F.line('$') <= 1
         and F.getline('.') == ''
      )

      if is_empty_buffer then
         vim.cmd(opts.mods .. ' edit ' .. opts.args)
      else
         vim.cmd(opts.mods .. ' tabedit ' .. opts.args)
      end
   end,
   {
      desc = 'Smartly open a file',
      nargs = '*',
      complete = 'file',
   }
)
