scriptencoding utf-8

if exists("b:current_syntax_my_json")
    finish
endif

if b:current_syntax !=# 'json'
    finish
endif


" $VIMRUNTIME/syntax/json.vim
" Language:	JSON
" Maintainer:	Eli Parra <eli@elzr.com>
" Last Change:	2014 Aug 23
" Version:      0.12
" Overwrite syntax by non-conceal version even if 'conceal' is enabled.
syn region  jsonString oneline matchgroup=jsonQuote start=/"/  skip=/\\\\\|\\"/  end=/"/ contains=jsonEscape contained
syn region  jsonKeyword matchgroup=jsonQuote start=/"/  end=/"\ze[[:blank:]\r\n]*\:/ contained



let b:current_syntax_my_json = 1
