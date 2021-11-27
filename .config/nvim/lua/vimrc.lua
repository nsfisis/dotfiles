local vimrc = {}



local autocmd_callbacks = {}
vimrc.autocmd_callbacks = autocmd_callbacks

function vimrc.autocmd(event, filter, callback)
   local callback_id = #autocmd_callbacks + 1
   autocmd_callbacks[callback_id] = callback
   vim.cmd(('autocmd Vimrc %s %s lua vimrc.autocmd_callbacks[%d]()'):format(
      event,
      filter,
      callback_id))
end


local conf = {}
conf.SPACE = true
conf.TAB = false
function conf.indent(style, width)
   vim.bo.expandtab = style
   vim.bo.tabstop = width
   vim.bo.shiftwidth = width
   vim.bo.softtabstop = width

   if vim.fn.exists(':IndentLinesReset') == 2 then
      vim.cmd('IndentLinesReset')
   end
end

function vimrc.after_ftplugin(ft, callback)
   local var_name = 'did_ftplugin_' .. ft .. '_after'
   if vim.b[var_name] ~= nil then
      return
   end

   callback(conf)

   vim.b[var_name] = true
end



return vimrc
