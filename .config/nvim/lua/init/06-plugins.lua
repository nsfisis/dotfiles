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
      -- This file is copied to under home directory by Home Manager.
      -- Because Home Manager will make it read-only, I directly modify a file under the "dotfiles" repository.
      lockfile = require('vimrc.my_env').home .. "/dotfiles/.config/nvim/lazy-lock.json",
      -- Overrides ui.icons to avoid using Nerd Font.
      ui = {
         icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            require = "🌙",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
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
