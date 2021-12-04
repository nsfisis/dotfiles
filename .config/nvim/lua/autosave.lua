local M = {}


local INTERVAL_MS = 10 * 1000
local SILENT = false


-- Because a timer cannot be converted to Vim value,
-- store indice of timers instead of timer instances.
local timers = {}


local function echo(text, hl_group)
   if SILENT then return end

   vim.api.nvim_echo({{ text, hl_group }}, false, {})
end


local function handler()
   if not vim.bo.modified then
      return
   end
   if vim.bo.readonly then
      return
   end
   if vim.bo.buftype ~= '' then
      return
   end
   if vim.fn.bufname() == '' then
      return
   end

   echo('Auto-saving...', 'Comment')
   vim.cmd('silent! write')
   echo('Saved.', 'Comment')
end


function M.enable()
   if vim.b.autosave_timer_id then
      return
   end

   local timer = vim.loop.new_timer()
   timer:start(INTERVAL_MS, INTERVAL_MS, vim.schedule_wrap(handler))
   local tid = #timers + 1
   timers[tid] = timer
   vim.b.autosave_timer_id = tid
end


function M.disable()
   if not vim.b.autosave_timer_id then
      return
   end

   local tid = vim.b.autosave_timer_id
   vim.b.autosave_timer_id = nil
   if not timers[tid] then
      return
   end
   timers[tid]:close()
   timers[tid] = nil
end


function M.toggle()
   if vim.b.autosave_timer_id then
      M.disable()
   else
      M.enable()
   end
end


return M
