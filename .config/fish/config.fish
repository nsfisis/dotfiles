set -gx LANG 'ja_JP.UTF-8'

set -gx VISUAL vim
set -gx EDITOR vim

set -gx LD_LIBRARY_PATH "$HOME/Downloads/lib:$HOME/lib:$LD_LIBRARY_PATH"

set -gx PATH "/usr/local/bin:$PATH"

set -gx PATH "$HOME/.cargo/bin:$PATH"
set -gx PATH "$HOME/bin:$HOME/.local/bin:$PATH"

set -gx PATH "/usr/local/opt/gettext/bin:$PATH"

# To override system-provided Ruby with brewed Ruby
set -gx PATH "/usr/local/opt/ruby/bin:$PATH"

abbr -a rm rm -i
abbr -a cp cp -i
abbr -a mv mv -i

abbr -a e vim
abbr -a o open
abbr -a g git
abbr -a cat bat
abbr -a find fd
abbr -a grep rg
abbr -a ls exa
abbr -a lsa exa -a
abbr -a lsl exa -l
abbr -a lsal exa -al
abbr -a lsla exa -al

starship init fish | source
