local M = {}



local vimrc_augroup

function M.create_augroup_for_vimrc()
   vimrc_augroup = vim.api.nvim_create_augroup('Vimrc', {})
end

function M.autocmd(event, opts)
   if not opts.group then
      opts.group = vimrc_augroup
   end
   vim.api.nvim_create_autocmd(event, opts)
end



function M.after_ftplugin(ft, callback)
   local var_name = 'did_ftplugin_' .. ft .. '_after'
   if vim.b[var_name] ~= nil then
      return
   end

   callback(conf)

   vim.b[var_name] = true
end



function M.after_indent(ft, callback)
   local var_name = 'did_indent_' .. ft .. '_after'
   if vim.b[var_name] ~= nil then
      return
   end

   callback(conf)

   vim.b[var_name] = true
end



local function set_indentation(style, width)
   local editorconfig = vim.b.editorconfig or {}

   if not editorconfig.indent_style then
      vim.bo.expandtab = style
   end
   if not editorconfig.tab_width then
      vim.bo.tabstop = width
   end
   if not editorconfig.indent_size then
      vim.bo.shiftwidth = width
      vim.bo.softtabstop = width
   end
end


function M.register_filetype_autocmds_for_indentation()
   local SPACE = true
   local TAB = false

   local indentation_settings = {
      c               = { style = SPACE, width = 4 },
      cmake           = { style = SPACE, width = 2 },
      cpp             = { style = SPACE, width = 4 },
      css             = { style = SPACE, width = 2 },
      docbk           = { style = SPACE, width = 2 },
      go              = { style = TAB,   width = 4 },
      haskell         = { style = SPACE, width = 4 },
      html            = { style = SPACE, width = 2 },
      javascript      = { style = SPACE, width = 2 },
      javascriptreact = { style = SPACE, width = 2 },
      json            = { style = SPACE, width = 2 },
      leaf            = { style = SPACE, width = 4 },
      lisp            = { style = SPACE, width = 2 },
      lua             = { style = SPACE, width = 3 },
      markdown        = { style = SPACE, width = 4 },
      nix             = { style = SPACE, width = 2 },
      php             = { style = SPACE, width = 2 },
      python          = { style = SPACE, width = 4 },
      ruby            = { style = SPACE, width = 2 },
      satysfi         = { style = SPACE, width = 2 },
      sbt             = { style = SPACE, width = 2 },
      scala           = { style = SPACE, width = 2 },
      toml            = { style = SPACE, width = 2 },
      typescript      = { style = SPACE, width = 2 },
      typescriptreact = { style = SPACE, width = 2 },
      vim             = { style = SPACE, width = 4 },
      xml             = { style = SPACE, width = 2 },
      yaml            = { style = SPACE, width = 2 },
   }

   for ft, setting in pairs(indentation_settings) do
      vimrc.autocmd('FileType', {
         pattern = ft,
         callback = function()
            set_indentation(setting.style, setting.width)
         end,
      })
   end
end



function M.hi(group, attributes)
   vim.cmd(('highlight! %s %s'):format(group, attributes))
end


function M.hi_link(from, to)
   vim.cmd(('highlight! link %s %s'):format(from, to))
end


M.map_callbacks = {}



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



function M.iabbrev(from, to)
   vim.cmd(('inoreabbrev %s %s'):format(from, to))
end


function M.cabbrev(from, to)
   vim.cmd(('cnoreabbrev %s %s'):format(from, to))
end


return M
