vimrc.after_ftplugin('qf', function(conf)
   vim.cmd([=[
   nnoremap <buffer> p <CR>zz<C-w>p
   nnoremap <silent> <buffer> dd :call Qf_del_entry()<CR>
   xnoremap <silent> <buffer> d :call Qf_del_entry()<CR>

   function! Qf_del_entry() range
      let qf = getqflist()
      unlet! qf[a:firstline - 1 : a:lastline - 1]
      call setqflist(qf, 'r')
      execute a:firstline
   endfunction
   ]=])
end)
