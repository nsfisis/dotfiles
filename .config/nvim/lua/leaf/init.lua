local M = {}


local A = vim.api
local F = vim.fn

local TASK_STATUS_PATTERN = [=[\[[ x-]\] ]=]
local TASK_STATUS_PATTERN_EXCEPT_DONE = [=[\[[ -]\] ]=]
local TASK_STATUS_PATTERN_EXCEPT_CANCELED = [=[\[[ x]\] ]=]
-- op = T
--    T => T
--    D => T
--    C => T
-- op = D
--    T => D
--    D => D
--    C => C
-- op = C
--    T => C
--    D => D
--    C => C


local function vim_match(s, pattern)
   return vim.regex(pattern):match_str(s)
end

local function switch_task_status_internal(line_num, op, is_subtask)
   local line = F.getline(line_num)
   local pattern
   if is_subtask then
      if op == ' ' then
         pattern = TASK_STATUS_PATTERN
      elseif op == 'x' then
         pattern = TASK_STATUS_PATTERN_EXCEPT_CANCELED
      elseif op == '-' then
         pattern = TASK_STATUS_PATTERN_EXCEPT_DONE
      else
         assert('unexpected op: ' .. tostring(op))
      end
   else
      pattern = TASK_STATUS_PATTERN
   end
   if vim_match(line, pattern) then
      local replacement = ('[%s] '):format(op)
      F.setline(line_num, F.substitute(line, pattern, replacement, ''))
      return true
   else
      return false
   end
end


function M.checkbox(check, char)
   local line = F.getline('.')
   if vim_match(line, [[^\s*$]]) and #line % F.shiftwidth() == 0 then
      return check and '[x] ' or '[ ] '
   else
      return char
   end
end

function M.switch_task_status(op)
   switch_task_status_internal(F.line('.'), op)
end

function M.switch_task_status_rec(op)
   local current_line_num = F.line('.')
   local replaced = switch_task_status_internal(current_line_num, op)
   if not replaced then
      return
   end
   local last_line_num = F.line('$')
   if current_line_num == last_line_num then
      return
   end

   local base_indent_level = F.indent('.')
   for l = current_line_num + 1, last_line_num do
      if F.indent(l) <= base_indent_level then
         break
      end
      switch_task_status_internal(l, op, true)
   end
end


return M
