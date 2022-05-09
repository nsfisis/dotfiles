scriptencoding utf-8

if exists('g:loaded_leaf')
    finish
endif


nmap  <Space>  <Nop>
nmap  <Space>l  (leaf)
nnoremap  (leaf)  <Nop>

nnoremap  (leaf)l  <Cmd>SmartTabEdit ~/leaves/INBOX.leaf <Bar>normal G<CR>


let g:loaded_leaf = 1
