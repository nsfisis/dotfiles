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



function M.hi(group, attributes)
   vim.cmd(('highlight! %s %s'):format(group, attributes))
end


function M.hi_link(from, to)
   vim.cmd(('highlight! link %s %s'):format(from, to))
end

function M.map(mode, lhs, rhs, opts)
   if opts == nil then
      opts = {}
   end
   opts.noremap = true
   vim.api.nvim_set_keymap(
      mode,
      lhs,
      rhs,
      opts)
end


function M.remap(mode, lhs, rhs, opts)
   if opts == nil then
      opts = {}
   end
   vim.api.nvim_set_keymap(
      mode,
      lhs,
      rhs,
      opts)
end


M.map_callbacks = {}

function M.map_expr(mode, lhs, rhs, opts)
   if opts == nil then
      opts = {}
   end
   opts.noremap = true
   opts.expr = true
   local callback_id = #M.map_callbacks + 1
   M.map_callbacks[callback_id] = rhs
   vim.api.nvim_set_keymap(
      mode,
      lhs,
      ('v:lua.vimrc.map_callbacks[%d]()'):format(callback_id),
      opts)
end


function M.map_cmd(mode, lhs, rhs, opts)
   if opts == nil then
      opts = {}
   end
   opts.noremap = true
   opts.silent = true
   vim.api.nvim_set_keymap(
      mode,
      lhs,
      (':<C-u>%s<CR>'):format(rhs),
      opts)
end


function M.map_plug(mode, lhs, rhs, opts)
   if opts == nil then
      opts = {}
   end
   vim.api.nvim_set_keymap(
      mode,
      lhs,
      '<Plug>' .. rhs,
      opts)
end


M.unmap = vim.api.nvim_del_keymap


-- Wrapper of |getchar()|.
function M.getchar()
   local ch = vim.fn.getchar()
   while ch == "\\<CursorHold>" do
      ch = vim.fn.getchar()
   end
   return type(ch) == 'number' and vim.fn.nr2char(ch) or ch
end


-- Wrapper of |:echo| and |:echohl|.
function M.echo(message, hl)
   if not hl then
      hl = 'None'
   end
   vim.cmd('redraw')
   vim.api.nvim_echo({{ message, hl }}, false, {})
end


-- Wrapper of |getchar()|.
function M.getchar_with_prompt(prompt)
   M.echo(prompt, 'Question')
   return M.getchar()
end


-- Wrapper of |input()|.
-- Only when it is used in a mapping, |inputsave()| and |inputstore()| are
-- required.
function M.input(prompt)
   vim.fn.inputsave()
   local result = vim.fn.input(prompt)
   vim.fn.inputrestore()
   return result
end


function M.term(s)
   return vim.api.nvim_replace_termcodes(s, true, true, true)
end



return M
