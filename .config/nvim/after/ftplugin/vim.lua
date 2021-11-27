vimrc.after_ftplugin('vim', function(conf)
   conf.indent(conf.SPACE, 4)
   vim.wo.colorcolumn = '+1'
   vim.bo.keywordprg = ':help'
   vim.bo.textwidth = 78
   vim.g.vim_indent_cont = 4
end)