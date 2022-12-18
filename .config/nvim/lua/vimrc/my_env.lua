local M = {}

local V = vim
local E = V.env
local F = V.fn

if F.has('unix') then
   M.os = 'unix'
elseif F.has('mac') then
   M.os = 'mac'
elseif F.has('wsl') then
   M.os = 'wsl'
elseif F.has('win32') or F.has('win64') then
   M.os = 'windows'
else
   M.os = 'unknown'
end

M.home = E.HOME or F.expand('~')

M.config_home = E.XDG_CONFIG_HOME or E.HOME .. '/.config'

M.config_dir = F.stdpath('config')
M.cache_dir = F.stdpath('cache')
M.data_dir = F.stdpath('data')

M.backup_dir = M.data_dir .. '/backup'
M.yankround_dir = M.data_dir .. '/yankround'

M.skk_dir = M.config_home .. '/skk'
M.scratch_dir = M.home .. '/scratch'

function M.mkdir()
   for k, v in pairs(M) do
      if V.endswith(k, '_dir') and F.isdirectory(v) == 0 then
         F.mkdir(v, 'p')
      end
   end
end

return M
