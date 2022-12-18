vimrc.after_ftplugin('qf', function(conf)
   -- Preview
   vim.keymap.set('n', 'o', '<CR>zz<C-w>p', { buffer = true })
end)
