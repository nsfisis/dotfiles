vimrc.after_ftplugin('c', function(conf)
   conf.indent(conf.SPACE, 4)
   vim.bo.cinoptions = ':0,l1'
   vim.g.c_comment_strings = true
   vim.g.c_space_errors = true
end)
