" Set Vim's internal encodding.
" Note: This option must be set before 'scriptencoding' is set.
set encoding=utf-8
" Set this file's encoding.
scriptencoding utf-8


" Global settings {{{1

" The ideom to get |<SID>|. {{{2

function! s:get_sid() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_get_sid$')
endfunction

let s:SID = s:get_sid()
let s:SNR = '<SNR>' . s:SID . '_'

delfunction s:get_sid



" Global variables. {{{2

let g:MY_ENV = {}

if has('mac')
    let g:MY_ENV.os = 'mac'
elseif has('win32unix') || has('win32') || has('win64')
    let g:MY_ENV.os = 'windows'
else
    let g:MY_ENV.os = 'unknown'
endif

let g:MY_ENV.vim_dir = !empty($XDG_CONFIG_HOME) ? expand('$XDG_CONFIG_HOME/vim') :
    \                 g:MY_ENV.os ==# 'windows' ? expand('$HOME/vimfiles') :
    \                                             expand('$HOME/.vim')
let g:MY_ENV.my_dir = g:MY_ENV.vim_dir . '/my'
let g:MY_ENV.plug_dir = g:MY_ENV.vim_dir . '/plugged'
let g:MY_ENV.cache_dir = !empty($XDG_CACHE_HOME) ? expand('$XDG_CACHE_HOME/vim') :
    \                                              g:MY_ENV.vim_dir . '/cache'
let g:MY_ENV.undo_dir      = g:MY_ENV.cache_dir . '/undo'
let g:MY_ENV.backup_dir    = g:MY_ENV.cache_dir . '/backup'
let g:MY_ENV.swap_dir      = g:MY_ENV.cache_dir . '/swap'
let g:MY_ENV.yankround_dir = g:MY_ENV.cache_dir . '/yankround'

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


" Variable for re-entrancy of .vimrc {{{2

" If an operation cannot be executed twice, enclose it with if block.
"
" if !s:is_reloading_vimrc
"     ...
" end
"
" See "SourceThisFile()" defined in this file for practical example.
let s:is_reloading_vimrc = v:vim_did_enter


" Language {{{2

" Disable L10N.
language messages C
language time C





" Options {{{1

" * Use |:set|, not |:setglobal|.
"   |:setglobal| does not set local options, so options are not set in
"   the starting buffer you specified as commandline arguments like
"   "$ vim ~/.vimrc".

" Initialize all options with Vim's default values.
set all&



" Moving around, searching and patterns {{{2

set nowrapscan
set incsearch
set ignorecase
set smartcase



" Tags {{{2

set tags+=../tags
    \ tags+=../../tags
set tagcase=match



" Displaying text {{{2

set scrolloff=7
set wrap
set linebreak
set breakindent
set breakindentopt+=sbr
" Use let statement to avoid trailing space.
let &showbreak = '> '
set sidescrolloff=20
set display=lastline
" Use let statement to avoid trailing space.
let &fillchars = 'stl: ,stlnc: ,vert: ,fold: ,diff: '
set cmdheight=2
set list
let &listchars="eol:\u00ac,tab:\u25b8 ,extends:\u00bb,precedes:\u00ab"
set conceallevel=2
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
set nocursorline
set colorcolumn=+1


" Multiple windows {{{2

set laststatus=2
set equalalways
set eadirection=both
set winminheight=0
set hidden
set switchbuf=usetab



" Multiple tabpages {{{2

set showtabline=2



" Terminal {{{2

set notitle



" Using the mouse {{{2

set mouse=



" GUI {{{2

if has('gui_running')
    set guifont=Ricty\ 14
    " set guifontwide=Ricty\ 14
    if exists('+antialias')
        set antialias
    endif
    set guioptions+=M
        \ guioptions+=c
        \ guioptions+=i
        \ guioptions-=A
        \ guioptions-=L
        \ guioptions-=P
        \ guioptions-=R
        \ guioptions-=T
        \ guioptions-=a
        \ guioptions-=b
        \ guioptions-=e
        \ guioptions-=h
        \ guioptions-=l
        \ guioptions-=m
        \ guioptions-=r
    set langmenu=none
    set winaltkeys=no
    set guicursor+=a:blinkon0
endif



" Messages and info {{{2

set shortmess+=a
    \ shortmess+=s
    \ shortmess+=I
    \ shortmess+=c
set showcmd
set noshowmode
set report=999
set confirm
set belloff=all
set helplang=en,ja



" Selecting text {{{2

set clipboard=



" Editing text {{{2

set undofile
let &undodir = g:MY_ENV.undo_dir
set textwidth=0
set backspace=indent,eol,start
"TODO: set formatoptions+=
set complete+=t
set completeopt-=preview
set pumheight=10
set noshowmatch
set matchpairs+=<:>
set nojoinspaces
set nrformats-=octal



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
" TODO

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
set fileformats=unix,dos,mac
" Note: these settings make one backup. If you want more backups, see
"       |'backupext'|.
set backup
let &backupdir = g:MY_ENV.backup_dir
set autowrite
" Instead, use 'confirm'.
" set noautowriteall&
set autoread



" The swap file {{{2

" Note: 'dictionary' is swap files' directory.
" '//' is converted to swap file's path.
" If you are editing 'a/b.vim', Vim makes '{g:MY_ENV.cache_dir}/swap/a/b.vim'.
let &directory = g:MY_ENV.swap_dir . '//'



" Command line editing {{{2
set history=2000
set wildignore+=*.o,*.obj,*.lib
set wildignorecase
set wildmenu



" Executing external commands {{{2

set shell=zsh

set keywordprg=


" multi-byte characters {{{2

" Note: if 'fileencoding' is empty, 'encoding' is used.
set fileencodings=utf-8,cp932,euc-jp
set termencoding=utf-8
set ambiwidth=double



" Misc. {{{2

set maxfuncdepth=50
set sessionoptions+=localoptions
    \ sessionoptions+=resize
    \ sessionoptions+=winpos
let &viminfo .= ',n' . g:MY_ENV.cache_dir . '/viminfo'



" Note: List of options that may break plugins' behaviors. {{{2

" I will check these options in my plugins.
"     * autochdir (as much as possible)
"     * gdefault
"     * magic
"     * selection
"     * startofline
"     * whichwrap

" I will not check these options in my plugins, and suppose that they are left
" default.
"     * compatible
"     * cpoptions (i.e., do not use |use-cpo-save| ideom)
"     * edcompatible
"     * remap
"     * cedit (map to <C-f>)






" Installed plugins {{{1

call plug#begin(g:MY_ENV.plug_dir)

" Filetype-specific plugins are placed at the first letter of the filetype.
" E.g., plugins for Vim Script are placed in "V", even if their name don't
" begin with "V".

" A {{{2
" Switch to related files.
Plug 'kana/vim-altr'
" Async job control and completion API for vim-lsp.
" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'prabirshrestha/asyncomplete-lsp.vim'
" Extend * and #.
Plug 'haya14busa/vim-asterisk'
" If a directory is missing, make it automatically.
Plug 'mopp/autodirmake.vim'
" Auto-format python code by using autopep8.
Plug 'tell-k/vim-autopep8'

" B {{{2

" C {{{2
" Capture the output of a command.
Plug 'tyru/capture.vim'
" Comment out.
Plug 'tyru/caw.vim'
" Integrate with clang-format, the formater for C/C++.
Plug 'rhysd/vim-clang-format'
" Show highlight.
Plug 'cocopon/colorswatch.vim'
" Write git commit message.
Plug 'rhysd/committia.vim'
" Make gui-only color schemes 256colors-compatible.
Plug 'godlygeek/csapprox'

" D {{{2
" Filer for minimalists.
Plug 'justinmk/vim-dirvish'

" E {{{2
" Align text.
Plug 'junegunn/vim-easy-align'
" Motion on speed.
Plug 'easymotion/vim-easymotion'

" F {{{2
" Makes folding text cool.
Plug 'LeafCage/foldCC.vim'

" G {{{2

" H {{{2
" Syntax for HCL.
Plug 'b4b4r07/vim-hcl'

" I {{{2
" Extend incremental search.
Plug 'haya14busa/incsearch.vim'
" Incremntal search on EasyMotion.
Plug 'haya14busa/incsearch-easymotion.vim'
" Show indent.
Plug 'Yggdroot/indentLine'

" J {{{2
" Modern JavaScript
Plug 'pangloss/vim-javascript'
" Extend J.
Plug 'osyo-manga/vim-jplus'
" Filetype JSON5
Plug 'GutenYe/json5.vim'

" K {{{2

" L {{{2
" Cool status line.
Plug 'itchyny/lightline.vim'
" LSP; Language Server Protocol
" Plug 'prabirshrestha/vim-lsp'

" M {{{2
" MoonScript
Plug 'leafo/moonscript-vim'

" N {{{2
" Improve behaviors of I, A and gI in Blockwise-Visual mode.
Plug 'kana/vim-niceblock'
" Syntax highlighting for Nginx conf file.
Plug 'chr4/nginx.vim'

" O {{{2
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
" Support to define user-defined operator.
Plug 'kana/vim-operator-user'
" Emacs' org-mode
Plug 'jceb/vim-orgmode'

" P {{{2
" Highlight matched parentheses.
Plug 'itchyny/vim-parenmatch'
" Pretty printing for Vim script.
Plug 'thinca/vim-prettyprint'

" Q {{{2
" Edit QuickFix and reflect to original buffers.
Plug 'thinca/vim-qfreplace'
" Highlight specified words.
Plug 't9md/vim-quickhl'
" Run anything.
Plug 'thinca/vim-quickrun'

" R {{{2
" Extend dot-repeat.
Plug 'tpope/vim-repeat'
" Rust the programming language.
Plug 'rust-lang/rust.vim'

" S {{{2
" Super surround.
Plug 'machakann/vim-sandwich'
" Judge Vim power.
Plug 'thinca/vim-scouter'
" Split one line format and Join multiline format.
Plug 'AndrewRadev/splitjoin.vim'
" Introduce user-defined mode.
Plug 'kana/vim-submode'
" Swap arguments.
Plug 'machakann/vim-swap'

" T {{{2
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
" Support to define user-defined text object.
Plug 'kana/vim-textobj-user'
" Text object for words in words.
Plug 'h1mesuke/textobj-wiw'
" TOML.
Plug 'cespare/vim-toml'
" TypeScript
Plug 'leafgarland/typescript-vim'

" U {{{2

" V {{{2
" Vim documentation in Japanese.
Plug 'vim-jp/vimdoc-ja'

" W {{{2
" Adjust window size.
Plug 'rhysd/vim-window-adjuster'

" X {{{2

" Y {{{2
" Remember yank history and paste them.
Plug 'LeafCage/yankround.vim'

" Z {{{2

" Mine {{{2
Plug g:MY_ENV.my_dir

" Fork version of jremmen/vim-ripgrep
" Integration with ripgrep, fast alternative of grep command.
Plug 'nsfisis/vim-ripgrep'

call plug#end()





" Autocommands {{{1

Autocmd VimResized * wincmd =


" Calculate 'numberwidth' to fit file size.
" Note: extra 2 is the room of left and right spaces.
Autocmd BufEnter,WinEnter,BufWinEnter *
    \ let &l:numberwidth = len(line('$')) + 2


" Syntax highlight for .vimrc {{{2

Autocmd Filetype vim
    \ if expand('%') =~? 'vimrc' | call s:highlight_vimrc() | endif


function! s:highlight_vimrc() abort
    " Autocmd
    syn keyword vimrcAutocmd Autocmd skipwhite nextgroup=vimAutoEventList

    " Plugin manager command
    syn keyword vimrcPluginManager Plug

    hi def link vimrcAutocmd       vimAutocmd
    hi def link vimrcPluginManager vimCommand
endfunction



Autocmd ColorScheme ocean call s:extra_highlight()


function! s:extra_highlight() abort
    if &background != 'dark'
        return
    endif

    hi! link YankRoundRegion DiffChange

    hi! link OperatorSandwichBuns   DiffChange
    hi! link OperatorSandwichStuff  DiffChange
    hi! link OperatorSandwichDelete DiffChange
    hi! link OperatorSandwichAdd    OperatorSandwichBuns

    hi EasyMotionShade guifg=#4d4d4d guibg=NONE gui=NONE cterm=NONE
    hi EasyMotionTarget guifg=#ff7100 guibg=NONE gui=underline cterm=underline
    hi! link EasyMotionMoveHL IncSearch
endfunction




" Mappings {{{1

" Note: |:noremap| defines mappings in |Normal|, |Visual|, |Operator-Pending|
" and |Select| mode. Because I don't use |Select| mode, |:noremap| is executed
" as substitute of |:nnoremap|, |:xnoremap| and |:onoremap| for simplicity.


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


" Execute the laste executed macro again.
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
" In default, select text characterwise, neither blockwise nor linewise.
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




" Disable unuseful mappings. {{{2

" Avoid entering Select mode.
nnoremap  gh  <Nop>
nnoremap  gH  <Nop>
nnoremap  g<C-h>  <Nop>

nnoremap  ZZ  <Nop>
nnoremap  ZQ  <Nop>


" Help {{{2

" Search help.
nnoremap  <C-h>  :<C-u>SmartOpen help<Space>



" For writing Vim script. {{{2


if !s:is_reloading_vimrc
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



nnoremap <silent>  <Space>o  :<C-u>call <SID>insert_blank_line(0)<CR>
nnoremap <silent>  <Space>O  :<C-u>call <SID>insert_blank_line(1)<CR>

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

    if exists('b:undo_ftplugin')
        let b:undo_ftplugin .= '|setlocal ' . option_name . '<'
    else
        let b:undo_ftplugin = 'setlocal ' . option_name . '<'
    endif
endfunction




" Color scheme {{{1

" A command which changes color scheme with fall back.
command! -bang -nargs=?
    \ ColorScheme
    \ call s:colorscheme(<bang>0, <q-args>)


function! s:colorscheme(bang, name) abort
    try
        if get(g:, 'colors_name') isnot# a:name || a:bang
            execute 'colorscheme' a:name
        endif
    catch
        " Loading colorscheme failed.
        " The color scheme, "desert", is one of the built-in ones. Probably, it
        " will be loaded without any errors.
        colorscheme desert
    endtry
endfunction


ColorScheme! ocean




" Plugins configuration {{{1

" Disable standard plugins. {{{2

let g:loaded_2html_plugin     = 1
let g:loaded_getscriptPlugin  = 1
let g:loaded_gzip             = 1
let g:loaded_logiPat          = 1
let g:loaded_matchparen       = 1
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



" incsearch-easymotion {{{2

nmap  s/  <Plug>(incsearch-easymotion-stay)
omap  s/  <Plug>(incsearch-easymotion-stay)
xmap  s/  <Plug>(incsearch-easymotion-stay)
nmap  s?  <Plug>(incsearch-easymotion-stay)
omap  s?  <Plug>(incsearch-easymotion-stay)
xmap  s?  <Plug>(incsearch-easymotion-stay)
nmap  sg/  <Plug>(incsearch-easymotion-stay)
omap  sg/  <Plug>(incsearch-easymotion-stay)
xmap  sg/  <Plug>(incsearch-easymotion-stay)



" indentline {{{2

let g:indentLine_fileTypeExclude = ['help', 'chart']



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



" lightline {{{2

let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ 'active': {
    \     'left': [['mode', 'paste'], ['readonly', 'filename', 'modified']],
    \     'right': [['linenum'], ['fileencoding', 'fileformat', 'filetype']]
    \ },
    \ 'inactive': {
    \     'left': [['readonly', 'filename', 'modified']],
    \     'right': [['linenum'], ['fileencoding', 'fileformat', 'filetype']]
    \ },
    \ 'component_function': {
    \   'linenum': s:SNR .. 'lightline_linenum',
    \   'fileformat': s:SNR .. 'lightline_fileformat',
    \ },
    \ 'mode_map': {
    \     'n' : 'N',
    \     'i' : 'I',
    \     'R' : 'R',
    \     'v' : 'V',
    \     'V' : 'V-L',
    \     "\<C-v>": 'V-B',
    \     'c' : 'C',
    \     's' : 'S',
    \     'S' : 'S-L',
    \     "\<C-s>": 'S-B',
    \     't': 'T',
    \ },
    \ 'tabline': {
    \     'left': [['tabs']],
    \     'right': [],
    \ },
    \ 'tab': {
    \     'active': ['tabnum', 'filename', 'modified'],
    \     'inactive': ['tabnum', 'filename', 'modified'],
    \ },
    \ }

function! s:lightline_linenum()
    return line('.') . '/' . line('$')
endfunction

function! s:lightline_fileformat()
    if &fileformat ==# 'unix'
        return 'LF'
    elseif &fileformat ==# 'dos'
        return 'CRLF'
    elseif &fileformat ==# 'mac'
        return 'CR'
    else
        return '-'
    endif
endfunction



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



" prettyprint {{{2

let g:prettyprint_indent = 2
let g:prettyprint_string = ['split']
let g:prettyprint_show_expression = 1



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

nmap U <Plug>(RepeatRedo)
" Work around. vim-repeatの内部構造に大きく依存する。
" repeat#setregの呼び出しが(ほぼ)副作用を持たないことが必要
" Autoload vim-repeat immediately in order to make <Plug>(RepeatRedo) available.
" repeat#setreg() does nothing here.
call repeat#setreg('', '')


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

let g:yankround_dir = g:MY_ENV.cache_dir . '/yankround'
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




" They are not used any longer. {{{2
if 0
    "" @param nr (WinNr or WinId) 0 means the current window.
    "" @return (Number) The window width applied 'numberwidth' and 'foldcolumn' to.
    function! s:displayed_winwidth(nr) abort
        let winwidth = winwidth(a:nr)
        let foldcolumn = getwinvar(a:nr, '&foldcolumn')
        let numberwidth = getwinvar(a:nr, '&number') ?
            \ max([getwinvar(a:nr, '&numberwidth'), len(line('$'))]) : 0

        return winwidth - foldcolumn - numberwidth
    endfunction



    "" Wrapper of |char2nr()|.
    function! s:char2nr(x, ...) abort
        return type(a:x) == v:t_number ?
            \ a:x :
            \ char2nr(a:x, get(a:000, 0, 0))
    endfunction



    "" Wrapper of |nr2char()|.
    function! s:nr2char(x, ...) abort
        return type(a:x) == v:t_string ?
            \ a:x :
            \ nr2char(a:x, get(a:000, 0, 0))
    endfunction



    "" @param begin (Char)
    "" @param end (Char) Included
    "" @return ([Char])
    "" e.g.) s:char_range('1', '5')
    ""       => ['1', '2', '3', '4', '5']
    function! s:char_range(begin, end) abort
        return map(range(s:char2nr(a:begin), s:char2nr(a:end)), 's:nr2char(v:val)')
    endfunction



    "" Splits a string character by character.
    "" @param str (String)
    "" @return ([Char])
    "" e.g.) s:each_char('bar')
    ""       => ['b', 'a', 'r']
    function! s:each_char(str) abort
        return split(a:str, '\zs')
    endfunction



    "" Returns a list of pairs of index and item.
    "" @param list (List)
    "" @return ([[Number, Any]])
    "" e.g.) s:with_index(['a', 'b', 'c'])
    ""       => [[0, 'a'], [1, 'b'], [2, 'c']]
    function! s:with_index(list) abort
        return map(a:list, '[v:key, v:val]')
    endfunction



    "" Concatenates all passed lists and returns it.
    "" @param ... ([Any])
    "" @return ([List])
    function! s:extend_list(...) abort
        let ret = []
        for list in a:000
            call extend(ret, list)
        endfor
        return ret
    endfunction



    "" @param list ([Any])
    "" @param length (Number)
    "" @param [filled_item] (Any)
    function! s:normalize_list_length(list, length, ...) abort
        let delta = len(a:list) - a:length
        if delta < 0 " too short
            let filled_item = a:1
            return expand(a:list, repeat(filled_item, -delta))
        else " too long
            return a:list[:(delta - 1)]
        endif
    endfunction



    " If the current line contains any multibyte characters, It doesn't work:
    "     getline('.')[col('.') - 1]
    " This function can handle multibyte characters.
    function! s:get_cursor_char() abort
        return matchstr(getline('.'), '.' , col('.') - 1)
    endfunction
endif





" Modelines {{{1
" vim: expandtab:softtabstop=4:shiftwidth=4:textwidth=80:colorcolumn=+1:
" vim: foldenable:foldmethod=marker:foldlevel=0:
