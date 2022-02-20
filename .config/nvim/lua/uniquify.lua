-- It is inspired by the same name functionality in Emacs,
-- but I don't refer to or reuse the source code.

local M = {}

local matchlist, split = vim.fn.matchlist, vim.fn.split
local stricmp = vim.stricmp


function M.uniquify(this_path, other_paths)
   -- Split each path into slash-separated parts.
   for i = 1, #other_paths do
      other_paths[i] = split(other_paths[i], '[\\/]')
   end
   this_path = split(this_path, '[\\/]')

   local i = 0
   while true do
      local this_path_part = this_path[#this_path+i] or ''
      local unique = true
      local no_parts_remained = true
      for _, other_path in ipairs(other_paths) do
         local other_path_part = other_path[#other_path+i] or ''
         if stricmp(this_path_part, other_path_part) == 0 then
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
         ret = ret .. '/' .. matchlist(this_path[#this_path+k], '.')[1]
      end
   end
   return ret:sub(2)
end


return M
