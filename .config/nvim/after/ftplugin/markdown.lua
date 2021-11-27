vimrc.after_ftplugin('markdown', function(conf)
   conf.indent(conf.SPACE, 4)
   vim.g.markdown_syntax_conceal = false
end)
