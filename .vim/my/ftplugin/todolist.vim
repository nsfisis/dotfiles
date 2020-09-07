scriptencoding utf-8


if exists('b:did_ftplugin_todolist')
    finish
endif



inoremap <silent> <buffer> <expr>  <Space>  <SID>checkbox(0, ' ')
inoremap <silent> <buffer> <expr>  x        <SID>checkbox(1, 'x')

nnoremap <silent> <buffer>  <Plug>(todolist-toggle-checkbox)      :<C-u>call <SID>toggle_checkbox()<CR>
nnoremap <silent> <buffer>  <Plug>(todolist-toggle-checkbox-rec)  :<C-u>call <SID>toggle_checkbox_rec()<CR>


function! s:checkbox(check, char)
    let line = getline('.')
    if line =~# '^\s*$' && len(line) % shiftwidth() == 0
        if a:check
            return '[x] '
        else
            return '[ ] '
        endif
    else
        return a:char
    endif
endfunction


function! s:toggle_checkbox()
    call s:toggle_checkbox_internal(line('.'), -1)
endfunction


function! s:toggle_checkbox_rec()
    let checked = s:toggle_checkbox_internal(line('.'), -1)
    if checked == -1
        return
    endif
    if line('.') == line('$')
        return
    endif

    let indent_lv = indent('.')
    for l in range(line('.') + 1, line('$'))
        if indent(l) <= indent_lv
            break
        end
        call s:toggle_checkbox_internal(l, checked)
    endfor
endfunction


function! s:toggle_checkbox_internal(line_num, ck_force)
    let line = getline(a:line_num)
    let match = matchlist(line, '^\(\s*\)\[\([x ]\)\]\(.*\)')
    if empty(match)
        return -1
    endif

    let [whole, spaces, ck, rest; _] = match
    let checked = a:ck_force == -1 ? ck == 'x' : a:ck_force
    let line = spaces . '[' . (checked ? ' ' : 'x') . ']' . rest
    call setline(a:line_num, line)
    return checked
endfunction



let b:did_ftplugin_todolist = 1
