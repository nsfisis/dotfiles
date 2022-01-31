scriptencoding utf-8

if exists('g:loaded_leaf')
    finish
endif


nmap  <Space>  <Nop>
nmap  <Space>l  (leaf)
nnoremap  (leaf)  <Nop>

nnoremap  (leaf)i  <Cmd>SmartTabEdit ~/leaves/INBOX.leaf<CR>
nnoremap  (leaf)t  <Cmd>SmartTabEdit ~/leaves/TODO.leaf<CR>
nnoremap  (leaf)c  <Cmd>SmartTabEdit ~/leaves/CALENDAR.leaf<CR>
nnoremap  (leaf)p  <Cmd>SmartTabEdit ~/leaves/PROJECTS.leaf<CR>
nnoremap  (leaf)s  <Cmd>SmartTabEdit ~/leaves/SOMEDAY.leaf<CR>
nnoremap  (leaf)r  <Cmd>SmartTabEdit ~/leaves/REFS.leaf<CR>
nnoremap  (leaf)A  <Cmd>SmartTabEdit ~/leaves/ARCHIVES.leaf<CR>

nnoremap  (leaf)l  <Cmd>SmartTabEdit ~/leaves/INBOX.leaf <Bar>normal G<CR>


let g:loaded_leaf = 1
