local M = {}

local F = vim.fn
local V = vim.v


function M.indentexpr()
   local lnum = V.lnum
   if lnum == 0 then
      return 0
   end
   return F.indent(lnum - 1)
end


return M
