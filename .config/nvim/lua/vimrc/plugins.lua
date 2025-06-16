return {
   -- Libraries {{{1
   {
      'nvim-lua/plenary.nvim',
      lazy = true,
   },
   {
      'vim-denops/denops.vim',
   },
   -- Text editing {{{1
   -- IME {{{2
   -- SKK (Simple Kana to Kanji conversion program) for Vim.
   {
      'vim-skk/skkeleton',
      config = function()
         local vimrc = require('vimrc')
         local my_env = require('vimrc.my_env')

         vimrc.autocmd('User', {
            pattern = 'skkeleton-initialize-pre',
            callback = function()
               vim.fn['skkeleton#config']({
                  -- Change default markers because they are EAW (East Asian Ambiguous Width) characters.
                  markerHenkan = '▿',
                  markerHenkanSelect = '▾',
                  eggLikeNewline = true,
                  userDictionary = my_env.skk_dir .. '/jisyo',
                  globalDictionaries = {my_env.skk_dir .. '/jisyo.L'},
               })
               vim.fn['skkeleton#register_kanatable']('rom', {
                     ['z '] = {'　'},
                     ['0.'] = {'0.'},
                     ['1.'] = {'1.'},
                     ['2.'] = {'2.'},
                     ['3.'] = {'3.'},
                     ['4.'] = {'4.'},
                     ['5.'] = {'5.'},
                     ['6.'] = {'6.'},
                     ['7.'] = {'7.'},
                     ['8.'] = {'8.'},
                     ['9.'] = {'9.'},
                     [':'] = {':'},
                     ['z:'] = {'：'},
                     ['jk'] = 'escape',
               })
            end,
         })

         vimrc.autocmd('User', {
            pattern = 'skkeleton-initialize-post',
            callback = function()
               vim.fn['skkeleton#register_keymap']('input', '<C-q>', nil)
               vim.fn['skkeleton#register_keymap']('input', '<C-m>', 'newline')
               vim.fn['skkeleton#register_keymap']('henkan', '<C-m>', 'newline')
            end,
         })

         vim.cmd([[
         imap <C-j> <Plug>(skkeleton-enable)
         cmap <C-j> <Plug>(skkeleton-enable)
         tmap <C-j> <Plug>(skkeleton-enable)
         ]])
      end,
   },
   -- Operators {{{2
   -- Support for user-defined operators.
   {
      'kana/vim-operator-user',
   },
   -- Extract expression and make assingment statement.
   {
      'tek/vim-operator-assign',
   },
   -- Replace text without updating registers.
   {
      'kana/vim-operator-replace',
      lazy = true,
      keys = {
         {'<C-p>', '<Plug>(operator-replace)', mode = {'n', 'o', 'x'}},
      },
   },
   -- Super surround.
   {
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
   },
   -- Non-operators {{{2
   -- Comment out.
   {
      -- use bundled feature?
      'numToStr/Comment.nvim',
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
   },
   -- Align text.
   {
      'junegunn/vim-easy-align',
      lazy = true,
      cmd = {'EasyAlign'},
      keys = {
         {'=', '<Plug>(EasyAlign)', mode = {'n', 'x'}},
      },
   },
   -- Text objects {{{1
   -- Support for user-defined text objects.
   {
      'kana/vim-textobj-user',
      priority = 100,
   },
   -- Text object for blockwise.
   {
      'osyo-manga/vim-textobj-blockwise',
   },
   -- Text object for comment.
   {
      'thinca/vim-textobj-comment',
   },
   -- Text object for indent.
   {
      'kana/vim-textobj-indent',
   },
   -- Text object for line.
   {
      'kana/vim-textobj-line',
   },
   -- Text object for parameter.
   {
      'sgur/vim-textobj-parameter',
   },
   -- Text object for space.
   {
      'saihoooooooo/vim-textobj-space',
      lazy = true,
      keys = {
         {'a<Space>', '<Plug>(textobj-space-a)', mode = {'o', 'x'}},
         {'i<Space>', '<Plug>(textobj-space-i)', mode = {'o', 'x'}},
      },
      init = function()
         vim.g.textobj_space_no_default_key_mappings = true
      end,
   },
   -- Text object for syntax.
   {
      'kana/vim-textobj-syntax',
   },
   -- Text object for URL.
   {
      'mattn/vim-textobj-url',
   },
   -- Text object for words in words.
   {
      'h1mesuke/textobj-wiw',
      lazy = true,
      keys = {
         {'<C-w>', '<Plug>(textobj-wiw-n)', mode = {'n', 'o', 'x'}},
         {'g<C-w>', '<Plug>(textobj-wiw-p)', mode = {'n', 'o', 'x'}},
         {'<C-e>', '<Plug>(textobj-wiw-N)', mode = {'n', 'o', 'x'}},
         {'g<C-e>', '<Plug>(textobj-wiw-P)', mode = {'n', 'o', 'x'}},
         {'a<C-w>', '<Plug>(textobj-wiw-a)', mode = {'o', 'x'}},
         {'i<C-w>', '<Plug>(textobj-wiw-i)', mode = {'o', 'x'}},
      },
      init = function()
         vim.g.textobj_wiw_no_default_key_mappings = true
      end,
   },
   -- Search {{{1
   -- Extend * and #.
   {
      'haya14busa/vim-asterisk',
      lazy = true,
      keys = {
         {'*', '<Plug>(asterisk-z*)', mode = {'n', 'x'}},
         {'g*', '<Plug>(asterisk-gz*)', mode = {'n', 'x'}},
      },
   },
   -- Files {{{1
   -- Switch to related files.
   {
      'kana/vim-altr',
      config = function()
         -- C/C++
         vim.fn['altr#define']('%.c', '%.cpp', '%.cc', '%.h', '%.hh', '%.hpp')
         -- Vim
         vim.fn['altr#define']('autoload/%.vim', 'doc/%.txt', 'plugin/%.vim')

         -- Go to File Alternative
         vim.keymap.set('n', 'gfa', '<Plug>(altr-forward)')
      end,
   },
   -- Simple filer.
   {
      'justinmk/vim-dirvish',
   },
   -- Appearance {{{1
   -- Colorscheme
   {
      'cocopon/iceberg.vim',
      lazy = false,
      priority = 999,
      config = function()
         vim.cmd('colorscheme iceberg')
      end,
   },
   -- Show highlight.
   {
      'cocopon/colorswatch.vim',
      lazy = true,
      cmd = {'ColorSwatchGenerate'},
   },
   -- Makes folding text cool.
   {
      'LeafCage/foldCC.vim',
      config = function()
         vim.o.foldtext = 'FoldCCtext()'
         vim.g.foldCCtext_head = 'repeat(">", v:foldlevel) . " "'
      end,
   },
   -- Show indentation guide.
   {
      'lukas-reineke/indent-blankline.nvim',
      main = 'ibl',
      config = function()
         require('ibl').setup {
            exclude = {
               filetypes = {
                  'markdown',
               },
            },
            scope = {
               enabled = false,
            },
         }
         local hooks = require('ibl.hooks')
         hooks.register(
            hooks.type.WHITESPACE,
            hooks.builtin.hide_first_space_indent_level
         )
      end,
   },
   -- Highlight matched parentheses.
   {
      'itchyny/vim-parenmatch',
   },
   -- Tree-sitter integration.
   {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdateSync',
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
               enable = true,
            },
         }
      end,
   },
   -- Tree-sitter debugging.
   {
      'nvim-treesitter/playground',
   },
   -- Highlight specified words.
   {
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
   },
   -- Filetypes {{{1
   -- C/C++
   {
      'rhysd/vim-clang-format',
      config = function()
         local vimrc = require('vimrc')

         vim.g['clang_format#auto_format'] = true

         vimrc.autocmd('FileType', {
            pattern = {'javascript', 'typescript'},
            command = 'ClangFormatAutoDisable',
         })
      end,
   },
   -- HTML
   {
      'windwp/nvim-ts-autotag',
      opts = {
         opts = {
            enable_close = true,
            enable_rename = true,
            enable_close_on_slash = true,
         },
      },
   },
   -- Markdown
   {
      'MeanderingProgrammer/render-markdown.nvim',
      ft = {
         'markdown',
      },
      cmd = {
         'RenderMarkdown',
      },
      opts = {
         enabled = false,
         heading = {
            -- Example:
            -- § 1.
            -- § 1.1
            -- § 1.1.1
            -- § 1.2
            -- § 2.
            icons = function(ctx)
               local section = ''
               for l = 1, ctx.level do
                  local section_number = ctx.sections[l]
                  if section_number ~= 0 then
                     section = section .. section_number .. '.'
                  end
               end
               return '§ ' .. section .. ' '
            end,
            position = 'inline',
         },
         code = {
            position = 'right',
            language_icon = false,
            border = 'thick',
         },
         checkbox = {
            unchecked = { icon = '✘ ' },
            checked = { icon = '✔ ' },
            custom = {
               todo = { rendered = '◯ ' },
            },
         },
         pipe_table = {
            cell = 'trimmed',
         },
         callout = {
            note      = { rendered = 'ⓘ Note' },
            tip       = { rendered = 'ⓘ Tip' },
            important = { rendered = 'ⓘ Important' },
            warning   = { rendered = 'ⓘ Warning' },
            caution   = { rendered = 'ⓘ Caution' },
            abstract  = { rendered = 'ⓘ Abstract' },
            summary   = { rendered = 'ⓘ Summary' },
            tldr      = { rendered = 'ⓘ TL;DR' },
            info      = { rendered = 'ⓘ Info' },
            todo      = { rendered = 'ⓘ TODO' },
            hint      = { rendered = 'ⓘ Hint' },
            success   = { rendered = 'ⓘ Success' },
            check     = { rendered = 'ⓘ Check' },
            done      = { rendered = 'ⓘ Done' },
            question  = { rendered = 'ⓘ Question' },
            help      = { rendered = 'ⓘ Help' },
            faq       = { rendered = 'ⓘ FAQ' },
            attention = { rendered = 'ⓘ Attention' },
            failure   = { rendered = 'ⓘ Failure' },
            fail      = { rendered = 'ⓘ Fail' },
            missing   = { rendered = 'ⓘ Missing' },
            danger    = { rendered = 'ⓘ Danger' },
            error     = { rendered = 'ⓘ Error' },
            bug       = { rendered = 'ⓘ Bug' },
            example   = { rendered = 'ⓘ Example' },
            quote     = { rendered = 'ⓘ Quote' },
            cite      = { rendered = 'ⓘ Cite' },
         },
         link = {
            image = '',
            email = '',
            hyperlink = '',
            custom = {
               web           = { icon = '' },
               discord       = { icon = '' },
               github        = { icon = '' },
               gitlab        = { icon = '' },
               google        = { icon = '' },
               neovim        = { icon = '' },
               reddit        = { icon = '' },
               stackoverflow = { icon = '' },
               wikipedia     = { icon = '' },
               youtube       = { icon = '' },
            },
         },
         indent = {
            enabled = true,
            per_level = 1,
            skip_level = 0,
            skip_heading = true,
            icon = '',
         },
         sign = {
            enabled = false,
         },
      },
   },
   -- Rust
   {
      'rust-lang/rust.vim',
      config = function()
         vim.g.rustfmt_autosave = true
      end,
   },
   -- QoL {{{1
   -- Capture the output of a command.
   {
      'tyru/capture.vim',
      lazy = true,
      cmd = {'Capture'},
   },
   -- Write git commit message.
   {
      'rhysd/committia.vim',
      config = function()
         vim.g.committia_hooks = {
            edit_open = function(_info)
               vim.wo.spell = true
            end,
         }
      end,
   },
   -- Neovim clone of EasyMotion
   {
      'smoka7/hop.nvim',
      lazy = true,
      keys = {
         {'f', '<Plug>(hop-f)', mode = {'n', 'o', 'x'}},
         {'F', '<Plug>(hop-F)', mode = {'n', 'o', 'x'}},
         {'t', '<Plug>(hop-t)', mode = {'o', 'x'}},
         {'T', '<Plug>(hop-T)', mode = {'o', 'x'}},
         -- Note: Don't use the following key sequences! They are used by 'vim-sandwich'.
         --  * sa
         --  * sd
         --  * sr
         {'ss', '<Plug>(hop-s2)', mode = {'n', 'o', 'x'}},
         {'sn', '<Plug>(hop-n)', mode = {'n', 'o', 'x'}},
         {'sj', '<Plug>(hop-j)', mode = {'n', 'o', 'x'}},
         {'sk', '<Plug>(hop-k)', mode = {'n', 'o', 'x'}},
      },
      config = function()
         local hop = require('hop')
         hop.setup {
            keys = 'asdfghweryuiocvbnmjkl;',
         }
         local HintDirection = require('hop.hint').HintDirection
         local AFTER_CURSOR = HintDirection.AFTER_CURSOR
         local BEFORE_CURSOR = HintDirection.BEFORE_CURSOR

         vim.keymap.set('', '<Plug>(hop-f)', function() hop.hint_char1({ direction = AFTER_CURSOR,  current_line_only = true }) end, { silent = true })
         vim.keymap.set('', '<Plug>(hop-F)', function() hop.hint_char1({ direction = BEFORE_CURSOR, current_line_only = true }) end, { silent = true })
         vim.keymap.set('', '<Plug>(hop-t)', function() hop.hint_char1({ direction = AFTER_CURSOR,  current_line_only = true, hint_offset = -1 }) end, { silent = true })
         vim.keymap.set('', '<Plug>(hop-T)', function() hop.hint_char1({ direction = BEFORE_CURSOR, current_line_only = true, hint_offset =  1 }) end, { silent = true })

         vim.keymap.set('', '<Plug>(hop-s2)', function() hop.hint_char2() end, { silent = true })

         vim.keymap.set('', '<Plug>(hop-n)',  function() hop.hint_patterns({}, vim.fn.getreg('/')) end, { silent = true })

         vim.keymap.set('', '<Plug>(hop-j)',  function() hop.hint_vertical({ direction = AFTER_CURSOR  }) end, { silent = true })
         vim.keymap.set('', '<Plug>(hop-k)',  function() hop.hint_vertical({ direction = BEFORE_CURSOR }) end, { silent = true })
      end,
   },
   -- Extend J.
   {
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
   },
   -- Improve behaviors of I, A and gI in Blockwise-Visual mode.
   {
      'kana/vim-niceblock',
      config = function()
         vim.keymap.set('x', 'I', '<Plug>(niceblock-I)')
         vim.keymap.set('x', 'gI', '<Plug>(niceblock-gI)')
         vim.keymap.set('x', 'A', '<Plug>(niceblock-A)')
      end,
   },
   -- Edit QuickFix freely.
   {
      'itchyny/vim-qfedit',
   },
   -- Edit QuickFix and reflect to original buffers.
   {
      'thinca/vim-qfreplace',
      lazy = true,
      cmd = {'Qfreplace'},
      config = function()
         vim.keymap.set('n', 'br', ':<C-u>Qfreplace SmartOpen<CR>', { silent=true })
      end,
   },
   -- Run anything.
   {
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
   },
   -- Extend dot-repeat.
   {
      'tpope/vim-repeat',
      config = function()
         vim.keymap.set('n', 'U', '<Plug>(RepeatRedo)')
         -- Autoload vim-repeat immediately in order to make <Plug>(RepeatRedo) available.
         -- repeat#setreg() does nothing here.
         vim.fn['repeat#setreg']('', '')
      end,
   },
   -- Introduce user-defined mode.
   {
      'kana/vim-submode',
      config = function()
         -- Global settings {{{2
         vim.g.submode_always_show_submode = true
         vim.g.submode_keyseqs_to_leave = {'<C-c>', '<ESC>'}
         vim.g.submode_keep_leaving_key = true

         -- yankround {{{2
         vim.fn['submode#enter_with']('YankRound', 'nv', 'rs', 'gp', '<Plug>(yankround-p)')
         vim.fn['submode#enter_with']('YankRound', 'nv', 'rs', 'gP', '<Plug>(yankround-P)')
         vim.fn['submode#map']('YankRound', 'nv', 'rs', 'p', '<Plug>(yankround-prev)')
         vim.fn['submode#map']('YankRound', 'nv', 'rs', 'P', '<Plug>(yankround-next)')

         -- swap {{{2
         vim.fn['submode#enter_with']('Swap', 'n', 'rs', 'g>', '<Plug>(swap-next)')
         vim.fn['submode#map']('Swap', 'n', 'rs', '<', '<Plug>(swap-prev)')
         vim.fn['submode#enter_with']('Swap', 'n', 'rs', 'g<', '<Plug>(swap-prev)')
         vim.fn['submode#map']('Swap', 'n', 'rs', '>', '<Plug>(swap-next)')

         -- Resizing a window (height) {{{2
         vim.fn['submode#enter_with']('WinResizeH', 'n', 's', 'trh')
         vim.fn['submode#enter_with']('WinResizeH', 'n', 's', 'trh')
         vim.fn['submode#map']('WinResizeH', 'n', 's', '+', '<C-w>+')
         vim.fn['submode#map']('WinResizeH', 'n', 's', '-', '<C-w>-')

         -- Resizing a window (width) {{{2
         vim.fn['submode#enter_with']('WinResizeW', 'n', 's', 'trw')
         vim.fn['submode#enter_with']('WinResizeW', 'n', 's', 'trw')
         vim.fn['submode#map']('WinResizeW', 'n', 's', '+', '<C-w>>')
         vim.fn['submode#map']('WinResizeW', 'n', 's', '-', '<C-w><Lt>')

         -- Super undo/redo {{{2
         vim.fn['submode#enter_with']('Undo/Redo', 'n', 's', 'gu', 'g-')
         vim.fn['submode#map']('Undo/Redo', 'n', 's', 'u', 'g-')
         vim.fn['submode#enter_with']('Undo/Redo', 'n', 's', 'gU', 'g+')
         vim.fn['submode#map']('Undo/Redo', 'n', 's', 'U', 'g+')
         -- }}}
      end,
   },
   -- Swap arguments.
   {
      'machakann/vim-swap',
      init = function()
         vim.g.swap_no_default_key_mappings = true
      end,
   },
   -- Fuzzy finder.
   {
      'nvim-telescope/telescope.nvim',
      config = function()
         require('telescope').setup {
         }
         require('telescope').load_extension('fzf')
      end,
   },
   -- Native fzf sorter for Telescope.
   {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      lazy = true,
   },
   -- Adjust window size.
   {
      'rhysd/vim-window-adjuster',
      config = function()
         vim.keymap.set('n', 'tRw', '<Cmd>AdjustScreenWidth<CR>')
         vim.keymap.set('n', 'tRh', '<Cmd>AdjustScreenHeight<CR>')
         vim.keymap.set('n', 'tRr', ':<C-u>AdjustScreenWidth <Bar> AdjustScreenHeight<CR>', { silent=true })
      end,
   },
   -- Remember yank history and paste them.
   {
      'LeafCage/yankround.vim',
      config = function()
         local my_env = require('vimrc.my_env')

         vim.g.yankround_dir = my_env.yankround_dir
         vim.g.yankround_use_region_hl = true
      end,
   },
   -- LSP {{{1
   -- Collection of common LSP configurations.
   {
      'neovim/nvim-lspconfig',
      config = function()
         local lspconfig = require('lspconfig')

         -- TODO
         -- Enable denols xor ts_ls.
         local is_deno_repo
         if vim.fn.executable('deno') == 1 then
            is_deno_repo = vim.fs.root(0, {"deno.json", "deno.jsonc"}) ~= nil
         else
            is_deno_repo = false
         end

         if vim.fn.executable('typescript-language-server') == 1 then
            if not is_deno_repo then
               lspconfig.ts_ls.setup({})
            end
         end
         if vim.fn.executable('deno') == 1 then
            if is_deno_repo then
               lspconfig.denols.setup({})
            end
         end
         if vim.fn.executable('gopls') == 1 then
            lspconfig.gopls.setup({})
         end
         if vim.fn.executable('phpactor') == 1 then
            lspconfig.phpactor.setup({})
         end
         if vim.fn.executable('zls') == 1 then
            lspconfig.zls.setup({})
         end
         if vim.fn.executable('efm-langserver') == 1 then
            local biome_conf = {
               rootMarkers = {"biome.json"},
               formatCommand = 'node_modules/.bin/biome format --stdin-file-path "${INPUT}"',
               formatStdin = true,
            }
            lspconfig.efm.setup({
               init_options = { documentFormatting = true },
               settings = {
                  rootMarkers = {".git/"},
                  languages = {
                     json = {
                        {
                           formatCommand = "reparojson -q",
                           formatStdin = true,
                        },
                     },
                     javascript = {biome_conf},
                     javascriptreact = {biome_conf},
                     ["javascript.jsx"] = {biome_conf},
                     typescript = {biome_conf},
                     typescriptreact = {biome_conf},
                     ["typescript.jsx"] = {biome_conf},
                  },
               }
            })
         end

         vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(e)
               vim.bo[e.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

               local opts = { buffer = e.buf }
               vim.keymap.set('n', '<space>f', function()
                  vim.lsp.buf.format({
                     async = true,
                     filter = function(client) return client.name ~= "ts_ls" end,
                  })
               end, opts)

               vim.api.nvim_create_autocmd('BufWritePre', {
                  buffer = e.buf,
                  callback = function()
                     vim.lsp.buf.format({
                        async = false,
                        timeout_ms = 5000,
                        filter = function(client) return client.name ~= "ts_ls" end,
                     })
                  end
               })
            end,
         })
      end,
   },
   -- AI {{{1
   {
      "coder/claudecode.nvim",
      config = true,
      keys = {
         { "<leader>a", nil, desc = "AI/Claude Code" },
         { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
         { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
         { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
         { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
         { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
         {
            "<leader>as",
            "<cmd>ClaudeCodeTreeAdd<cr>",
            desc = "Add file",
            ft = { "dirvish" },
         },
      },
   },
   -- }}}
}
