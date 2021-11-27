vimrc.after_ftplugin('cpp', function(conf)
   conf.indent(conf.SPACE, 4)
   vim.bo.cinoptions = ':0,l1,g0,N-s'
   vim.g.c_comment_strings = true
   vim.g.c_space_errors = true
end)