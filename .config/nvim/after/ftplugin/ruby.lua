vimrc.after_ftplugin('ruby', function(conf)
   conf.indent(conf.SPACE, 2)
   vim.g.ruby_space_errors = true
end)
