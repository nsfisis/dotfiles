scriptencoding utf-8


if exists("b:current_syntax_my_vim")
    finish
endif

if b:current_syntax !=# 'vim'
    finish
endif



" Tags
syn match vimrcDocTagFollowingName /@\(param\|var\|const\|field\)/ contained skipwhite nextgroup=vimrcDocName,vimrcDocName2
syn match vimrcDocTagFollowingType /@\(return\|class\|ctor\|method\|type\)/ contained skipwhite nextgroup=vimrcDocType
syn match vimrcDocName /\w\+/ contained skipwhite nextgroup=vimrcDocType
syn match vimrcDocName2 /\[\w\+\]/hs=s+1,he=e-1 contained skipwhite nextgroup=vimrcDocType
syn match vimrcDocType /(\w\+)/hs=s+1,he=e-1 contained skipwhite nextgroup=vimrcDocType

syn cluster vimCommentGroup add=vimrcDocTagFollowingName,vimrcDocTagFollowingType

hi def link vimrcDocTagFollowingName Statement
hi def link vimrcDocTagFollowingType Statement
hi def link vimrcDocName             Identifier
hi def link vimrcDocName2            Identifier
hi def link vimrcDocType             Type


let b:current_syntax_my_vim = 1
