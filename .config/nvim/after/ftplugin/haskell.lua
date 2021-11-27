vimrc.after_ftplugin('haskell', function(conf)
   conf.indent(conf.SPACE, 4)
   vim.g.hs_highlight_boolean = true
   vim.g.hs_highlight_types = true
   vim.g.hs_highlight_more_types = true
   vim.g.hs_highlight_debug = true
   vim.g.hs_allow_hash_operator = true
end)
