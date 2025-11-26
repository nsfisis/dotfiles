function fish_greeting; end

# Abbreviations
abbr -a direnvnix 'nix flake new -t github:nix-community/nix-direnv'
abbr -a g 'git'
abbr -a gs 'git s'
abbr -a ll 'ls -l'
abbr -a lla 'ls -la'
abbr -a lsa 'ls -a'
abbr -a lsal 'ls -la'
abbr -a lsl 'ls -l'

# Aliases
alias cat 'bat'
alias cp 'cp -i'
alias e 'nvim'
alias grep 'rg'
alias mkdir 'mkdir -p'
alias mv 'mv -i'
alias rm 'gomi'
alias ssh 'TERM=xterm-256color command ssh'
alias top 'htop'
alias tree 'tree -N --gitignore'
alias view 'nvim -R'
alias vim 'nvim'
alias vimdiff 'nvim -d'

if test (uname) = "Darwin"
    alias tac 'tail -r'
end

# Bindings
function __cd_parent_dir
    if [ -n (commandline) ]
        return
    end
    cd ..
    commandline -f repaint
end
bind \cj __cd_parent_dir

function __cd_prev_dir
    if [ -n (commandline) ]
        return
    end
    cd -
    commandline -f repaint
end
bind \co __cd_prev_dir

function __cd_project_root_dir
    if [ -n (commandline) ]
        return
    end
    if [ (git rev-parse --is-inside-work-tree 2>/dev/null) = 'true' ]
        cd (git rev-parse --show-toplevel)
        commandline -f repaint
    end
end
bind \cg __cd_project_root_dir

bind \cz fg

bind ctrl-x,ctrl-e edit_command_buffer

function 256colors
    for code in (seq 0 255)
        printf '\e[38;05;%dm%3d: Test\n' $code $code
    end
end

function mkcd
    mkdir -p $argv[1]
    cd $argv[1]
end

function pwgen --wraps pwgen
    if [ (count $argv) -gt 0 ]
        command pwgen $argv
    else
        command pwgen -N 1 64
        command pwgen -N 1 48
        command pwgen -N 1 32
        command pwgen -N 1 24
        command pwgen -N 1 16
    end
end

function ee
    if [ (count $argv) -eq 0 ]
        set selection (fzf --reverse)
    else
        set selection (find $argv[1] -type f -print0 | fzf --read0 --reverse)
    end
    commandline --replace "e $selection"
    commandline --function execute
end

function terraform
    set -l subcommand $argv[1]
    if [ $subcommand = "apply" ]
        read --prompt-str "Are you sure to apply? (y/n): " answer
        if [ $status -eq 0 -a "$answer" = "y" ]
            command terraform $argv
        else
            echo "Cancelled."
        end
    else
        command terraform $argv
    end
end

# Conversion between unix time and human-readable datetime.
# Use `jq` for its small footprint and portability.
function unix2utc
    echo $argv[1] | jq -Rr 'if . == "" then now else tonumber end | floor | strftime("%Y-%m-%dT%H:%M:%SZ")'
end
function unix2jst
    echo $argv[1] | jq -Rr 'if . == "" then now else tonumber end | floor | . + 32400 | strftime("%Y-%m-%dT%H:%M:%S+09:00")'
end
function utc2unix
    echo $argv[1] | jq -Rr 'strptime("%Y-%m-%dT%H:%M:%SZ") | mktime'
end
function jst2unix
    echo $argv[1] | jq -Rr 'strptime("%Y-%m-%dT%H:%M:%S+09:00") | mktime | . - 32400'
end

# Usage: notify <title> <message> [<sound>]
function notify
    if test (uname) = "Darwin"
        if test -n "$argv[3]"
            osascript \
                -e 'on run argv' \
                -e 'display notification (item 1 of argv) with title (item 2 of argv) sound name (item 3 of argv)' \
                -e 'end run' \
                -- "$argv[2]" "$argv[1]" "$argv[3]"
        else
            osascript \
                -e 'on run argv' \
                -e 'display notification (item 1 of argv) with title (item 2 of argv)' \
                -e 'end run' \
                -- "$argv[2]" "$argv[1]"
        end
    else
        notify-send "$argv[1]" "$argv[2]" --hint "string:sound-name:$argv[3]"
    end
end

function ring
    if test (uname) = "Darwin"
        set sound Funk
    else
        set sound bell
    end
    notify Ring "!!!" $sound
end
