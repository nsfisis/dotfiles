set -l has_nvim (type -q nvim)
set -l has_fd (type -q fd)
set -l on_darwin (test (uname) = "Darwin")

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
alias rm 'rm -i'
alias ssh 'TERM=xterm-256color command ssh'
alias tree 'tree -N --gitignore'
alias view 'nvim -R'
alias vim 'nvim'
alias vimdiff 'nvim -d'

if [ -n $on_darwin ]
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

if [ -n $has_fd ]
    set -gx FZF_DEFAULT_COMMAND "fd --type f --strip-cwd-prefix --hidden --exclude .git"
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
