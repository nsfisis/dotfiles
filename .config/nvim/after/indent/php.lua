vimrc.after_indent('php', function(conf)
   -- The default indent plugin for PHP bundled with Neovim disables
   -- 'smartindent' and 'autoindent' because the plugin fully handles
   -- indentation by itself. However, I use nvim-treesitter plugin for PHP
   -- indentation, which requires that these options are on.
   vim.bo.smartindent = true
   vim.bo.autoindent = true
end)
