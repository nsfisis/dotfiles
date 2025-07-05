local F = vim.fn
local G = vim.g
local O = vim.o
local uniquify = require('uniquify')
local vimrc = require('vimrc')


-- TODO: nvim 0.11 workaround for highlight flickering
-- https://github.com/neovim/neovim/issues/32660#issuecomment-2692738191
vim.g._ts_force_sync_parsing = true


-- Statusline {{{1

O.statusline = '%!v:lua.vimrc.statusline.build()'

vimrc.statusline = {}

function vimrc.statusline.build()
   local winid = G.statusline_winid
   local bufnr = F.winbufnr(winid)
   local is_active = winid == F.win_getid()
   local fname = vimrc.statusline.filename(bufnr)
   if not is_active then
      return ' ' .. fname
   end
   local mode = vimrc.statusline.mode()
   local ro = vimrc.statusline.readonly(bufnr)
   local mod = vimrc.statusline.modified(bufnr)
   local extra_info = vimrc.statusline.extra_info(bufnr, winid)
   local linenum = vimrc.statusline.linenum(winid)
   local fenc = vimrc.statusline.fenc(bufnr)
   local eol = vimrc.statusline.eol(bufnr)
   local ff = vimrc.statusline.ff(bufnr)
   local ft = vimrc.statusline.filetype(bufnr)
   return string.format(
      ' %s  %s%s%s %%= %s%s %s%s%s %s ',
      mode,
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
      n                       = 'N',
      no                      = 'O',
      nov                     = 'Oc',
      noV                     = 'Ol',
      [vimrc.term('no<C-v>')] = 'Ob',
      niI                     = 'In',
      niR                     = 'Rn',
      niV                     = 'Rn',
      v                       = 'V',
      V                       = 'Vl',
      [vimrc.term('<C-v>')]   = 'Vb',
      s                       = 'S',
      S                       = 'Sl',
      [vimrc.term('<C-s>')]   = 'Sb',
      i                       = 'I',
      ic                      = 'I?',
      ix                      = 'I?',
      R                       = 'R',
      Rc                      = 'R?',
      Rv                      = 'R',
      Rx                      = 'R?',
      c                       = 'C',
      cv                      = 'C',
      ce                      = 'C',
      r                       = '-',
      rm                      = '-',
      ['r?']                  = '-',
      ['!']                   = '-',
      t                       = 'T',
   }
   local vim_mode = mode_map[F.mode(true)] or '-'

   local skk_mode
   if F.exists('*skkeleton#mode') == 1 then
      skk_mode = ({
         ['hira'] = ' (あ)',
         ['kata'] = ' (ア)',
         ['hankata'] = ' (半ア)',
         ['zenkaku'] = ' (全角英数)',
         ['abbrev'] = ' (abbrev)',
      })[F['skkeleton#mode']()] or ''
   else
      skk_mode = ''
   end

   return vim_mode .. skk_mode
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

   local this_path = F.expand(('#%d:p'):format(bufnr))
   local other_paths = {}
   for b = 1, F.bufnr('$') do
      if F.bufexists(b) and b ~= bufnr then
         other_paths[#other_paths+1] = F.expand(('#%d:p'):format(b))
      end
   end

   local result = uniquify.uniquify(this_path, other_paths)
   if vim.bo[bufnr].filetype == 'dirvish' then
      return '[dir] ' .. result .. '/'
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
