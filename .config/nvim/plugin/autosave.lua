if vim.g.loaded_autosave then
   return
end

vim.api.nvim_create_user_command(
   'AutosaveEnable',
   function() require('autosave').enable() end,
   {
      desc = '[Autosave] enable autosaving',
      bar = true,
   }
)
vim.api.nvim_create_user_command(
   'AutosaveDisable',
   function() require('autosave').disable() end,
   {
      desc = '[Autosave] disable autosaving',
      bar = true,
   }
)
vim.api.nvim_create_user_command(
   'AutosaveToggle',
   function() require('autosave').toggle() end,
   {
      desc = '[Autosave] toggle autosaving',
      bar = true,
   }
)

vim.g.loaded_autosave = true
