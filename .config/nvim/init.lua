--[========================================[--
--                                          --
--      _       _ _     _                   --
--     (_)_ __ (_) |_  | |_   _  __ _       --
--     | | '_ \| | __| | | | | |/ _` |      --
--     | | | | | | |_ _| | |_| | (_| |      --
--     |_|_| |_|_|\__(_)_|\__,_|\__,_|      --
--                                          --
--]========================================]--

-- Fast Lua loader (experimental):
-- https://github.com/neovim/neovim/pull/22668
if vim.loader then vim.loader.enable() end

require('init.00-bootstrap')
require('init.01-options')
require('init.02-commands')
require('init.03-autocmds')
require('init.04-mappings')
require('init.05-appearance')
require('init.06-plugins')
