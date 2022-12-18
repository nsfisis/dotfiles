--- Disable standard plugins. {{{1

vim.g.loaded_gzip             = 1
vim.g.loaded_matchparen       = 1
vim.g.loaded_netrw            = 1
vim.g.loaded_netrwPlugin      = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tarPlugin        = 1
vim.g.loaded_zipPlugin        = 1


--- Load and configure third-party plugins. {{{1
vim.api.nvim_create_user_command(
   'PackerSync',
   function() require('vimrc.plugins').sync() end,
   {
      desc = '[packer.nvim] Synchronize plugins',
   }
)
vimrc.autocmd('BufWritePost', {
   pattern = {'plugins.lua'},
   callback = function()
      vim.cmd('source <afile>')
      vimrc.autocmd('User', {
         pattern = 'PackerCompileDone',
         command = 'echo "[packer] Finished compiling lazy-loaders!"'
      })
      require('vimrc.plugins').compile()
   end,
})
