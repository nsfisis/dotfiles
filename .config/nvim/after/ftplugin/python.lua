vimrc.after_ftplugin('python', function(conf)
   conf.indent(conf.SPACE, 4)
   vim.g.python_highlight_all = true
   vim.g.pyindent_continue = 4
end)