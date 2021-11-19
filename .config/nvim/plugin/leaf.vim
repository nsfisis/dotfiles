scriptencoding utf-8

if exists('g:loaded_leaf')
    finish
endif


nmap  <Space>  <Nop>
nmap  <Space>l  (leaf)
nnoremap  (leaf)  <Nop>

nnoremap  (leaf)i  <Cmd>tabedit ~/leaves/INBOX.leaf<CR>
nnoremap  (leaf)t  <Cmd>tabedit ~/leaves/TODO.leaf<CR>
nnoremap  (leaf)c  <Cmd>tabedit ~/leaves/CALENDAR.leaf<CR>
nnoremap  (leaf)p  <Cmd>tabedit ~/leaves/PROJECTS.leaf<CR>
nnoremap  (leaf)s  <Cmd>tabedit ~/leaves/SOMEDAY.leaf<CR>
nnoremap  (leaf)r  <Cmd>tabedit ~/leaves/REFS.leaf<CR>
nnoremap  (leaf)A  <Cmd>tabedit ~/leaves/ARCHIVES.leaf<CR>

nnoremap  (leaf)l  <Cmd>tabedit ~/leaves/INBOX.leaf <Bar>normal G<CR>


let g:loaded_leaf = 1
