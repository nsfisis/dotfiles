vim.cmd.packadd('packer.nvim')
local packer = require('packer')

-- Plugins {{{1
packer.startup(function(use)
   -- Plugin management {{{2
   use {
      'wbthomason/packer.nvim',
      opt = true,
   }
   -- Libraries {{{2
   -- telescope.nvim depends on it.
   use {
      'nvim-lua/plenary.nvim',
   }
   -- Text editing {{{2
   -- IME {{{3
   -- SKK (Simple Kana to Kanji conversion program) for Vim.
   use {
      'vim-skk/eskk.vim',
      config = function()
         local my_env = require('vimrc.my_env')

         vim.g['eskk#dictionary'] = {
            path = my_env.skk_dir .. '/jisyo',
            sorted = false,
            encoding = 'utf-8',
         }

         vim.g['eskk#large_dictionary'] = {
            path = my_env.skk_dir .. '/jisyo.L',
            sorted = true,
            encoding = 'euc-jp',
         }

         vim.g['eskk#backup_dictionary'] = vim.g['eskk#dictionary'].path .. '.bak'

         -- NOTE:
         -- Boolean values are not accepted because eskk#utils#set_default() checks types.
         vim.g['eskk#enable_completion'] = 0
         vim.g['eskk#egg_like_newline'] = 1

         -- Change default markers because they are EAW (East Asian Width) characters.
         vim.g['eskk#marker_henkan'] = '[!]'
         vim.g['eskk#marker_okuri'] = '-'
         vim.g['eskk#marker_henkan_select'] = '[#]'
         vim.g['eskk#marker_jisyo_touroku'] = '[?]'

         vim.cmd([=[
         function! My_eskk_initialize_pre()
            for [orgtable, mode] in [['rom_to_hira', 'hira'], ['rom_to_kata', 'kata']]
               let t = eskk#table#new(orgtable . '*', orgtable)
               call t.add_map('z ', '　')
               call t.add_map('0.', '0.')
               call t.add_map('1.', '1.')
               call t.add_map('2.', '2.')
               call t.add_map('3.', '3.')
               call t.add_map('4.', '4.')
               call t.add_map('5.', '5.')
               call t.add_map('6.', '6.')
               call t.add_map('7.', '7.')
               call t.add_map('8.', '8.')
               call t.add_map('9.', '9.')
               call t.add_map(':', ':')
               call t.add_map('z:', '：')
               " Workaround: 'zl' does not work as 'l' key leaves from SKK mode.
               call t.add_map('zL', '→')
               call eskk#register_mode_table(mode, t)
            endfor
         endfunction

         autocmd Vimrc User eskk-initialize-pre call My_eskk_initialize_pre()

         function! My_eskk_initialize_post()
            " I don't use hankata mode for now.
            EskkUnmap -type=mode:hira:toggle-hankata
            EskkUnmap -type=mode:kata:toggle-hankata

            " I don't use abbrev mode for now.
            EskkUnmap -type=mode:hira:to-abbrev
            EskkUnmap -type=mode:kata:to-abbrev

            " I don't use ascii mode for now.
            EskkUnmap -type=mode:hira:to-ascii
            EskkUnmap -type=mode:kata:to-ascii

            " Instead, l key disable SKK input.
            EskkMap -type=disable l

            " I type <C-m> for new line.
            EskkMap -type=kakutei <C-m>

            map!  jk  <Plug>(eskk:disable)<ESC>

            " Custom highlight for henkan markers.
            syntax match skkMarker '\[[!#?]\]'
            hi link skkMarker Special
         endfunction

         autocmd Vimrc User eskk-initialize-post call My_eskk_initialize_post()
         ]=])
      end,
   }
   -- Operators {{{3
   -- Support for user-defined operators.
   use {
      'kana/vim-operator-user',
   }
   -- Extract expression and make assingment statement.
   use {
      'tek/vim-operator-assign',
   }
   -- Replace text without updating registers.
   use {
      'kana/vim-operator-replace',
      opt = true,
      keys = {
         {'n', '<Plug>(operator-replace)'},
         {'o', '<Plug>(operator-replace)'},
         {'x', '<Plug>(operator-replace)'},
      },
      setup = function()
         vim.keymap.set('n', '<C-p>', '<Plug>(operator-replace)')
         vim.keymap.set('o', '<C-p>', '<Plug>(operator-replace)')
         vim.keymap.set('x', '<C-p>', '<Plug>(operator-replace)')
      end,
   }
   -- Super surround.
   use {
      'machakann/vim-sandwich',
      config = function()
         vim.fn['operator#sandwich#set']('add', 'all', 'highlight', 2)
         vim.fn['operator#sandwich#set']('delete', 'all', 'highlight', 0)
         vim.fn['operator#sandwich#set']('replace', 'all', 'highlight', 2)

         do
            local rs = vim.fn['sandwich#get_recipes']()

            rs[#rs+1] = {
               buns = {'「', '」'},
               input = {'j[', 'j]'},
            }
            rs[#rs+1] = {
               buns = {'『', '』'},
               input = {'j{', 'j}'},
            }
            rs[#rs+1] = {
               buns = {'【', '】'},
               input = {'j(', 'j)'},
            }

            vim.g['sandwich#recipes'] = rs
         end
      end,
   }
   -- Non-operators {{{3
   -- Comment out.
   use {
      'numToStr/Comment.nvim',
      opt = true,
      keys = {
         {'n', 'm//'},
         {'n', 'm??'},
         {'n', 'm/'}, {'x', 'm/'},
         {'n', 'm?'}, {'x', 'm?'},
         {'n', 'm/O'},
         {'n', 'm/o'},
         {'n', 'm/A'},
      },
      config = function()
         require('Comment').setup {
            toggler = {
               line = 'm//',
               block = 'm??',
            },
            opleader = {
               line = 'm/',
               block = 'm?',
            },
            extra = {
               above = 'm/O',
               below = 'm/o',
               eol = 'm/A',
            },
         }
      end,
   }
   -- Align text.
   use {
      'junegunn/vim-easy-align',
      opt = true,
      cmd = {'EasyAlign'},
      keys = {
         {'n', '<Plug>(EasyAlign)'},
         {'x', '<Plug>(EasyAlign)'},
      },
      setup = function()
         vim.keymap.set('n', '=', '<Plug>(EasyAlign)')
         vim.keymap.set('x', '=', '<Plug>(EasyAlign)')
      end,
   }
   -- Text objects {{{2
   -- Support for user-defined text objects.
   use {
      'kana/vim-textobj-user',
   }
   -- Text object for blockwise.
   use {
      'osyo-manga/vim-textobj-blockwise',
   }
   -- Text object for comment.
   use {
      'thinca/vim-textobj-comment',
   }
   -- Text object for indent.
   use {
      'kana/vim-textobj-indent',
   }
   -- Text object for line.
   use {
      'kana/vim-textobj-line',
   }
   -- Text object for parameter.
   use {
      'sgur/vim-textobj-parameter',
   }
   -- Text object for space.
   use {
      'saihoooooooo/vim-textobj-space',
      opt = true,
      keys = {
         {'o', 'a<Space>'}, {'x', 'a<Space>'},
         {'o', 'i<Space>'}, {'x', 'i<Space>'},
      },
      setup = function()
         vim.g.textobj_space_no_default_key_mappings = true
      end,
      config = function()
         vim.keymap.set('o', 'a<Space>', '<Plug>(textobj-space-a)')
         vim.keymap.set('x', 'a<Space>', '<Plug>(textobj-space-a)')
         vim.keymap.set('o', 'i<Space>', '<Plug>(textobj-space-i)')
         vim.keymap.set('x', 'i<Space>', '<Plug>(textobj-space-i)')
      end,
   }
   -- Text object for syntax.
   use {
      'kana/vim-textobj-syntax',
   }
   -- Text object for URL.
   use {
      'mattn/vim-textobj-url',
   }
   -- Text object for words in words.
   use {
      'h1mesuke/textobj-wiw',
      opt = true,
      keys = {
         {'n', '<C-w>'}, {'o', '<C-w>'}, {'x', '<C-w>'},
         {'n', 'g<C-w>'}, {'o', 'g<C-w>'}, {'x', 'g<C-w>'},
         {'n', '<C-e>'}, {'o', '<C-e>'}, {'x', '<C-e>'},
         {'n', 'g<C-e>'}, {'o', 'g<C-e>'}, {'x', 'g<C-e>'},
         {'o', 'a<C-w>'}, {'x', 'a<C-w>'},
         {'o', 'i<C-w>'}, {'x', 'i<C-w>'},
      },
      setup = function()
         vim.g.textobj_wiw_no_default_key_mappings = true
      end,
      config = function()
         vim.keymap.set('n', '<C-w>', '<Plug>(textobj-wiw-n)')
         vim.keymap.set('o', '<C-w>', '<Plug>(textobj-wiw-n)')
         vim.keymap.set('x', '<C-w>', '<Plug>(textobj-wiw-n)')
         vim.keymap.set('n', 'g<C-w>', '<Plug>(textobj-wiw-p)')
         vim.keymap.set('o', 'g<C-w>', '<Plug>(textobj-wiw-p)')
         vim.keymap.set('x', 'g<C-w>', '<Plug>(textobj-wiw-p)')
         vim.keymap.set('n', '<C-e>', '<Plug>(textobj-wiw-N)')
         vim.keymap.set('o', '<C-e>', '<Plug>(textobj-wiw-N)')
         vim.keymap.set('x', '<C-e>', '<Plug>(textobj-wiw-N)')
         vim.keymap.set('n', 'g<C-e>', '<Plug>(textobj-wiw-P)')
         vim.keymap.set('o', 'g<C-e>', '<Plug>(textobj-wiw-P)')
         vim.keymap.set('x', 'g<C-e>', '<Plug>(textobj-wiw-P)')

         vim.keymap.set('o', 'a<C-w>', '<Plug>(textobj-wiw-a)')
         vim.keymap.set('x', 'a<C-w>', '<Plug>(textobj-wiw-a)')
         vim.keymap.set('o', 'i<C-w>', '<Plug>(textobj-wiw-i)')
         vim.keymap.set('x', 'i<C-w>', '<Plug>(textobj-wiw-i)')
      end,
   }
   -- Search {{{2
   -- Extend * and #.
   use {
      'haya14busa/vim-asterisk',
      opt = true,
      keys = {
         {'n', '<Plug>(asterisk-z*)'}, {'x', '<Plug>(asterisk-z*)'},
         {'n', '<Plug>(asterisk-gz*)'}, {'x', '<Plug>(asterisk-gz*)'},
      },
      setup = function()
         vim.keymap.set({'n', 'x'}, '*', '<Plug>(asterisk-z*)')
         vim.keymap.set({'n', 'x'}, 'g*', '<Plug>(asterisk-gz*)')
      end,
   }
   -- NOTE: it is a fork version of jremmen/vim-ripgrep
   -- Integration with ripgrep, fast alternative of grep command.
   use {
      'nsfisis/vim-ripgrep',
      opt = true,
      cmd = {'Rg', 'RG'},
      config = function()
         -- Workaround: do not open quickfix window.
         -- exe g:rg_window_location 'copen'
         vim.g.rg_window_location = 'silent! echo'
         vim.g.rg_jump_to_first = true

         vim.api.nvim_create_user_command(
            'RG',
            'Rg<bang> <args>',
            {
               bang = true,
               bar = true,
               nargs = '*',
               complete = 'file',
            }
         )
      end,
   }
   -- Files {{{2
   -- Switch to related files.
   use {
      'kana/vim-altr',
      config = function()
         -- C/C++
         vim.fn['altr#define']('%.c', '%.cpp', '%.cc', '%.h', '%.hh', '%.hpp')
         -- Vim
         vim.fn['altr#define']('autoload/%.vim', 'doc/%.txt', 'plugin/%.vim')

         -- Go to File Alternative
         vim.keymap.set('n', 'gfa', '<Plug>(altr-forward)')
      end,
   }
   -- Full-featured filer.
   use {
      'lambdalisue/fern.vim',
      opt = true,
      cmd = {'Fern'},
      config = function()
         local vimrc = require('vimrc')

         vimrc.autocmd('FileType', {
            pattern = {'fern'},
            callback = function()
               vim.keymap.del('n', 't', { buffer = true })
            end,
         })
      end,
   }
   -- Fern plugin: hijack Netrw.
   use {
      'lambdalisue/fern-hijack.vim',
   }
   -- Appearance {{{2
   -- Show highlight.
   use {
      'cocopon/colorswatch.vim',
      opt = true,
      cmd = {'ColorSwatchGenerate'},
   }
   -- Makes folding text cool.
   use {
      'LeafCage/foldCC.vim',
      config = function()
         vim.o.foldtext = 'FoldCCtext()'
         vim.g.foldCCtext_head = 'repeat(">", v:foldlevel) . " "'
      end,
   }
   -- Show indentation guide.
   use {
      'lukas-reineke/indent-blankline.nvim',
      config = function()
         require("indent_blankline").setup {
            char_blankline = ' ',
            show_first_indent_level = false,
         }
      end,
   }
   -- Highlight matched parentheses.
   use {
      'itchyny/vim-parenmatch',
   }
   -- Tree-sitter integration.
   use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
         require('nvim-treesitter.configs').setup {
            ensure_installed = 'all',
            sync_install = false,
            highlight = {
               enable = true,
               additional_vim_regex_highlighting = false,
            },
            --[[
            incremental_selection = {
               enable = true,
               keymaps = {
                  init_selection = 'TODO',
                  node_incremental = 'TODO',
                  scope_incremental = 'TODO',
                  node_decremental = 'TODO',
               },
            },
            --]]
            indent = {
               enable = false,
            },
            yati = {
               enable = true,
            },
         }
      end,
   }
   -- Tree-sitter debugging.
   use {
      'nvim-treesitter/playground',
   }
   -- Highlight specified words.
   use {
      't9md/vim-quickhl',
      config = function()
         -- TODO: CUI
         vim.g.quickhl_manual_colors = {
            'guifg=#101020 guibg=#8080c0 gui=bold',
            'guifg=#101020 guibg=#80c080 gui=bold',
            'guifg=#101020 guibg=#c08080 gui=bold',
            'guifg=#101020 guibg=#80c0c0 gui=bold',
            'guifg=#101020 guibg=#c0c080 gui=bold',
            'guifg=#101020 guibg=#a0a0ff gui=bold',
            'guifg=#101020 guibg=#a0ffa0 gui=bold',
            'guifg=#101020 guibg=#ffa0a0 gui=bold',
            'guifg=#101020 guibg=#a0ffff gui=bold',
            'guifg=#101020 guibg=#ffffa0 gui=bold',
         }

         vim.keymap.set('n', '"', '<Plug>(quickhl-manual-this)')
         vim.keymap.set('x', '"', '<Plug>(quickhl-manual-this)')
         vim.keymap.set('n', '<C-c>', ':<C-u>nohlsearch <Bar> QuickhlManualReset<CR>', { silent=true })
      end,
   }
   -- Yet another tree-sitter indentation.
   -- TODO: uninstall it once the official nvim-treesitter provides sane indentation.
   use {
      'yioneko/nvim-yati',
   }
   -- Filetypes {{{2
   -- Faster replacement for bundled filetype.vim
   use {
      'nathom/filetype.nvim',
      config = function()
         require('filetype').setup({
            overrides = {
               -- My settings here
            },
         })
      end,
   }
   -- C/C++
   use {
      'rhysd/vim-clang-format',
      config = function()
         local vimrc = require('vimrc')

         vim.g['clang_format#auto_format'] = true

         vimrc.autocmd('FileType', {
            pattern = {'javascript', 'typescript'},
            command = 'ClangFormatAutoDisable',
         })
      end,
   }
   -- HTML/CSS
   use {
      'mattn/emmet-vim',
      opt = true,
      cmd = {'EmmetInstall'},
      setup = function()
         local vimrc = require('vimrc')

         vim.g.user_emmet_install_global = false
         vimrc.autocmd('FileType', {
            pattern = {'html', 'css'},
            command = 'EmmetInstall',
         })
      end,
   }
   -- Rust
   use {
      'rust-lang/rust.vim',
      config = function()
         vim.g.rustfmt_autosave = true
      end,
   }
   -- QoL {{{2
   -- Capture the output of a command.
   use {
      'tyru/capture.vim',
      opt = true,
      cmd = {'Capture'},
   }
   -- Write git commit message.
   use {
      'rhysd/committia.vim',
      config = function()
         vim.g.committia_hooks = {
            edit_open = function(_info)
               vim.wo.spell = true
            end,
         }
      end,
   }
   -- Neovim clone of EasyMotion
   use {
      'phaazon/hop.nvim',
      branch = 'v2', -- Hop.nvim's README recommends this.
      opt = true,
      keys = {
         {'n', '<Plug>(hop-f)'}, {'o', '<Plug>(hop-f)'},
         {'x', '<Plug>(hop-f)'}, {'n', '<Plug>(hop-F)'},
         {'o', '<Plug>(hop-F)'}, {'x', '<Plug>(hop-F)'},
         {'o', '<Plug>(hop-t)'}, {'x', '<Plug>(hop-t)'},
         {'o', '<Plug>(hop-T)'}, {'x', '<Plug>(hop-T)'},
         {'n', '<Plug>(hop-s2)'}, {'o', '<Plug>(hop-s2)'}, {'x', '<Plug>(hop-s2)'},
         {'n', '<Plug>(hop-n)'}, {'o', '<Plug>(hop-n)'}, {'x', '<Plug>(hop-n)'},
         {'n', '<Plug>(hop-N)'}, {'o', '<Plug>(hop-N)'}, {'x', '<Plug>(hop-N)'},
         {'n', '<Plug>(hop-j)'}, {'o', '<Plug>(hop-j)'}, {'x', '<Plug>(hop-j)'},
         {'n', '<Plug>(hop-k)'}, {'o', '<Plug>(hop-k)'}, {'x', '<Plug>(hop-k)'},
      },
      config = function()
         require('hop').setup {
            keys = 'asdfghweryuiocvbnmjkl;',
         }

         -- Emulate `g:EasyMotion_startofline = 0` in hop.nvim.
         local function hop_jk(opts)
            local hop = require('hop')
            local jump_target = require('hop.jump_target')

            local column = vim.fn.col('.')
            local match
            if column == 1 then
               match = function(_)
                  return 0, 1, false
               end
            else
               local pat = vim.regex('\\%' .. column .. 'c')
               match = function(s)
                  return pat:match_str(s)
               end
            end
            setmetatable(opts, { __index = hop.opts })
            hop.hint_with(
               jump_target.jump_targets_by_scanning_lines({
                  oneshot = true,
                  match = match,
               }),
               opts
            )
         end

         local hop = require('hop')
         local HintDirection = require('hop.hint').HintDirection
         local AFTER_CURSOR = HintDirection.AFTER_CURSOR
         local BEFORE_CURSOR = HintDirection.BEFORE_CURSOR

         vim.keymap.set('', '<Plug>(hop-f)', function() hop.hint_char1({ direction = AFTER_CURSOR, current_line_only = true }) end, { silent = true })
         vim.keymap.set('', '<Plug>(hop-F)', function() hop.hint_char1({ direction = BEFORE_CURSOR, current_line_only = true }) end, { silent = true })
         vim.keymap.set('', '<Plug>(hop-t)', function() hop.hint_char1({ direction = AFTER_CURSOR, current_line_only = true, hint_offset = -1 }) end, { silent = true })
         vim.keymap.set('', '<Plug>(hop-T)', function() hop.hint_char1({ direction = BEFORE_CURSOR, current_line_only = true, hint_offset = 1 }) end, { silent = true })

         vim.keymap.set('', '<Plug>(hop-s2)', function() hop.hint_char2() end, { silent = true })
         vim.keymap.set('', '<Plug>(hop-n)',  function() hop.hint_patterns({ direction = AFTER_CURSOR }, vim.fn.getreg('/')) end, { silent = true })
         vim.keymap.set('', '<Plug>(hop-N)',  function() hop.hint_patterns({ direction = BEFORE_CURSOR }, vim.fn.getreg('/')) end, { silent = true })
         vim.keymap.set('', '<Plug>(hop-j)',  function() hop_jk({ direction = AFTER_CURSOR }) end, { silent = true })
         vim.keymap.set('', '<Plug>(hop-k)',  function() hop_jk({ direction = BEFORE_CURSOR }) end, { silent = true })
      end,
      setup = function()
         vim.keymap.set('n', 'f', '<Plug>(hop-f)')
         vim.keymap.set('o', 'f', '<Plug>(hop-f)')
         vim.keymap.set('x', 'f', '<Plug>(hop-f)')
         vim.keymap.set('n', 'F', '<Plug>(hop-F)')
         vim.keymap.set('o', 'F', '<Plug>(hop-F)')
         vim.keymap.set('x', 'F', '<Plug>(hop-F)')
         vim.keymap.set('o', 't', '<Plug>(hop-t)')
         vim.keymap.set('x', 't', '<Plug>(hop-t)')
         vim.keymap.set('o', 'T', '<Plug>(hop-T)')
         vim.keymap.set('x', 'T', '<Plug>(hop-T)')

         -- Note: Don't use the following key sequences! They are used by 'vim-sandwich'.
         --  * sa
         --  * sd
         --  * sr
         vim.keymap.set('n', 'ss', '<Plug>(hop-s2)')
         vim.keymap.set('o', 'ss', '<Plug>(hop-s2)')
         vim.keymap.set('x', 'ss', '<Plug>(hop-s2)')
         vim.keymap.set('n', 'sn', '<Plug>(hop-n)')
         vim.keymap.set('o', 'sn', '<Plug>(hop-n)')
         vim.keymap.set('x', 'sn', '<Plug>(hop-n)')
         vim.keymap.set('n', 'sN', '<Plug>(hop-N)')
         vim.keymap.set('o', 'sN', '<Plug>(hop-N)')
         vim.keymap.set('x', 'sN', '<Plug>(hop-N)')
         vim.keymap.set('n', 'sj', '<Plug>(hop-j)')
         vim.keymap.set('o', 'sj', '<Plug>(hop-j)')
         vim.keymap.set('x', 'sj', '<Plug>(hop-j)')
         vim.keymap.set('n', 'sk', '<Plug>(hop-k)')
         vim.keymap.set('o', 'sk', '<Plug>(hop-k)')
         vim.keymap.set('x', 'sk', '<Plug>(hop-k)')
      end,
   }
   -- Integration with EditorConfig (https://editorconfig.org)
   use {
      'editorconfig/editorconfig-vim',
   }
   -- Extend J.
   use {
      'osyo-manga/vim-jplus',
      config = function()
         vim.g['jplus#input_config'] = {
            __DEFAULT__ = { delimiter_format = ' %d ' },
            __EMPTY__ = { delimiter_format = '' },
            [' '] = { delimiter_format = ' ' },
            [','] = { delimiter_format = '%d ' },
            [':'] = { delimiter_format = '%d ' },
            [';'] = { delimiter_format = '%d ' },
            l = { delimiter_format = '' },
            L = { delimiter_format = '' },
         }

         vim.keymap.set('n', 'J', '<Plug>(jplus-getchar)')
         vim.keymap.set('x', 'J', '<Plug>(jplus-getchar)')
         vim.keymap.set('n', 'gJ', '<Plug>(jplus-input)')
         vim.keymap.set('x', 'gJ', '<Plug>(jplus-input)')
      end,
   }
   -- Improve behaviors of I, A and gI in Blockwise-Visual mode.
   use {
      'kana/vim-niceblock',
      config = function()
         vim.keymap.set('x', 'I', '<Plug>(niceblock-I)')
         vim.keymap.set('x', 'gI', '<Plug>(niceblock-gI)')
         vim.keymap.set('x', 'A', '<Plug>(niceblock-A)')
      end,
   }
   -- Edit QuickFix freely.
   use {
      'itchyny/vim-qfedit',
   }
   -- Edit QuickFix and reflect to original buffers.
   use {
      'thinca/vim-qfreplace',
      opt = true,
      cmd = {'Qfreplace'},
      config = function()
         vim.keymap.set('n', 'br', ':<C-u>Qfreplace SmartOpen<CR>', { silent=true })
      end,
   }
   -- Run anything.
   use {
      'thinca/vim-quickrun',
      config = function()
         vim.g.quickrun_config = {
            cpp = {
               cmdopt = '--std=c++17 -Wall -Wextra',
            },
            d = {
               exec = 'dub run',
            },
            haskell = {
               exec = {'stack build', 'stack exec %{matchstr(globpath(".,..,../..,../../..", "*.cabal"), "\\w\\+\\ze\\.cabal")}'},
            },
            python = {
               command = 'python3',
            },
         }

         vim.keymap.set('n', 'BB', '<Plug>(quickrun)')
         vim.keymap.set('x', 'BB', '<Plug>(quickrun)')
      end,
   }
   -- Extend dot-repeat.
   use {
      'tpope/vim-repeat',
      config = function()
         vim.keymap.set('n', 'U', '<Plug>(RepeatRedo)')
         -- Autoload vim-repeat immediately in order to make <Plug>(RepeatRedo) available.
         -- repeat#setreg() does nothing here.
         vim.fn['repeat#setreg']('', '')
      end,
   }
   -- Introduce user-defined mode.
   use {
      'kana/vim-submode',
      config = function()
         -- Global settings {{{3
         vim.g.submode_always_show_submode = true
         vim.g.submode_keyseqs_to_leave = {'<C-c>', '<ESC>'}
         vim.g.submode_keep_leaving_key = true

         -- yankround {{{3
         vim.fn['submode#enter_with']('YankRound', 'nv', 'rs', 'gp', '<Plug>(yankround-p)')
         vim.fn['submode#enter_with']('YankRound', 'nv', 'rs', 'gP', '<Plug>(yankround-P)')
         vim.fn['submode#map']('YankRound', 'nv', 'rs', 'p', '<Plug>(yankround-prev)')
         vim.fn['submode#map']('YankRound', 'nv', 'rs', 'P', '<Plug>(yankround-next)')

         -- swap {{{3
         vim.fn['submode#enter_with']('Swap', 'n', 'rs', 'g>', '<Plug>(swap-next)')
         vim.fn['submode#map']('Swap', 'n', 'rs', '<', '<Plug>(swap-prev)')
         vim.fn['submode#enter_with']('Swap', 'n', 'rs', 'g<', '<Plug>(swap-prev)')
         vim.fn['submode#map']('Swap', 'n', 'rs', '>', '<Plug>(swap-next)')

         -- TODO
         if packer_plugins['vim-swap'] and not packer_plugins['vim-swap'].loaded then
            vim.cmd.packadd('vim-swap')
         end

         -- Resizing a window (height) {{{3
         vim.fn['submode#enter_with']('WinResizeH', 'n', 's', 'trh')
         vim.fn['submode#enter_with']('WinResizeH', 'n', 's', 'trh')
         vim.fn['submode#map']('WinResizeH', 'n', 's', '+', '<C-w>+')
         vim.fn['submode#map']('WinResizeH', 'n', 's', '-', '<C-w>-')

         -- Resizing a window (width) {{{3
         vim.fn['submode#enter_with']('WinResizeW', 'n', 's', 'trw')
         vim.fn['submode#enter_with']('WinResizeW', 'n', 's', 'trw')
         vim.fn['submode#map']('WinResizeW', 'n', 's', '+', '<C-w>>')
         vim.fn['submode#map']('WinResizeW', 'n', 's', '-', '<C-w><Lt>')

         -- Super undo/redo {{{3
         vim.fn['submode#enter_with']('Undo/Redo', 'n', 's', 'gu', 'g-')
         vim.fn['submode#map']('Undo/Redo', 'n', 's', 'u', 'g-')
         vim.fn['submode#enter_with']('Undo/Redo', 'n', 's', 'gU', 'g+')
         vim.fn['submode#map']('Undo/Redo', 'n', 's', 'U', 'g+')
         -- }}}
      end,
   }
   -- Swap arguments.
   use {
      'machakann/vim-swap',
      opt = true,
      setup = function()
         vim.g.swap_no_default_key_mappings = true
      end,
   }
   -- Fuzzy finder.
   use {
      'nvim-telescope/telescope.nvim',
   }
   -- Adjust window size.
   use {
      'rhysd/vim-window-adjuster',
      config = function()
         vim.keymap.set('n', 'tRw', '<Cmd>AdjustScreenWidth<CR>')
         vim.keymap.set('n', 'tRh', '<Cmd>AdjustScreenHeight<CR>')
         vim.keymap.set('n', 'tRr', ':<C-u>AdjustScreenWidth <Bar> AdjustScreenHeight<CR>', { silent=true })
      end,
   }
   -- Remember yank history and paste them.
   use {
      'LeafCage/yankround.vim',
      config = function()
         local my_env = require('vimrc.my_env')

         vim.g.yankround_dir = my_env.yankround_dir
         vim.g.yankround_use_region_hl = true
      end,
   }
   -- }}}
end)
-- }}}

return {
   compile = packer.compile,
   sync = packer.sync,
}
