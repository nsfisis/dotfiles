-- It is inspired by the same name functionality in Emacs,
-- but I don't refer to or reuse the source code.

local M = {}

local matchlist, split = vim.fn.matchlist, vim.fn.split
local stricmp = vim.stricmp


function M.uniquify(this_path, other_paths)
   -- Filter out the same paths.
   other_paths = vim.iter(other_paths)
      :filter(function(p) return p ~= this_path end)
      :totable()

   -- Split each path into slash-separated parts.
   for i = 1, #other_paths do
      other_paths[i] = split(other_paths[i], '[\\/]')
   end
   this_path = split(this_path, '[\\/]')

   local depth = 0
   while depth < #this_path-1 do
      local unique = true
      for _, other_path in ipairs(other_paths) do
         local same = true
         for i = 0, depth do
            local this_path_part = this_path[#this_path-i]
            local other_path_part = other_path[#other_path-i] or ''
            if stricmp(this_path_part, other_path_part) ~= 0 then
               same = false
               break
            end
         end
         if same then
            unique = false
            break
         end
      end
      if unique then
         break
      end
      depth = depth+1
   end

   local ret = {}
   for i = depth, 0, -1 do
      if i == depth or i == 0 then
         ret[#ret+1] = this_path[#this_path-i]
      else
         ret[#ret+1] = matchlist(this_path[#this_path-i], '.')[1]
      end
   end
   return table.concat(ret, '/')
end


return M
