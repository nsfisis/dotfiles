local F = vim.fn
local G = vim.g
local O = vim.o
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


-- :SmartOpen {{{1

C(
   'SmartOpen',
   function(opts)
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
      ]]):format(modifiers, opts.args))
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
   end,
   {
      desc = 'Smartly open a new buffer',
      nargs = '+',
      complete = 'command',
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
