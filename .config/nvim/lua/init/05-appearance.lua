local F = vim.fn
local G = vim.g
local O = vim.o
local uniquify = require('uniquify')
local vimrc = require('vimrc')


-- Color scheme {{{1

if not pcall(function() vim.cmd('colorscheme ocean') end) then
   -- Load "desert", one of the built-in colorschemes, instead of mine
   -- when nvim failed to load it.
   vim.cmd('colorscheme desert')
end


-- Statusline {{{1

O.statusline = '%!v:lua.vimrc.statusline.build()'

vimrc.statusline = {}

function vimrc.statusline.build()
   local winid = G.statusline_winid
   local bufnr = F.winbufnr(winid)
   local is_active = winid == F.win_getid()
   local left
   if is_active then
      local mode, mode_hl = vimrc.statusline.mode()
      left = string.format('%%#statusLineMode%s# %s %%#statusLine#', mode_hl, mode)
   else
      left = ''
   end
   local ro = vimrc.statusline.readonly(bufnr)
   local fname = vimrc.statusline.filename(bufnr)
   local mod = vimrc.statusline.modified(bufnr)
   local extra_info = vimrc.statusline.extra_info(bufnr, winid)
   local linenum = vimrc.statusline.linenum(winid)
   local fenc = vimrc.statusline.fenc(bufnr)
   local eol = vimrc.statusline.eol(bufnr)
   local ff = vimrc.statusline.ff(bufnr)
   local ft = vimrc.statusline.filetype(bufnr)
   return string.format(
      '%s %s%s%s %%= %s%s %s%s%s %s ',
      left,
      ro and ro .. ' ' or '',
      fname,
      mod and ' ' .. mod or '',
      extra_info == '' and '' or extra_info .. ' ',
      linenum,
      fenc,
      eol,
      ff,
      ft)
end

function vimrc.statusline.mode()
   local mode_map = {
      n                       = { 'N',  'Normal'   },
      no                      = { 'O',  'Operator' },
      nov                     = { 'Oc', 'Operator' },
      noV                     = { 'Ol', 'Operator' },
      [vimrc.term('no<C-v>')] = { 'Ob', 'Operator' },
      niI                     = { 'In', 'Insert'   },
      niR                     = { 'Rn', 'Replace'  },
      niV                     = { 'Rn', 'Replace'  },
      v                       = { 'V',  'Visual'   },
      V                       = { 'Vl', 'Visual'   },
      [vimrc.term('<C-v>')]   = { 'Vb', 'Visual'   },
      s                       = { 'S',  'Visual'   },
      S                       = { 'Sl', 'Visual'   },
      [vimrc.term('<C-s>')]   = { 'Sb', 'Visual'   },
      i                       = { 'I',  'Insert'   },
      ic                      = { 'I?', 'Insert'   },
      ix                      = { 'I?', 'Insert'   },
      R                       = { 'R',  'Replace'  },
      Rc                      = { 'R?', 'Replace'  },
      Rv                      = { 'R',  'Replace'  },
      Rx                      = { 'R?', 'Replace'  },
      c                       = { 'C',  'Command'  },
      cv                      = { 'C',  'Command'  },
      ce                      = { 'C',  'Command'  },
      r                       = { '-',  'Other'    },
      rm                      = { '-',  'Other'    },
      ['r?']                  = { '-',  'Other'    },
      ['!']                   = { '-',  'Other'    },
      t                       = { 'T',  'Terminal' },
   }
   local vim_mode_and_hl = mode_map[F.mode(true)] or { '-', 'Other' }
   local vim_mode = vim_mode_and_hl[1]
   local hl = vim_mode_and_hl[2]

   -- Calling `eskk#statusline()` makes Vim autoload eskk. If you call it
   -- without checking `g:loaded_autoload_eskk`, eskk is loaded on an early
   -- stage of the initialization (probably the first rendering of status line),
   -- which slows down Vim startup. Loading eskk can be delayed by checking both
   -- of `g:loaded_eskk` and `g:loaded_autoload_eskk`.
   local skk_mode
   if G.loaded_eskk and G.loaded_autoload_eskk then
      skk_mode = F['eskk#statusline'](' (%s)', '')
   else
      skk_mode = ''
   end

   return vim_mode .. skk_mode, hl
end

function vimrc.statusline.readonly(bufnr)
   local ro = F.getbufvar(bufnr, '&readonly')
   if ro == 1 then
      return '[RO]'
   else
      return nil
   end
end

function vimrc.statusline.filename(bufnr)
   if F.bufname(bufnr) == '' then
      return '[No Name]'
   end
   if vim.b[bufnr]._scratch_ then
      return '*scratch*'
   end

   local simplify_bufname
   if vim.b[bufnr].fern then
      simplify_bufname = function(bufname)
         bufname = F['fern#fri#parse'](bufname).path
         if vim.startswith(bufname, 'file://') then
            bufname = bufname:sub(#'file://' + 1)
         end
         return bufname
      end
   else
      simplify_bufname = function(bufname) return bufname end
   end

   local this_path = simplify_bufname(F.expand(('#%s:p'):format(bufnr)))
   local other_paths = {}
   for b = 1, F.bufnr('$') do
      if F.bufexists(b) and b ~= bufnr then
         other_paths[#other_paths+1] = simplify_bufname(F.bufname(b))
      end
   end

   local result = uniquify.uniquify(this_path, other_paths)
   if vim.b[bufnr].fern then
      return '[fern] ' .. result .. '/'
   else
      return result
   end
end

function vimrc.statusline.modified(bufnr)
   local mod = F.getbufvar(bufnr, '&modified')
   local ma = F.getbufvar(bufnr, '&modifiable')
   if mod == 1 then
      return '[+]'
   elseif ma == 0 then
      return '[-]'
   else
      return nil
   end
end

function vimrc.statusline.extra_info(bufnr, winid)
   local autosave = F.getbufvar(bufnr, 'autosave_timer_id', -1) ~= -1
   local spell = F.getwinvar(winid, '&spell') == 1
   return (autosave and '(A)' or '') .. (spell and '(S)' or '')
end

function vimrc.statusline.linenum(winid)
   return F.line('.', winid) .. '/' .. F.line('$', winid)
end

function vimrc.statusline.fenc(bufnr)
   local fenc = F.getbufvar(bufnr, '&fileencoding')
   local bom = F.getbufvar(bufnr, '&bomb')  -- BOMB!!

   if fenc == '' then
      local fencs = F.split(O.fileencodings, ',')
      fenc = fencs[1] or O.encoding
   end
   if fenc == 'utf-8' then
      return bom == 1 and 'U8[BOM]' or 'U8'
   elseif fenc == 'utf-16' then
      return 'U16[BE]'
   elseif fenc == 'utf-16le' then
      return 'U16[LE]'
   elseif fenc == 'ucs-4' then
      return 'U32[BE]'
   elseif fenc == 'ucs-4le' then
      return 'U32[LE]'
   else
      return fenc:upper()
   end
end

function vimrc.statusline.eol(bufnr)
   local eol = F.getbufvar(bufnr, '&endofline')
   return eol == 0 and '[noeol]' or ''
end

function vimrc.statusline.ff(bufnr)
   local ff = F.getbufvar(bufnr, '&fileformat')
   if ff == 'unix' then
      return ''
   elseif ff == 'dos' then
      return ' (CRLF)'
   elseif ff == 'mac' then
      return ' (CR)'
   else
      return ' (Unknown)'
   end
end

function vimrc.statusline.filetype(bufnr)
   local ft = F.getbufvar(bufnr, '&filetype')
   if ft == '' then
      return '[None]'
   else
      return ft
   end
end


-- Tabline {{{1

O.tabline = '%!v:lua.vimrc.tabline.build()'

vimrc.tabline = {}

function vimrc.tabline.build()
   local tal = ''
   for tabnr = 1, F.tabpagenr('$') do
      local is_active = tabnr == F.tabpagenr()
      local buflist = F.tabpagebuflist(tabnr)
      local bufnr = buflist[F.tabpagewinnr(tabnr)]
      tal = tal .. string.format(
         '%%#%s# %s ',
         is_active and 'TabLineSel' or 'TabLine',
         vimrc.statusline.filename(bufnr))
   end
   return tal .. '%#TabLineFill#'
end
