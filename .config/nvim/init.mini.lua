require('my_env').mkdir()
require('vimrc').create_augroup_for_vimrc()
vim.api.nvim_create_user_command('PackerCompile', function() require('plugins').compile() end, {})
vim.api.nvim_create_user_command('PackerSync', function() require('plugins').sync() end, {})
