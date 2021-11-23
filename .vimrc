" Set Vim's internal encodding.
" Note: This option must be set before 'scriptencoding' is set.
set encoding=utf-8
" Set this file's encoding.
scriptencoding utf-8


" Global settings {{{1

" Global constants {{{2

let g:MY_ENV = {}

if has('unix')
    let g:MY_ENV.os = 'unix'
elseif has('mac')
    let g:MY_ENV.os = 'mac'
elseif has('wsl')
    let g:MY_ENV.os = 'wsl'
elseif has('win32') || has('win64')
    let g:MY_ENV.os = 'windows'
else
    let g:MY_ENV.os = 'unknown'
endif

if empty($XDG_CONFIG_HOME)
    let g:MY_ENV.config_home = $HOME . '/.config'
else
    let g:MY_ENV.config_home = $XDG_CONFIG_HOME
endif
if empty($XDG_CACHE_HOME)
    let g:MY_ENV.cache_home = $HOME . '/.cache'
else
    let g:MY_ENV.cache_home = $XDG_CONFIG_HOME
endif
if empty($XDG_DATA_HOME)
    let g:MY_ENV.data_home = $HOME . '/.local/share'
else
    let g:MY_ENV.data_home = $XDG_DATA_HOME
endif

let g:MY_ENV.config_dir = g:MY_ENV.config_home . '/vim'
let g:MY_ENV.cache_dir = g:MY_ENV.cache_home . '/vim'
let g:MY_ENV.data_dir = g:MY_ENV.data_home . '/vim'

let g:MY_ENV.my_dir = g:MY_ENV.config_dir . '/my'
let g:MY_ENV.plug_dir = g:MY_ENV.data_dir . '/plugged'
let g:MY_ENV.undo_dir = g:MY_ENV.data_dir . '/undo'
let g:MY_ENV.backup_dir = g:MY_ENV.data_dir . '/backup'
let g:MY_ENV.swap_dir = g:MY_ENV.data_dir . '/swap'
let g:MY_ENV.vimindo = g:MY_ENV.data_dir . '/viminfo'
let g:MY_ENV.yankround_dir = g:MY_ENV.data_dir . '/yankround'
let g:MY_ENV.skk_dir = g:MY_ENV.config_home . '/skk'

for [s:k, s:v] in items(g:MY_ENV)
    if s:k =~# '_dir$' && !isdirectory(s:v)
        call mkdir(s:v, 'p')
    endif
endfor
unlet s:k s:v




" The autogroup used in .vimrc {{{2

augroup Vimrc
    autocmd!
augroup END


" Note: |:autocmd| does not accept |-bar|.
command! -nargs=*
    \ Autocmd
    \ autocmd Vimrc <args>



" Language {{{2

" Disable L10N.
language messages C
language time C





" Options {{{1

" * Use |:set|, not |:setglobal|.
"   |:setglobal| does not set local options, so options are not set in
"   the starting buffer you specified as commandline arguments like
"   "$ vim ~/.vimrc".

" Moving around, searching and patterns {{{2

set nowrapscan
set incsearch
set ignorecase
set smartcase



" Displaying text {{{2

set scrolloff=7
set wrap
set linebreak
set breakindent
set breakindentopt+=sbr
let &showbreak = '> '
set sidescrolloff=20
set display=lastline
let &fillchars = 'vert: ,fold: ,diff: '
set cmdheight=2
set list
let &listchars = "eol:\u00ac,tab:\u25b8 ,trail:\u00b7,extends:\u00bb,precedes:\u00ab"
set concealcursor=cnv



" Syntax, highlighting and spelling {{{2

set background=dark
set synmaxcol=500
set hlsearch
" Execute nohlsearch to avoid highlighting last searched pattern when reloading
" .vimrc.
nohlsearch
if exists('+termguicolors')
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
set t_Co=256
set colorcolumn=+1


" Multiple windows {{{2

set laststatus=2
set winminheight=0
set hidden
set switchbuf=usetab



" Multiple tabpages {{{2

set showtabline=2



" Terminal {{{2

set notitle



" Using the mouse {{{2

set mouse=



" Messages and info {{{2

set shortmess+=a
set shortmess+=s
set shortmess+=I
set shortmess+=c
set showcmd
set noshowmode
set report=999
set confirm
set belloff=all



" Selecting text {{{2

set clipboard=unnamed



" Editing text {{{2

set undofile
let &undodir = g:MY_ENV.undo_dir
set textwidth=0
set backspace=indent,eol,start
set completeopt-=preview
set pumheight=10
set noshowmatch
set matchpairs+=<:>
set nojoinspaces
set nrformats-=octal
set nrformats+=unsigned



" Tabs and indenting {{{2
" Note: you should also set them for each file types.
"       These following settings are global, used for unknown file types.

set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set expandtab
set autoindent
set smartindent
set copyindent
set preserveindent



" Folding {{{2

set foldlevelstart=0
set foldopen+=insert
set foldmethod=marker



" Diff mode {{{2

set diffopt+=vertical
    \ diffopt+=foldcolumn:3



" Mapping {{{2

set maxmapdepth=10
set notimeout
set ttimeout
set ttimeoutlen=100



" Reading and writing files {{{2

set nofixendofline
" Note: if 'fileformat' is empty, the first item of 'fileformats' is used.
set fileformats=unix,dos
" Note: these settings make one backup. If you want more backups, see
"       |'backupext'|.
set backup
let &backupdir = g:MY_ENV.backup_dir
set autowrite
set autoread



" The swap file {{{2

" Note: 'dictionary' is swap files' directory.
" '//' is converted to swap file's path.
" If you are editing 'a/b.vim', Vim makes '{g:MY_ENV.swap_dir}/a/b.vim'.
let &directory = g:MY_ENV.swap_dir . '//'



" Command line editing {{{2
set history=2000
set wildignore+=*.o,*.obj,*.lib
set wildignorecase
set wildmenu



" Executing external commands {{{2

set shell=zsh
set keywordprg=



" Encoding {{{2

" Note: if 'fileencoding' is empty, 'encoding' is used.
set fileencodings=utf-8,cp932,euc-jp



" Misc. {{{2

set sessionoptions+=localoptions
set sessionoptions+=resize
set sessionoptions+=winpos
let &viminfofile = g:MY_ENV.vimindo



" Installed plugins {{{1

" === BEGIN === {{{2

execute 'set runtimepath+=' . g:MY_ENV.config_dir
call plug#begin(g:MY_ENV.plug_dir)


" Text editing {{{2

" IME {{{3

" SKK (Simple Kana to Kanji conversion program) for Vim.
Plug 'vim-skk/eskk.vim'

" Operators {{{3

" Support for user-defined operators.
Plug 'kana/vim-operator-user'

" Extract expression and make assingment statement.
Plug 'tek/vim-operator-assign'

" Replace text without updating registers.
Plug 'kana/vim-operator-replace'

" Reverse text.
Plug 'tyru/operator-reverse.vim'

" Search in a specific region.
Plug 'osyo-manga/vim-operator-search'

" Shiffle text.
Plug 'pekepeke/vim-operator-shuffle'

" Sort text characterwise and linewise.
Plug 'emonkak/vim-operator-sort'

" Super surround.
Plug 'machakann/vim-sandwich'

" Non-operators {{{3

" Comment out.
Plug 'tyru/caw.vim'

" Align text.
Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(EasyAlign)' }


" Text objects {{{2

" Support for user-defined text objects.
Plug 'kana/vim-textobj-user'

" Text object for blockwise.
Plug 'osyo-manga/vim-textobj-blockwise'

" Text object for comment.
Plug 'thinca/vim-textobj-comment'

" Text object for continuous line.
Plug 'rhysd/vim-textobj-continuous-line'

" Text object for entire file.
Plug 'kana/vim-textobj-entire'

" Text object for function.
Plug 'kana/vim-textobj-function'

" Text object for indent.
Plug 'kana/vim-textobj-indent'

" Text object for last inserted text.
Plug 'rhysd/vim-textobj-lastinserted'

" Text object for last pasted text.
Plug 'gilligan/textobj-lastpaste'

" Text object for last searched pattern.
Plug 'kana/vim-textobj-lastpat'

" Text object for line.
Plug 'kana/vim-textobj-line'

" Text object for parameter.
Plug 'sgur/vim-textobj-parameter'

" Text object for space.
Plug 'saihoooooooo/vim-textobj-space'

" Text object for syntax.
Plug 'kana/vim-textobj-syntax'

" Text object for URL.
Plug 'mattn/vim-textobj-url'

" Text object for words in words.
Plug 'h1mesuke/textobj-wiw'


" Search {{{2

" Extend * and #.
Plug 'haya14busa/vim-asterisk'

" Extend incremental search.
Plug 'haya14busa/incsearch.vim'

" NOTE: it is a fork version of jremmen/vim-ripgrep
" Integration with ripgrep, fast alternative of grep command.
Plug 'nsfisis/vim-ripgrep', { 'on': 'Rg' }


" Files {{{2

" Switch to related files.
Plug 'kana/vim-altr'

" Fast Fuzzy Finder.
Plug 'ctrlpvim/ctrlp.vim', { 'on': '<Plug>(ctrlp)' }

" CtrlP's matcher by builtin `matchfuzzy()`.
Plug 'mattn/ctrlp-matchfuzzy', { 'on': '<Plug>(ctrlp)' }

" Filer for minimalists.
Plug 'justinmk/vim-dirvish'


" Appearance {{{2

" Show highlight.
Plug 'cocopon/colorswatch.vim', { 'on': 'ColorSwatchGenerate' }

" NOTE: it is a fork of godlygeek/csapprox
" Make gui-only color schemes 256colors-compatible.
Plug 'nsfisis/csapprox'

" Makes folding text cool.
Plug 'LeafCage/foldCC.vim'

" Show indent.
Plug 'Yggdroot/indentLine'

" Highlight matched parentheses.
Plug 'itchyny/vim-parenmatch'

" Highlight specified words.
Plug 't9md/vim-quickhl', { 'on': [ 'QuickhlManualReset', '<Plug>(quickhl-manual-this)'] }


" Filetypes {{{2

" Syntax {{{3

" HCL
Plug 'b4b4r07/vim-hcl'

" JavaScript
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }

" JSON5
Plug 'GutenYe/json5.vim'

" MoonScript
Plug 'leafo/moonscript-vim'

" Nginx conf
Plug 'chr4/nginx.vim'

" Rust
Plug 'rust-lang/rust.vim', { 'for': 'rust' }

" TOML
Plug 'cespare/vim-toml', { 'for': 'toml' }

" TypeScript
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }

" Tools {{{3

" C/C++: clang-format
Plug 'rhysd/vim-clang-format', { 'for': ['c', 'cpp'] }

" Python: autopep8
Plug 'tell-k/vim-autopep8', { 'for': 'python' }


" QoL {{{2

" If a directory is missing, make it automatically.
Plug 'mopp/autodirmake.vim'

" Capture the output of a command.
Plug 'tyru/capture.vim'

" Write git commit message.
Plug 'rhysd/committia.vim'

" Motion on speed.
Plug 'easymotion/vim-easymotion', { 'on': [
    \ '<Plug>(easymotion-Fl)',
    \ '<Plug>(easymotion-N)',
    \ '<Plug>(easymotion-Tl)',
    \ '<Plug>(easymotion-bd-w)',
    \ '<Plug>(easymotion-fl)',
    \ '<Plug>(easymotion-j)',
    \ '<Plug>(easymotion-k)',
    \ '<Plug>(easymotion-n)',
    \ '<Plug>(easymotion-s2)',
    \ '<Plug>(easymotion-tl)',
    \ ] }

" Integration with EditorConfig (https://editorconfig.org)
Plug 'editorconfig/editorconfig-vim'

" Extend J.
Plug 'osyo-manga/vim-jplus'

" Improve behaviors of I, A and gI in Blockwise-Visual mode.
Plug 'kana/vim-niceblock'

" Edit QuickFix and reflect to original buffers.
Plug 'thinca/vim-qfreplace'

" Run anything.
Plug 'thinca/vim-quickrun'

" Extend dot-repeat.
Plug 'tpope/vim-repeat'

" Split one line format and Join multiline format.
Plug 'AndrewRadev/splitjoin.vim'

" Introduce user-defined mode.
Plug 'kana/vim-submode'

" Swap arguments.
Plug 'machakann/vim-swap'

" Adjust window size.
Plug 'rhysd/vim-window-adjuster'

" Remember yank history and paste them.
Plug 'LeafCage/yankround.vim'


" === END === {{{2

Plug g:MY_ENV.my_dir

call plug#end()




" Autocommands {{{1

" Auto-resize windows when Vim is resized.
Autocmd VimResized * wincmd =


" Calculate 'numberwidth' to fit file size.
" Note: extra 2 is the room of left and right spaces.
Autocmd BufEnter,WinEnter,BufWinEnter *
    \ let &l:numberwidth = len(line('$')) + 2


" Jump to the last cursor position when you open a file.
Autocmd BufRead *
    \ if 0 < line("'\"") && line("'\"") <= line('$') &&
    \         &filetype !~# 'commit' && &filetype !~# 'rebase' |
    \     execute "normal g`\"" |
    \ endif


" Syntax highlight for .vimrc {{{2

Autocmd Filetype vim
    \ if expand('%') =~? 'vimrc' || expand('%') =~? 'init.vim' |
    \     call s:highlight_vimrc() |
    \ endif


function! s:highlight_vimrc() abort
    " Autocmd
    syn keyword vimrcAutocmd Autocmd skipwhite nextgroup=vimAutoEventList

    " Plugin manager command
    syn keyword vimrcPluginManager Plug

    hi def link vimrcAutocmd       vimAutocmd
    hi def link vimrcPluginManager vimCommand
endfunction




" Mappings {{{1

" Note: |:noremap| defines mappings in |Normal|, |Visual|, |Operator-Pending|
" and |Select| mode. Because I don't use |Select| mode, I use |:noremap| as
" substitute of |:nnoremap|, |:xnoremap| and |:onoremap| for simplicity.


" Fix the search direction. {{{2

noremap <expr>  gn  v:searchforward ? 'gn' : 'gN'
noremap <expr>  gN  v:searchforward ? 'gN' : 'gn'

noremap <expr>  n  v:searchforward ? 'n' : 'N'
noremap <expr>  N  v:searchforward ? 'N' : 'n'



nnoremap <silent>  &  :%&&<CR>
xnoremap <silent>  &  :%&&<CR>



" Registers and macros. {{{2


" Access an resister in the same way in Insert and Commandline mode.
nnoremap  <C-r>  "
xnoremap  <C-r>  "


" Paste clipboard content with 'paste' enabled
function! s:paste_clipboard_content_with_paste_opt() abort
    let old_paste = &paste
    set paste
    set pastetoggle=<Plug>(pastetoggle)
    if old_paste
        return "\<C-r>+"
    else
        " 'paste' was off when the function was called. Then, 'paste' will be
        " disabled via 'pastetoggle'.
        return "\<C-r>+\<Plug>(pastetoggle)"
    endif
endfunction

" Automatically enable 'paste' and disable it after pasting clipboard's
" content.
inoremap <expr>  <C-r>+  <SID>paste_clipboard_content_with_paste_opt()


let @j = 'j.'
let @k = 'k.'
let @n = 'n.'
nnoremap   @N  N.

" Repeat the last executed macro as many times as possible.
" a => all
" Note: "let @a = '@@'" does not work well.
nnoremap  @a  9999@@


" Execute the last executed macro again.
nnoremap  `  @@



" Emacs like key mappings in Insert and CommandLine mode. {{{2

function! s:go_to_beginning_of_line() abort
    if col('.') == match(getline('.'), '\S') + 1
        return repeat("\<C-g>U\<Left>", col('.') - 1)
    else
        return (col('.') < match(getline('.'), '\S')) ?
            \ repeat("\<C-g>U\<Right>", match(getline('.'), '\S') - col('.') + 1) :
            \ repeat("\<C-g>U\<Left>", col('.') - 1 - match(getline('.'), '\S'))
    endif
endfunction


inoremap  <C-d>  <Del>

" Go elsewhere without deviding the undo history.
inoremap <expr>  <C-a>  <SID>go_to_beginning_of_line()
inoremap <expr>  <C-e>  repeat('<C-g>U<Right>', col('$') - col('.'))
inoremap  <C-b>  <C-g>U<Left>
inoremap  <C-f>  <C-g>U<Right>

" Delete something deviding the undo history.
inoremap  <C-u>  <C-g>u<C-u>
inoremap  <C-w>  <C-g>u<C-w>

cnoremap  <C-a>  <Home>
cnoremap  <C-e>  <End>
cnoremap  <C-f>  <Right>
cnoremap  <C-b>  <Left>
cnoremap  <C-n>  <Down>
cnoremap  <C-p>  <Up>
cnoremap  <C-d>  <Del>

cnoremap  <Left>  <Nop>
inoremap  <Left>  <Nop>
cnoremap  <Right>  <Nop>
inoremap  <Right>  <Nop>




function! s:my_gA()
    let line = getline('.')
    if match(line, ';;$') != -1 " For OCaml.
        return "A\<C-g>U\<Left>\<C-g>U\<Left>"
    elseif match(line, '[,;)]$') != -1
        return "A\<C-g>U\<Left>"
    else
        return 'A'
    endif
endfunction

nnoremap <expr>  gA  <SID>my_gA()



" QuickFix or location list. {{{2

nnoremap <silent> bb  :<C-u>cc<CR>

nnoremap <silent>  bn  :<C-u><C-r>=v:count1<CR>cnext<CR>
nnoremap <silent>  bp  :<C-u><C-r>=v:count1<CR>cprevious<CR>

nnoremap <silent>  bf  :<C-u>cfirst<CR>
nnoremap <silent>  bl  :<C-u>clast<CR>

nnoremap <silent>  bS  :colder<CR>
nnoremap <silent>  bs  :cnewer<CR>



" Operators {{{2

" Throw deleted text into the black hole register ("_).
nnoremap  c  "_c
xnoremap  c  "_c
nnoremap  C  "_C
xnoremap  C  "_C


noremap  g=  =


noremap  ml  gu
noremap  mu  gU

noremap  gu  <Nop>
noremap  gU  <Nop>
xnoremap  u  <Nop>
xnoremap  U  <Nop>


xnoremap  x  "_x


nnoremap  Y  y$
" In Blockwise-Visual mode, select text linewise.
" By default, select text characterwise, neither blockwise nor linewise.
xnoremap <expr>  Y  mode() ==# 'V' ? 'y' : 'Vy'



" Swap the keys entering Replace mode and Visual-Replace mode.
nnoremap  R  gR
nnoremap  gR  R
nnoremap  r  gr
nnoremap  gr  r


nnoremap  U  <C-r>




" Motions {{{2

noremap  H  ^
noremap  L  $
noremap  M  %

noremap  gw  b
noremap  gW  B

noremap  k  gk
noremap  j  gj
noremap  gk  k
noremap  gj  j

nnoremap  gff  gF



" Tabpages and windows. {{{2

function! s:move_current_window_to_tabpage() abort
    if winnr('$') == 1
        " Leave the current window and open it in a new tabpage.
        " Because :wincmd T fails when the current tabpage has only one window.
        tab split
    else
        " Close the current window and re-open it in a new tabpage.
        wincmd T
    endif
endfunction


function! s:bdelete_bang_with_confirm() abort
    if s:getchar_with_prompt('Delete? (y/n) ') ==? 'y'
        bdelete!
    else
        echo 'Canceled'
    endif
endfunction


function! s:choose_window_interactively() abort
    const indicators = [
        \ 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ';',
        \ '1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
        \ ]

    " List normal windows up to 20.
    let wins = []
    for winnr in range(1, winnr('$'))
        if winnr !=# winnr() && win_gettype(winnr) ==# ''
            call add(wins, win_getid(winnr))
        endif
    endfor
    if len(indicators) < len(wins)
        unlet wins[len(indicators):]
    endif

    if len(wins) ==# 0
        return
    endif
    if len(wins) ==# 1
        if wins[0] ==# win_getid()
            call win_gotoid(wins[1])
        else
            call win_gotoid(wins[0])
        endif
        return
    endif

    " Show popups.
    let popups = []
    for i in range(len(wins))
        let winid = wins[i]
        let indicator = indicators[i]
        let [winy, winx, winh, winw] = s:win_getrect(winid)
        let popup = popup_create(indicator, #{
            \ line: winy + (winh - 3) / 2,
            \ col: winx + (winw - 7) / 2,
            \ drag: v:false,
            \ resize: v:false,
            \ padding: [1, 3, 1, 3],
            \ border: [0, 0, 0, 0],
            \ })
        call add(popups, #{
            \ winid: popup,
            \ indicator: indicator,
            \ target_winid: winid,
            \ })
    endfor

    " Prompt
    let result = s:getchar_with_prompt('Select window: ')

    " Jump
    let jump_target = -1
    for popup in popups
        if result ==? popup.indicator
            let jump_target = popup.target_winid
        endif
    endfor
    if jump_target !=# -1
        call win_gotoid(jump_target)
    endif

    " Close popups
    for popup in popups
        call popup_close(popup.winid)
    endfor
endfunction


nnoremap <silent>  tt  :<C-u>tabnew<CR>
nnoremap <silent>  tT  :<C-u>call <SID>move_current_window_to_tabpage()<CR>

nnoremap <silent>  tn  :<C-u><C-r>=(tabpagenr() + v:count1 - 1) % tabpagenr('$') + 1<CR>tabnext<CR>
nnoremap <silent>  tp  :<C-u><C-r>=(tabpagenr('$') * 10 + tabpagenr() - v:count1 - 1) % tabpagenr('$') + 1<CR>tabnext<CR>

nnoremap <silent>  tN  :<C-u>tabmove +<CR>
nnoremap <silent>  tP  :<C-u>tabmove -<CR>

nnoremap <silent>  tsh  :<C-u>leftabove vsplit<CR>
nnoremap <silent>  tsj  :<C-u>rightbelow split<CR>
nnoremap <silent>  tsk  :<C-u>leftabove split<CR>
nnoremap <silent>  tsl  :<C-u>rightbelow vsplit<CR>

nnoremap <silent>  tsH  :<C-u>topleft vsplit<CR>
nnoremap <silent>  tsJ  :<C-u>botright split<CR>
nnoremap <silent>  tsK  :<C-u>topleft split<CR>
nnoremap <silent>  tsL  :<C-u>botright vsplit<CR>

nnoremap <silent>  twh  :<C-u>leftabove vnew<CR>
nnoremap <silent>  twj  :<C-u>rightbelow new<CR>
nnoremap <silent>  twk  :<C-u>leftabove new<CR>
nnoremap <silent>  twl  :<C-u>rightbelow vnew<CR>

nnoremap <silent>  twH  :<C-u>topleft vnew<CR>
nnoremap <silent>  twJ  :<C-u>botright new<CR>
nnoremap <silent>  twK  :<C-u>topleft new<CR>
nnoremap <silent>  twL  :<C-u>botright vnew<CR>

nnoremap  th  <C-w>h
nnoremap  tj  <C-w>j
nnoremap  tk  <C-w>k
nnoremap  tl  <C-w>l

nnoremap  tH  <C-w>H
nnoremap  tJ  <C-w>J
nnoremap  tK  <C-w>K
nnoremap  tL  <C-w>L

nnoremap  tx  <C-w>x

" r => manual resize.
" R => automatic resize.
nnoremap  tRH  <C-w>_
nnoremap  tRW  <C-w><Bar>
nnoremap  tRR  <C-w>_<C-w><Bar>

nnoremap  t=  <C-w>=

nnoremap <silent>  tq  :<C-u>bdelete<CR>
nnoremap <silent>  tQ  :<C-u>call <SID>bdelete_bang_with_confirm()<CR>

nnoremap  tc  <C-w>c

nnoremap  to  <C-w>o
nnoremap <silent>  tO  :<C-u>tabonly<CR>

if has('popupwin')
    nnoremap <silent>  tg  :<C-u>call <SID>choose_window_interactively()<CR>
endif



function! s:smart_open(command) abort
    if winwidth(winnr()) < 150
        let modifiers = 'topleft'
    else
        let modifiers = 'vertical botright'
    endif

    try
        execute modifiers a:command
    catch
        echohl Error
        echo v:exception
        echohl None
        return
    endtry

    if &filetype ==# 'help'
        if &l:textwidth > 0
            execute 'vertical resize' &l:textwidth
        endif
        " Help tags are often right-justfied, moving the cursor to BoL.
        normal! 0
    endif
endfunction


command! -nargs=+ -complete=command
    \ SmartOpen
    \ call s:smart_open(<q-args>)




" Increment/decrement numbers {{{2

" nnoremap  +  <C-a>
" nnoremap  -  <C-x>
" xnoremap  +  <C-a>
" xnoremap  -  <C-x>
" xnoremap  g+  g<C-a>
" xnoremap  g-  g<C-x>



" Disable unuseful or dangerous mappings. {{{2

" Disable Select mode.
nnoremap  gh  <Nop>
nnoremap  gH  <Nop>
nnoremap  g<C-h>  <Nop>

" Disable Ex mode.
nnoremap  Q  <Nop>
nnoremap  gQ  <Nop>

nnoremap  ZZ  <Nop>
nnoremap  ZQ  <Nop>


" Help {{{2

" Search help.
nnoremap  <C-h>  :<C-u>SmartOpen help<Space>



" For writing Vim script. {{{2


if !v:vim_did_enter
    " Define this function only when Vim is starting up. |v:vim_did_enter|
    function! SourceThisFile() abort
        let filename = expand('%')
        if &filetype ==# 'vim' || expand('%:e') ==# 'vim' || filename =~# '\.g\?vimrc'
            if &filetype !=# 'vim'
                setfiletype vim
            endif
            update
            unlet! g:loaded_{expand('%<')}
            source %
        else
            echo filename ' is not a Vim Script.'
        endif
    endfunction
endif



nnoremap <silent>  XV  :<C-u>tabedit $MYVIMRC<CR>

nnoremap <silent>  XX  :<C-u>call SourceThisFile()<CR>

" See |numbered-function|.
nnoremap <silent>  XF  :<C-u>function {<C-r>=v:count<CR>}<CR>

nnoremap <silent>  XM  :<C-u>messages<CR>

nnoremap <silent>  XP  :<C-u>call popup_clear(1)<CR>




" Misc. {{{2

onoremap <silent>  gv  :<C-u>normal! gv<CR>

" Swap : and ;.
nnoremap  ;  :
nnoremap  :  ;
xnoremap  ;  :
xnoremap  :  ;
nnoremap  @;  @:
xnoremap  @;  @:
cnoremap <C-r>;  <C-r>:
inoremap <C-r>;  <C-r>:


" Since <ESC> may be mapped to something else somewhere, it should be :map, not
" :noremap.
imap  jk  <ESC>
cmap  jk  <ESC>



nnoremap <silent>  <C-c>  :<C-u>nohlsearch<CR>



nnoremap <silent>  <Plug>(my-insert-blank-lines-after)
    \ :<C-u>call <SID>insert_blank_line(0)<CR>
nnoremap <silent>  <Plug>(my-insert-blank-lines-before)
    \ :<C-u>call <SID>insert_blank_line(1)<CR>

nmap  go  <Plug>(my-insert-blank-lines-after)
nmap  gO  <Plug>(my-insert-blank-lines-before)

function! s:insert_blank_line(offset) abort
    for i in range(v:count1)
        call append(line('.') - a:offset, '')
    endfor
endfunction


nnoremap <silent>  <Space>w  :<C-u>write<CR>


" Abbreviations {{{1

inoreabbrev  retrun  return
inoreabbrev  reutrn  return
inoreabbrev  tihs  this





" Commands {{{1

" Set 'makeprg' to `ninja` if `build.ninja` exists in the current working
" directory. Then, execute :make command.
command! -bang -bar -nargs=*
    \ Make
    \ if filereadable('build.ninja') |
    \     let &makeprg = 'ninja' |
    \ endif |
    \ make<bang> <args>


" Reverse a selected range in line-wise.
" Note: directly calling `g/^/m` will overwrite the current search pattern with
" '^' and highlight it, which is not expected.
" :h :keeppatterns
command! -bar -range=%
    \ Reverse
    \ keeppatterns <line1>,<line2>g/^/m<line1>-1


function! s:dummy_man_command(mods, args) abort
    " Delete the dummy command.
    delcommand Man
    " Load man.vim which defines |:Man|.
    runtime ftplugin/man.vim
    " Pass the given arguments to it.
    execute printf("%s Man %s", a:mods, a:args)
endfunction


" To shorten Vim startup, lazily load ftplugin/man.vim.
command! -complete=shellcmd -nargs=+
    \ Man
    \ call s:dummy_man_command(<q-mods>, <f-args>)




" ftplugin {{{1

" This command do the followings:
"     * Execute |:setlocal| for each options.
"     * Set information to restore the original setting to b:|undo_ftplugin|.

" This command is used in ftplugin/*.vim.

" Note: specify only single option.

command! -nargs=+
    \ FtpluginSetLocal
    \ call s:ftplugin_setlocal(<q-args>)

function! s:ftplugin_setlocal(qargs) abort
    execute 'setlocal' a:qargs

    let option_name = substitute(a:qargs, '\L.*', '', '')

    if option_name ==# 'shiftwidth' && exists(':IndentLinesReset') ==# 2
        IndentLinesReset
    endif

    if exists('b:undo_ftplugin')
        let b:undo_ftplugin .= '|setlocal ' . option_name . '<'
    else
        let b:undo_ftplugin = 'setlocal ' . option_name . '<'
    endif
endfunction




" Appearance {{{1

" Color scheme {{{2

try
    colorscheme ocean
catch
    " Loading colorscheme failed.
    " The color scheme, "desert", is one of the built-in ones. Probably, it
    " will be loaded without any errors.
    colorscheme desert
endtry



" Statusline {{{2

set statusline=%!Statusline_build()

function! Statusline_build() abort
    let winid = g:statusline_winid
    let bufnr = winbufnr(winid)
    let is_active = winid ==# win_getid()
    if is_active
        let [mode, mode_hl] = s:statusline_mode()
        let ro = s:statusline_readonly(bufnr)
        let fname = s:statusline_filename(bufnr)
        let mod = s:statusline_modified(bufnr)
        let linenum = s:statusline_linenum(winid)
        let fenc = s:statusline_fenc_ff(bufnr)
        let ft = s:statusline_filetype(bufnr)
        return printf(
            \ '%%#statusLineMode%s# %s %%#statusLine# %s%s%s %%= %s | %s | %s ',
            \ mode_hl,
            \ mode,
            \ empty(ro) ? '' : ro . ' ',
            \ fname,
            \ empty(mod) ? '' : ' ' . mod,
            \ linenum,
            \ fenc,
            \ ft)
    else
        let ro = s:statusline_readonly(bufnr)
        let fname = s:statusline_filename(bufnr)
        let mod = s:statusline_modified(bufnr)
        let linenum = s:statusline_linenum(winid)
        let fenc = s:statusline_fenc_ff(bufnr)
        let ft = s:statusline_filetype(bufnr)
        return printf(
            \ ' %s%s%s %%= %s | %s | %s ',
            \ empty(ro) ? '' : ro . ' ',
            \ fname,
            \ empty(mod) ? '' : ' ' . mod,
            \ linenum,
            \ fenc,
            \ ft)
    endif
endfunction

function! s:statusline_mode() abort
    const mode_map = {
        \ 'n':        ['N',  'Normal'],
        \ 'no':       ['O',  'Operator'],
        \ 'nov':      ['Oc', 'Operator'],
        \ 'noV':      ['Ol', 'Operator'],
        \ "no\<C-v>": ['Ob', 'Operator'],
        \ 'niI':      ['In', 'Insert'],
        \ 'niR':      ['Rn', 'Replace'],
        \ 'niV':      ['Rn', 'Replace'],
        \ 'v':        ['V',  'Visual'],
        \ 'V':        ['Vl', 'Visual'],
        \ "\<C-v>":   ['Vb', 'Visual'],
        \ 's':        ['S',  'Visual'],
        \ 'S':        ['Sl', 'Visual'],
        \ "\<C-s>":   ['Sb', 'Visual'],
        \ 'i':        ['I',  'Insert'],
        \ 'ic':       ['I?', 'Insert'],
        \ 'ix':       ['I?', 'Insert'],
        \ 'R':        ['R',  'Replace'],
        \ 'Rc':       ['R?', 'Replace'],
        \ 'Rv':       ['R',  'Replace'],
        \ 'Rx':       ['R?', 'Replace'],
        \ 'c':        ['C',  'Command'],
        \ 'cv':       ['C',  'Command'],
        \ 'ce':       ['C',  'Command'],
        \ 'r':        ['-',  'Other'],
        \ 'rm':       ['-',  'Other'],
        \ 'r?':       ['-',  'Other'],
        \ '!':        ['-',  'Other'],
        \ 't':        ['T',  'Terminal'],
        \ }
    let [vim_mode, hl] = get(mode_map, mode(v:true), ['-', 'Other'])

    " Calling `eskk#statusline()` makes Vim autoload eskk. If you call it
    " without checking `g:loaded_autoload_eskk`, eskk is loaded on an early
    " stage of the initialization (probably the first rendering of status line),
    " which slows down Vim startup. Loading eskk can be delayed by checking both
    " of `g:loaded_eskk` and `g:loaded_autoload_eskk`.
    if exists('g:loaded_eskk') && exists('g:loaded_autoload_eskk')
        let skk_mode = eskk#statusline(' (%s)', '')
    else
        let skk_mode = ''
    endif

    return [vim_mode . skk_mode, hl]
endfunction

function! s:statusline_readonly(bufnr) abort
    let ro = getbufvar(a:bufnr, '&readonly')
    return ro ? '[RO]' : ''
endfunction

function! s:statusline_filename(bufnr) abort
    let name = bufname(a:bufnr)
    return empty(name) ? '[No Name]' : name
endfunction

function! s:statusline_modified(bufnr) abort
    let mod = getbufvar(a:bufnr, '&modified')
    let ma = getbufvar(a:bufnr, '&modifiable')
    if mod
        return '[+]'
    elseif ma
        return ''
    else
        return '[-]'
    endif
endfunction

function! s:statusline_linenum(winid) abort
    return line('.', a:winid) . '/' . line('$', a:winid)
endfunction

function! s:statusline_fenc_ff(bufnr) abort
    let fenc = getbufvar(a:bufnr, '&fileencoding')
    let ff = getbufvar(a:bufnr, '&fileformat')
    let bom = getbufvar(a:bufnr, '&bomb')  " BOMB!!

    if fenc ==# ''
        let fencs = split(&fileencodings, ',')
        let fenc = get(fencs, 0, &encoding)
    endif
    if fenc ==# 'utf-8'
        let fenc = bom ? 'U8[BOM]' : 'U8'
    elseif fenc ==# 'utf-16'
        let fenc = 'U16[BE]'
    elseif fenc ==# 'utf-16le'
        let fenc = 'U16[LE]'
    elseif fenc ==# 'ucs-4'
        let fenc = 'U32[BE]'
    elseif fenc ==# 'ucs-4le'
        let fenc = 'U32[LE]'
    else
        let fenc = toupper(fenc)
    endif

    if ff ==# 'unix'
        let ff = ''
    elseif ff ==# 'dos'
        let ff = ' (CRLF)'
    elseif ff ==# 'mac'
        let ff = ' (CR)'
    else
        let ff = ' (Unknown)'
    endif

    return fenc . ff
endfunction

function! s:statusline_filetype(bufnr) abort
    let ft = getbufvar(a:bufnr, '&filetype')
    return empty(ft) ? '[None]' : ft
endfunction



" Tabline {{{2

set tabline=%!Tabline_build()

function! Tabline_build() abort
    let tal = ''
    for tabnr in range(1, tabpagenr('$'))
        let is_active = tabnr ==# tabpagenr()
        let buflist = tabpagebuflist(tabnr)
        let bufnr = buflist[tabpagewinnr(tabnr) - 1]
        let tal .= printf(
            \ '%%#%s# %s%s ',
            \ is_active ? 'TabLineSel' : 'TabLine',
            \ s:statusline_filename(bufnr),
            \ len(buflist) ==# 1 ? '' : '+')
    endfor
    return tal . '%#TabLineFill#'
endfunction


" Plugins configuration {{{1

" Disable standard plugins. {{{2

let g:loaded_2html_plugin     = 1
let g:loaded_getscriptPlugin  = 1
let g:loaded_gzip             = 1
let g:loaded_logiPat          = 1
let g:loaded_matchparen       = 1
let g:loaded_netrw            = 1
let g:loaded_netrwPlugin      = 1
let g:loaded_rrhelper         = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tarPlugin        = 1
let g:loaded_vimballPlugin    = 1
let g:loaded_zipPlugin        = 1



" altr {{{2

" For vim
call altr#define('autoload/%.vim', 'doc/%.txt', 'plugin/%.vim')
" For C and C++
call altr#define('%.c', '%.cpp', '%.cc', '%.h', '%.hh', '%.hpp')

" Go to File Alternative
nmap  gfa  <Plug>(altr-forward)




" asterisk {{{2

function! s:asterisk(ret, keeppos)
    let g:asterisk#keeppos = a:keeppos
    return a:ret
endfunction

" Do not keep the relative cursor position.
nmap <expr>  *  <SID>asterisk('<Plug>(asterisk-z*)', 0)
omap <expr>  *  <SID>asterisk('<Plug>(asterisk-z*)', 0)
xmap <expr>  *  <SID>asterisk('<Plug>(asterisk-z*)', 0)
nmap <expr>  g*  <SID>asterisk('<Plug>(asterisk-gz*)', 0)
omap <expr>  g*  <SID>asterisk('<Plug>(asterisk-gz*)', 0)
xmap <expr>  g*  <SID>asterisk('<Plug>(asterisk-gz*)', 0)

" Keep the relative cursor position (use offset like /s+1).
" Note: I fix the search direction in typing 'n' and 'N', so there is no
" difference between '*' and '#'.
nmap <expr>  #  <SID>asterisk('<Plug>(asterisk-z*)', 1)
omap <expr>  #  <SID>asterisk('<Plug>(asterisk-z*)', 1)
xmap <expr>  #  <SID>asterisk('<Plug>(asterisk-z*)', 1)
nmap <expr>  g#  <SID>asterisk('<Plug>(asterisk-gz*)', 1)
omap <expr>  g#  <SID>asterisk('<Plug>(asterisk-gz*)', 1)
xmap <expr>  g#  <SID>asterisk('<Plug>(asterisk-gz*)', 1)



" autodirmake {{{2

let g:autodirmake#msg_highlight = 'Question'



" autopep8 {{{2

let g:autopep8_on_save = 1
let g:autopep8_disable_show_diff = 1

command!
    \ Autopep8Disable
    \ let g:autopep8_on_save = 0



" caw {{{2

let g:caw_no_default_keymappings = 1

nmap  m//  <Plug>(caw:hatpos:toggle)
xmap  m//  <Plug>(caw:hatpos:toggle)
nmap  m/w  <Plug>(caw:wrap:comment)
xmap  m/w  <Plug>(caw:wrap:comment)
nmap  m/W  <Plug>(caw:wrap:uncomment)
xmap  m/W  <Plug>(caw:wrap:uncomment)
nmap  m/b  <Plug>(caw:box:comment)
xmap  m/b  <Plug>(caw:box:comment)



" clang-format {{{2

let g:clang_format#auto_format = 1
Autocmd FileType javascript ClangFormatAutoDisable
Autocmd FileType typescript ClangFormatAutoDisable



" ctrlp {{{2

let g:ctrlp_map = '<Space>f'
let g:ctrlp_match_func = {'match': 'ctrlp_matchfuzzy#matcher'}



" dirvish {{{2

" Prevent dirvish from mapping hyphen key to "<Plug>(dirvish_up)".
" nmap  <Plug>(nomap-dirvish_up)  <Plug>(dirvish_up)



" easyalign {{{2

nmap  =  <Plug>(EasyAlign)
xmap  =  <Plug>(EasyAlign)



" easymotion {{{2

let g:EasyMotion_keys = 'asdfghweryuiocvbnmjkl;'
let g:EasyMotion_space_jump_first = 1
let g:EasyMotion_do_shade = 0
let g:EasyMotion_do_mappings = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_verbose = 0
let g:EasyMotion_startofline = 0

nmap  f  <Plug>(easymotion-fl)
omap  f  <Plug>(easymotion-fl)
xmap  f  <Plug>(easymotion-fl)
nmap  F  <Plug>(easymotion-Fl)
omap  F  <Plug>(easymotion-Fl)
xmap  F  <Plug>(easymotion-Fl)
omap  t  <Plug>(easymotion-tl)
xmap  t  <Plug>(easymotion-tl)
omap  T  <Plug>(easymotion-Tl)
xmap  T  <Plug>(easymotion-Tl)

" Note: Don't use the following key sequences! It is used 'vim-sandwich'.
"  * sa
"  * sd
"  * sr
nmap  ss  <Plug>(easymotion-s2)
omap  ss  <Plug>(easymotion-s2)
xmap  ss  <Plug>(easymotion-s2)
nmap  sw  <Plug>(easymotion-bd-w)
omap  sw  <Plug>(easymotion-bd-w)
xmap  sw  <Plug>(easymotion-bd-w)
nmap  sn  <Plug>(easymotion-n)
omap  sn  <Plug>(easymotion-n)
xmap  sn  <Plug>(easymotion-n)
nmap  sN  <Plug>(easymotion-N)
omap  sN  <Plug>(easymotion-N)
xmap  sN  <Plug>(easymotion-N)
nmap  sj  <Plug>(easymotion-j)
omap  sj  <Plug>(easymotion-j)
xmap  sj  <Plug>(easymotion-j)
nmap  sk  <Plug>(easymotion-k)
omap  sk  <Plug>(easymotion-k)
xmap  sk  <Plug>(easymotion-k)



" eskk {{{2

let g:eskk#dictionary = {
    \ 'path': g:MY_ENV.skk_dir . '/jisyo',
    \ 'sorted': 0,
    \ 'encoding': 'utf-8',
    \ }

let g:eskk#large_dictionary = {
    \ 'path': g:MY_ENV.skk_dir . '/jisyo.L',
    \ 'sorted': 1,
    \ 'encoding': 'euc-jp',
    \ }

let g:eskk#backup_dictionary = g:eskk#dictionary.path . ".bak"

let g:eskk#kakutei_when_unique_candidate = v:true
let g:eskk#enable_completion = v:false
let g:eskk#egg_like_newline = v:true

" Change default markers because they are EAW (East Asian Width) characters.
let g:eskk#marker_henkan = '[!]'
let g:eskk#marker_okuri = '-'
let g:eskk#marker_henkan_select = '[#]'
let g:eskk#marker_jisyo_touroku = '[?]'



function! s:eskk_initialize_pre() abort
    let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
    call t.add_map('z ', '　')
    call t.add_map('0.', '0.')
    call t.add_map('1.', '1.')
    call t.add_map('2.', '2.')
    call t.add_map('3.', '3.')
    call t.add_map('4.', '4.')
    call t.add_map('5.', '5.')
    call t.add_map('6.', '6.')
    call t.add_map('7.', '7.')
    call t.add_map('8.', '8.')
    call t.add_map('9.', '9.')
    call eskk#register_mode_table('hira', t)
endfunction


Autocmd User eskk-initialize-pre call s:eskk_initialize_pre()


function! s:eskk_initialize_post() abort
    " I don't use hankata mode for now.
    EskkUnmap -type=mode:hira:toggle-hankata
    EskkUnmap -type=mode:kata:toggle-hankata

    " I don't use abbrev mode for now.
    EskkUnmap -type=mode:hira:to-abbrev
    EskkUnmap -type=mode:kata:to-abbrev

    " I don't use ascii mode for now.
    EskkUnmap -type=mode:hira:to-ascii
    EskkUnmap -type=mode:kata:to-ascii

    " Instead, l key disable SKK input.
    EskkMap -type=disable l
    EskkMap -type=disable l

    " Custom highlight for henkan markers.
    syntax match skkMarker '\[[!#?]\]'
    hi link skkMarker Special
endfunction


Autocmd User eskk-initialize-post call s:eskk_initialize_post()



" foldcc {{{2

set foldtext=FoldCCtext()
let g:foldCCtext_head = 'repeat(">", v:foldlevel) . " "'



" incsearch {{{2

" let g:incsearch#magic = '\v'

nmap  /  <Plug>(incsearch-forward)
omap  /  <Plug>(incsearch-forward)
xmap  /  <Plug>(incsearch-forward)
nmap  ?  <Plug>(incsearch-backward)
omap  ?  <Plug>(incsearch-backward)
xmap  ?  <Plug>(incsearch-backward)
nmap  g/  <Plug>(incsearch-stay)
omap  g/  <Plug>(incsearch-stay)
xmap  g/  <Plug>(incsearch-stay)



" indentline {{{2

let g:indentLine_conceallevel = 1
let g:indentLine_fileTypeExclude = ['help']



" jplus {{{2

let g:jplus#input_config = {
    \ '__DEFAULT__': {'delimiter_format': ' %d '},
    \ '__EMPTY__': {'delimiter_format': ''},
    \ ' ': {'delimiter_format': ' '},
    \ ',': {'delimiter_format': '%d '},
    \ ';': {'delimiter_format': '%d '},
    \ 'l': {'delimiter_format': ''},
    \ 'L': {'delimiter_format': ''},
    \ }
nmap  J  <Plug>(jplus-getchar)
xmap  J  <Plug>(jplus-getchar)
nmap  gJ  <Plug>(jplus-input)
xmap  gJ  <Plug>(jplus-input)





" vim-lsp {{{2

" TODO



" niceblock {{{2

xmap  I  <Plug>(niceblock-I)
xmap  gI  <Plug>(niceblock-gI)
xmap  A  <Plug>(niceblock-A)






" operator-replace {{{2

nmap  <C-p>  <Plug>(operator-replace)
omap  <C-p>  <Plug>(operator-replace)
xmap  <C-p>  <Plug>(operator-replace)



" operator-search {{{2

" Note: m/ is the prefix of comment out.
nmap  m?  <Plug>(operator-search)
omap  m?  <Plug>(operator-search)
xmap  m?  <Plug>(operator-search)



" qfreplace {{{2

nnoremap <silent>  br  :<C-u>Qfreplace SmartOpen<CR>



" quickhl {{{2

" TODO: CUI
let g:quickhl_manual_colors = [
    \ 'guifg=#101020 guibg=#8080c0 gui=bold',
    \ 'guifg=#101020 guibg=#80c080 gui=bold',
    \ 'guifg=#101020 guibg=#c08080 gui=bold',
    \ 'guifg=#101020 guibg=#80c0c0 gui=bold',
    \ 'guifg=#101020 guibg=#c0c080 gui=bold',
    \ 'guifg=#101020 guibg=#a0a0ff gui=bold',
    \ 'guifg=#101020 guibg=#a0ffa0 gui=bold',
    \ 'guifg=#101020 guibg=#ffa0a0 gui=bold',
    \ 'guifg=#101020 guibg=#a0ffff gui=bold',
    \ 'guifg=#101020 guibg=#ffffa0 gui=bold',
    \ ]

nmap  "  <Plug>(quickhl-manual-this)
xmap  "  <Plug>(quickhl-manual-this)
nnoremap <silent>  <C-c>  :<C-u>nohlsearch <Bar> QuickhlManualReset<CR>



" quickrun {{{2

let g:quickrun_no_default_key_mappings = 1

if !exists('g:quickrun_config')
    let g:quickrun_config = {}
endif
let g:quickrun_config.cpp = {
    \ 'cmdopt': '--std=c++17 -Wall -Wextra',
    \ }
let g:quickrun_config.d = {
    \ 'exec': 'dub run',
    \ }
let g:quickrun_config.haskell = {
    \ 'exec': ['stack build', 'stack exec %{matchstr(globpath(".,..,../..,../../..", "*.cabal"), "\\w\\+\\ze\\.cabal")}'],
    \ }
let g:quickrun_config.python = {
    \ 'command': 'python3',
    \ }


nmap  BB  <Plug>(quickrun)
xmap  BB  <Plug>(quickrun)
" nnoremap  BB  make<CR>




" repeat {{{2

nmap  U  <Plug>(RepeatRedo)
" Autoload vim-repeat immediately in order to make <Plug>(RepeatRedo) available.
" repeat#setreg() does nothing here.
call repeat#setreg('', '')


" Make them repeatable with vim-repeat.
nnoremap <silent>  <Plug>(my-insert-blank-lines-after)
    \ :<C-u>call <SID>insert_blank_line(0)<Bar>
    \ silent! call repeat#set("\<Lt>Plug>(my-insert-blank-lines-after)")<CR>
nnoremap <silent>  <Plug>(my-insert-blank-lines-before)
    \ :<C-u>call <SID>insert_blank_line(1)<Bar>
    \ silent! call repeat#set("\<Lt>Plug>(my-insert-blank-lines-before)")<CR>



" ripgrep {{{2

" Workaround: do not open quickfix window.
" exe g:rg_window_location 'copen'
let g:rg_window_location = 'silent! echo'
let g:rg_jump_to_first = 1

command! -bang -nargs=* -complete=file -bar
    \ RG
    \ Rg<bang> <args>


" rust {{{2

let g:rustfmt_autosave = 1




" sandwich {{{2

call operator#sandwich#set('add', 'all', 'highlight', 2)
call operator#sandwich#set('delete', 'all', 'highlight', 0)
call operator#sandwich#set('replace', 'all', 'highlight', 2)





" splitjoin {{{2

" Note: Don't use J{any sign}, 'Jl' and 'JL'. They will conflict with 'vim-jplus'.
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''

nnoremap <silent>  JS  :<C-u>SplitjoinSplit<CR>
nnoremap <silent>  JJ  :<C-u>SplitjoinJoin<CR>



" submode {{{2

" Global settings {{{3
let g:submode_always_show_submode = 1
let g:submode_keyseqs_to_leave = ['<C-c>', '<ESC>']
let g:submode_keep_leaving_key = 1

" yankround {{{3
call submode#enter_with('YankRound', 'nv', 'rs', 'gp', '<Plug>(yankround-p)')
call submode#enter_with('YankRound', 'nv', 'rs', 'gP', '<Plug>(yankround-P)')
call submode#map('YankRound', 'nv', 'rs', 'p', '<Plug>(yankround-prev)')
call submode#map('YankRound', 'nv', 'rs', 'P', '<Plug>(yankround-next)')

" swap {{{3
call submode#enter_with('Swap', 'n', 'r', 'g>', '<Plug>(swap-next)')
call submode#map('Swap', 'n', 'r', '<', '<Plug>(swap-prev)')
call submode#enter_with('Swap', 'n', 'r', 'g<', '<Plug>(swap-prev)')
call submode#map('Swap', 'n', 'r', '>', '<Plug>(swap-next)')

" Resizing a window (height) {{{3
call submode#enter_with('WinResizeH', 'n', '', 'trh')
call submode#enter_with('WinResizeH', 'n', '', 'trh')
call submode#map('WinResizeH', 'n', '', '+', '<C-w>+')
call submode#map('WinResizeH', 'n', '', '-', '<C-w>-')

" Resizing a window (width) {{{3
call submode#enter_with('WinResizeW', 'n', '', 'trw')
call submode#enter_with('WinResizeW', 'n', '', 'trw')
call submode#map('WinResizeW', 'n', '', '+', '<C-w>>')
call submode#map('WinResizeW', 'n', '', '-', '<C-w><Lt>')

" Super undo/redo {{{3
call submode#enter_with('Undo/Redo', 'n', '', 'gu', 'g-')
call submode#map('Undo/Redo', 'n', '', 'u', 'g-')
call submode#enter_with('Undo/Redo', 'n', '', 'gU', 'g+')
call submode#map('Undo/Redo', 'n', '', 'U', 'g+')



" swap {{{2

let g:swap_no_default_key_mappings = 1



" textobj-continuousline {{{2

let g:textobj_continuous_line_no_default_key_mappings = 1

omap  aL  <Plug>(textobj-continuous-cpp-a)
xmap  aL  <Plug>(textobj-continuous-cpp-a)
omap  iL  <Plug>(textobj-continuous-cpp-i)
xmap  iL  <Plug>(textobj-continuous-cpp-i)

Autocmd FileType vim omap <buffer>  aL  <Plug>(textobj-continuous-vim-a)
Autocmd FileType vim xmap <buffer>  aL  <Plug>(textobj-continuous-vim-a)
Autocmd FileType vim omap <buffer>  iL  <Plug>(textobj-continuous-vim-i)
Autocmd FileType vim xmap <buffer>  iL  <Plug>(textobj-continuous-vim-i)



" textobj-lastpaste {{{2

let g:textobj_lastpaste_no_default_key_mappings = 1

omap  iP  <Plug>(textobj-lastpaste-i)
xmap  iP  <Plug>(textobj-lastpaste-i)
omap  aP  <Plug>(textobj-lastpaste-a)
xmap  aP  <Plug>(textobj-lastpaste-a)



" textobj-space {{{2

let g:textobj_space_no_default_key_mappings = 1

omap  a<Space>  <Plug>(textobj-space-a)
xmap  a<Space>  <Plug>(textobj-space-a)
omap  i<Space>  <Plug>(textobj-space-i)
xmap  i<Space>  <Plug>(textobj-space-i)


" textobj-wiw {{{2

let g:textobj_wiw_no_default_key_mappings = 1

nmap  <C-w>  <Plug>(textobj-wiw-n)
omap  <C-w>  <Plug>(textobj-wiw-n)
xmap  <C-w>  <Plug>(textobj-wiw-n)
nmap  g<C-w>  <Plug>(textobj-wiw-p)
omap  g<C-w>  <Plug>(textobj-wiw-p)
xmap  g<C-w>  <Plug>(textobj-wiw-p)
nmap  <C-e>  <Plug>(textobj-wiw-N)
omap  <C-e>  <Plug>(textobj-wiw-N)
xmap  <C-e>  <Plug>(textobj-wiw-N)
nmap  g<C-e>  <Plug>(textobj-wiw-P)
omap  g<C-e>  <Plug>(textobj-wiw-P)
xmap  g<C-e>  <Plug>(textobj-wiw-P)

omap  a<C-w>  <Plug>(textobj-wiw-a)
xmap  a<C-w>  <Plug>(textobj-wiw-a)
omap  i<C-w>  <Plug>(textobj-wiw-i)
xmap  i<C-w>  <Plug>(textobj-wiw-i)



" window-adjuster {{{2

nnoremap <silent>  tRw  :<C-u>AdjustScreenWidth<CR>
nnoremap <silent>  tRh  :<C-u>AdjustScreenHeight<CR>
nnoremap <silent>  tRr  :<C-u>AdjustScreenWidth <Bar> AdjustScreenHeight<CR>





" yankround {{{2

let g:yankround_dir = g:MY_ENV.yankround_dir
let g:yankround_use_region_hl = 1











" Utilities {{{1

"" Wrapper of |getchar()|.
function! s:getchar()
    let ch = getchar()
    while ch == "\<CursorHold>"
        let ch = getchar()
    endwhile
    return type(ch) == v:t_number ? nr2char(ch) : ch
endfunction


"" Wrapper of |:echo| and |:echohl|.
function! s:echo(message, ...) abort
    let highlight = get(a:000, 0, 'None')
    redraw
    execute 'echohl' highlight
    echo a:message
    echohl None
endfunction


"" Wrapper of |getchar()|.
function! s:getchar_with_prompt(prompt) abort
    call s:echo(a:prompt)
    return s:getchar()
endfunction


"" Wrapper of |input()|.
"" Only when it is used in a mapping, |inputsave()| and |inputstore()| are
"" required.
function! s:input(...) abort
    call inputsave()
    let result = call('input', a:000)
    call inputrestore()
    return result
endfunction


"" Wrapper of |win_screenpos()|, |winheight()| and |winwidth()|.
"" Returns quadruple consisting of y, x, width and height.
function! s:win_getrect(...) abort
    let win = get(a:000, 0, 0)
    let [y, x] = win_screenpos(win)
    let h = winheight(win)
    let w = winwidth(win)
    return [y, x, h, w]
endfunction



" Modelines {{{1
" vim: expandtab:softtabstop=4:shiftwidth=4:textwidth=80:colorcolumn=+1:
" vim: foldenable:foldmethod=marker:foldlevel=0:
