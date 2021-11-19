local M = {}


local F = vim.fn
local V = vim.v


local function find_plain_string(haystack, needle, start)
   return haystack:find(needle, start or 1, true)
end


function M.foldexpr()
   local current_line_indent = F.indent(V.lnum)
   local task_level = math.floor(current_line_indent / F.shiftwidth())
   if V.lnum == F.line('$') then
      return task_level
   end
   local next_line_indent = F.indent(V.lnum + 1)
   if current_line_indent < next_line_indent then
      return ('>%d'):format(task_level + 1)
   else
      return task_level
   end
end


function M.foldtext()
   local foldstart = V.foldstart
   local foldend = V.foldend
   local shiftwidth = F.shiftwidth()
   local current_line_indent = F.indent(foldstart)

   local todo = 0
   local done = 0
   for i = foldstart + 1, foldend do
      local line = F.getline(i)
      local line_indent = F.indent(i)
      if line_indent == current_line_indent + shiftwidth then
         if find_plain_string(line, '[x] ') then
            done = done + 1
         elseif find_plain_string(line, '[ ] ') then
            todo = todo + 1
         elseif find_plain_string(line, '[-] ') then
            done = done + 1
         end
      end
   end

   local progress
   if done + todo == 0 then
      progress = '...'
   else
      progress = ('  [%d/%d]'):format(done, done + todo)
   end
   return F.getline(foldstart) .. progress
end


return M
