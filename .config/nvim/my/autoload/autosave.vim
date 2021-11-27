scriptencoding utf-8



if !exists('g:autosave_interval_ms')
    let g:autosave_interval_ms = 10 * 1000
endif

if !exists('g:autosave_silent')
    let g:autosave_silent = v:true
endif



function! autosave#handler(timer_id) abort
    if !&modified
        return
    endif
    if &readonly
        return
    endif
    if &buftype !=# ''
        return
    endif
    if expand('%') ==# ''
        return
    endif

    if !g:autosave_silent
        echohl Comment
        echo 'Auto-saving...'
        echohl None
    endif

    silent! write

    if !g:autosave_silent
        echohl Comment
        echo 'Saved.'
        echohl None
    endif
endfunction


function! autosave#enable() abort
    if !has('timers') && !has('nvim')
        echohl Error
        echo "Feature '+timers' not available."
        echohl None
        return
    endif
    if exists('b:autosave_timer')
        return
    endif

    let b:autosave_timer = timer_start(
        \ g:autosave_interval_ms,
        \ 'autosave#handler',
        \ { 'repeat': -1 })
endfunction


function! autosave#disable() abort
    if !exists('b:autosave_timer')
        return
    endif

    call timer_stop('b:autosave_timer')
    unlet b:autosave_timer
endfunction
