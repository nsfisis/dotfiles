local vimrc = {}



local autocmd_callbacks = {}
vimrc.autocmd_callbacks = autocmd_callbacks

function vimrc.autocmd(event, filter, callback)
   local callback_id = #autocmd_callbacks + 1
   autocmd_callbacks[callback_id] = callback
   vim.cmd(('autocmd Vimrc %s %s lua vimrc.autocmd_callbacks[%d]()'):format(
      event,
      filter,
      callback_id))
end



return vimrc
