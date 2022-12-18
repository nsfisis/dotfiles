vimrc.after_ftplugin('leaf', function(conf)
   vim.wo.foldlevel = 1

   vim.b.caw_oneline_comment = '#'

   if vim.fn.exists(':AutosaveEnable') == 2 then
      vim.cmd('AutosaveEnable')
   end

   vim.cmd([=[
   nnoremap <buffer>  ,t  <Plug>(leaf-switch-task-status-to-todo)
   nnoremap <buffer>  ,T  <Plug>(leaf-switch-task-status-to-todo-rec)
   nnoremap <buffer>  ,d  <Plug>(leaf-switch-task-status-to-done)
   nnoremap <buffer>  ,D  <Plug>(leaf-switch-task-status-to-done-rec)
   nnoremap <buffer>  ,c  <Plug>(leaf-switch-task-status-to-canceled)
   nnoremap <buffer>  ,C  <Plug>(leaf-switch-task-status-to-canceled-rec)
   ]=])
end)
