local M = {}



local autocmd_callbacks = {}
M.autocmd_callbacks = autocmd_callbacks

function M.autocmd(event, filter, callback)
   local callback_id = #autocmd_callbacks + 1
   autocmd_callbacks[callback_id] = callback
   vim.cmd(('autocmd Vimrc %s %s lua vimrc.autocmd_callbacks[%d]()'):format(
      event,
      filter,
      callback_id))
end



function M.after_ftplugin(ft, callback)
   local var_name = 'did_ftplugin_' .. ft .. '_after'
   if vim.b[var_name] ~= nil then
      return
   end

   callback(conf)

   vim.b[var_name] = true
end



function M.register_filetype_autocmds_for_indentation()
   local SPACE = true
   local TAB = false

   local indentation_settings = {
      c          = { style = SPACE, width = 4 },
      cmake      = { style = SPACE, width = 2 },
      cpp        = { style = SPACE, width = 4 },
      css        = { style = SPACE, width = 2 },
      go         = { style = TAB,   width = 4 },
      haskell    = { style = SPACE, width = 4 },
      html       = { style = SPACE, width = 2 },
      javascript = { style = SPACE, width = 2 },
      json       = { style = SPACE, width = 2 },
      lisp       = { style = SPACE, width = 2 },
      lua        = { style = SPACE, width = 3 },
      markdown   = { style = SPACE, width = 4 },
      php        = { style = SPACE, width = 2 },
      python     = { style = SPACE, width = 4 },
      ruby       = { style = SPACE, width = 2 },
      toml       = { style = SPACE, width = 2 },
      typescript = { style = SPACE, width = 2 },
      vim        = { style = SPACE, width = 4 },
      yaml       = { style = SPACE, width = 2 },
   }

   for ft, setting in pairs(indentation_settings) do
      vim.cmd(([[autocmd Vimrc FileType %s lua vimrc._set_indentation(%s, %d)]]):format(
         ft,
         setting.style,
         setting.width
      ))
   end
end

function M._set_indentation(style, width)
   vim.bo.expandtab = style
   vim.bo.tabstop = width
   vim.bo.shiftwidth = width
   vim.bo.softtabstop = width

   if vim.fn.exists(':IndentLinesReset') == 2 then
      vim.cmd('IndentLinesReset')
   end
end



return M
