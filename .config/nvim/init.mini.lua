require('vimrc.my_env').mkdir()
require('vimrc').create_augroup_for_vimrc()
vim.api.nvim_create_user_command('PackerCompile', function() require('vimrc.plugins').compile() end, {})
vim.api.nvim_create_user_command('PackerSync', function() require('vimrc.plugins').sync() end, {})
