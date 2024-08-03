--- Disable standard plugins. {{{1

vim.g.loaded_gzip             = 1
vim.g.loaded_matchparen       = 1
vim.g.loaded_netrw            = 1
vim.g.loaded_netrwPlugin      = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tarPlugin        = 1
vim.g.loaded_zipPlugin        = 1


--- Load and configure third-party plugins. {{{1
local lazy_path = require('vimrc.my_env').data_dir .. '/lazy/lazy.nvim'
if vim.loop.fs_stat(lazy_path) then
   vim.opt.rtp:prepend(lazy_path)
   require('lazy').setup('vimrc.plugins', {
      ui = {
         icons = {
            cmd = "⌘",
            config = "",
            event = "",
            ft = "",
            init = "",
            keys = "",
            plugin = "",
            runtime = "",
            source = "",
            start = "",
            task = "",
            lazy = " ",
         },
      },
      change_detection = {
         enabled = false,
      },
   })
else
   vim.api.nvim_create_user_command(
      'LazySetup',
      function()
         vim.fn.system({
            'git',
            'clone',
            '--filter=blob:none',
            'https://github.com/folke/lazy.nvim.git',
            '--branch=stable',
            lazy_path,
         })
      end,
      {
         desc = '[lazy.nvim] Setup itself',
      }
   )
end
