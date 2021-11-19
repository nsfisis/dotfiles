scriptencoding utf-8

if exists('b:did_ftplugin_leaf')
    finish
endif


inoremap <buffer> <expr>  <Space>  v:lua.require'leaf'.checkbox(v:false, ' ')
inoremap <buffer> <expr>  x        v:lua.require'leaf'.checkbox(v:true, 'x')

nnoremap <buffer>  <Plug>(leaf-switch-task-status-to-todo)          <Cmd>lua require'leaf'.switch_task_status(' ')<CR>
nnoremap <buffer>  <Plug>(leaf-switch-task-status-to-todo-rec)      <Cmd>lua require'leaf'.switch_task_status_rec(' ')<CR>
nnoremap <buffer>  <Plug>(leaf-switch-task-status-to-done)          <Cmd>lua require'leaf'.switch_task_status('x')<CR>
nnoremap <buffer>  <Plug>(leaf-switch-task-status-to-done-rec)      <Cmd>lua require'leaf'.switch_task_status_rec('x')<CR>
nnoremap <buffer>  <Plug>(leaf-switch-task-status-to-canceled)      <Cmd>lua require'leaf'.switch_task_status('-')<CR>
nnoremap <buffer>  <Plug>(leaf-switch-task-status-to-canceled-rec)  <Cmd>lua require'leaf'.switch_task_status_rec('-')<CR>


setlocal foldmethod=expr
setlocal foldexpr=v:lua.require'leaf.fold'.foldexpr()
setlocal foldtext=v:lua.require'leaf.fold'.foldtext()


let b:did_ftplugin_leaf = 1
