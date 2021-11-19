vimrc.after_ftplugin('leaf', function(conf)
   vim.wo.foldlevel = 1

   vim.b.caw_oneline_comment = '#'

   if vim.fn.exists(':AutosaveEnable') == 2 then
      vim.cmd('AutosaveEnable')
   end

   vim.cmd([=[
   nmap <buffer>  ,t  <Plug>(leaf-switch-task-status-to-todo)
   nmap <buffer>  ,T  <Plug>(leaf-switch-task-status-to-todo-rec)
   nmap <buffer>  ,d  <Plug>(leaf-switch-task-status-to-done)
   nmap <buffer>  ,D  <Plug>(leaf-switch-task-status-to-done-rec)
   nmap <buffer>  ,c  <Plug>(leaf-switch-task-status-to-canceled)
   nmap <buffer>  ,C  <Plug>(leaf-switch-task-status-to-canceled-rec)
   ]=])
end)
