;; extends

;; Highlight inner string and delimiter within delimited symbol like :'foo'.
;; NOTE: delimiters is aliased to ':"' and '"' regardless of the actual
;; delimiter symbols. No need to define rule for all kinds of string
;; delimiters.
(delimited_symbol
  ":\""            @string.special.symbol
  (string_content) @string.special.symbol
  "\""             @string.special.symbol)
