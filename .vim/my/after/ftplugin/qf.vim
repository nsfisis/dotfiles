scriptencoding utf-8


if exists('b:did_ftplugin_qf_after')
    finish
endif



nnoremap <buffer> p <Return>zz<C-w>p
nnoremap <silent> <buffer> dd :call <SID>del_entry()<Return>
xnoremap <silent> <buffer> d :call <SID>del_entry()<Return>
nnoremap <silent> <buffer> u :<C-u>call <SID>undo_entry()<Return>


if exists('*s:undo_entry')
    finish
endif


function! s:undo_entry()
    let history = get(w:, 'qf_history', [])
    if !empty(history)
        call setqflist(remove(history, -1), 'r')
    endif
endfunction

function! s:del_entry() range
    let qf = getqflist()
    let history = get(w:, 'qf_history', [])
    call add(history, copy(qf))
    let w:qf_history = history
    unlet! qf[a:firstline - 1 : a:lastline - 1]
    call setqflist(qf, 'r')
    execute a:firstline
endfunction



let b:did_ftplugin_qf_after = 1
