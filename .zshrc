export LANG=ja_JP.UTF-8

export VISUAL=nvim
export EDITOR=nvim

if type open >/dev/null 2>&1; then
    export BROWSER=open
elif type xdg-open >/dev/null 2>&1; then
    export BROWSER=xdg-open
fi

export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

export BAT_THEME=Ocean

# 60 seconds
REPORTTIME=60



########################
# Changing Directories #
########################


# If a command named "xxx" does not exist, try to execute "cd xxx".
setopt AUTO_CD

# Do "pushd ." after "cd".
setopt AUTO_PUSHD

# If "directory" is not found, regard "directory" as "$directory". (for named directory, e.g, $HOME)
setopt CDABLE_VARS

# If "/foo/bar" is a link to "/hoge/piyo", "/foo/bar/.." means "/foo", not "/hoge".
setopt NO_CHASE_LINKS

# Don't execute "pushd" for duplicated direcotries again.
setopt PUSHD_IGNORE_DUPS

# Make "pushd" and 'popd' not to print the directory stack.
setopt PUSHD_SILENT

# Regard "pushd" without any arguments as "pushd $HOME" ("cd" compatible).
setopt PUSHD_TO_HOME



##############
# Completion #
##############

# The completion has finished, the cursor is moved to the end of the word.
setopt ALWAYS_TO_END

# Expand "~xxx" to "$xxx". E.g., "cd ~HOME" is expanded to "cd $HOME".
setopt AUTO_NAME_DIRS

# Do not expand glob patterns, instead, complete matched words.
setopt GLOB_COMPLETE

# Do not beep when the completion failed.
setopt NO_LIST_BEEP

# Make the completion list smaller.
setopt LIST_PACKED

# Sort the completion list horizontally.
setopt LIST_ROWS_FIRST

# Insert the first word immediately.
setopt MENU_COMPLETE



##########################
# Expansion and Globbing #
##########################

# Do not print an error when a bad pattern wad passed.
setopt NO_BAD_PATTERN

# Expand character classes, like "{a-z}" or "{0-9}".
setopt BRACE_CCL

# Add some special characters, '#', '~', and '^', in glob expansion.
setopt EXTENDED_GLOB

# In "aaa=bbb", bbb will be expanded. It is often used for options.
setopt MAGIC_EQUAL_SUBST

# Append a slash to the expanded directory.
setopt MARK_DIRS

# Sort items numerically, not lexicographically.
setopt NUMERIC_GLOB_SORT




###########
# History #
###########

# Do not beep when you refer to unexisting history record.
setopt NO_HIST_BEEP

# Erase oldest duplicate history when history file is full.
setopt HIST_EXPIRE_DUPS_FIRST

# Skip duplicate histories in finding the history.
setopt HIST_FIND_NO_DUPS

# Ignore duplicate history.
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

# Ignore commands starting with spaces.
setopt HIST_IGNORE_SPACE

# Ignore function definitions.
setopt HIST_NO_FUNCTIONS

# Erase extra space.
setopt HIST_REDUCE_BLANKS

# Ignore "history" itself.
setopt HIST_NO_STORE

# Expand a command line from history before executing.
setopt HIST_VERIFY

# Share the history.
setopt SHARE_HISTORY



################
# Input/Output #
################

# Prevent redirection ">" from overwriting existing files. Instead, use ">|" if you will ignore this option.
setopt NO_CLOBBER

# Correct the spelling of the command.
setopt CORRECT

# Disable flow control.
setopt NO_FLOW_CONTROL

# Do not exit when reading EOF(^D).
setopt IGNORE_EOF

# Regard '#' as comment even in interactive mode.
setopt INTERACTIVE_COMMENTS

# Wait 10 seconds before executing `rm *` or `rm path/*`.
setopt RM_STAR_WAIT

# Allow the short form of the loop statement.
setopt SHORT_LOOPS



#########################
# Zsh Line Editor (ZLE) #
#########################

# Do not beep.
setopt NO_BEEP

# Use zle.
setopt ZLE




# Load completion
# Note about "-u" flag of compinit:
# https://github.com/zsh-users/zsh/blob/24a82b9dad1cbe109d9fb5753c429fd37b1618cd/Completion/compinit#L67-L72
autoload -U compinit
compinit -u autoload -U promptinit
zstyle ':completion::complete:*' use-cache true
#zstyle ':completion:*:default' menu select true
zstyle ':completion:*:default' menu select=1

# Ignore case in completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


# Enable color in completion
autoload -Uz colors
colors
zstyle ':completion:*' list-colors "${LS_COLORS}"

# Highlight kill's candidates
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

# Complete commands even if input starts with "sudo"
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# Exclude the current directory from completion list when typing "../".
zstyle ':completion:*' ignore-parents parent pwd ..

autoload -U zcalc
autoload zed

# Enable history completion
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Start-with matching in history
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# Incremental search in history
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward


autoload -Uz zmv


# Limit of completion list
LISTMAX=1000

# Exclude '|' and ':' from word character set
WORDCHARS="$WORDCHARS|:"



# C-u  To delete input from the cursor position to the beginning of the line
bindkey "^U" backward-kill-line

# C-j  To go to the parent directory.
function __cd_parent_dir() {
    [ -e $BUFFER ] || return

    pushd .. > /dev/null
    __update_vcs_info
    __change_terminal_title
    zle reset-prompt
}
zle -N __cd_parent_dir
bindkey "^J" __cd_parent_dir

# C-o  To go to the previous directory.
function __cd_prev_dir() {
    [ -e $BUFFER ] || return

    popd > /dev/null
    __update_vcs_info
    __change_terminal_title
    zle reset-prompt
}
zle -N __cd_prev_dir
bindkey "^O" __cd_prev_dir

# C-g  To go to the project root.
function __cd_project_root_dir() {
    [ -e $BUFFER ] || return

    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]]; then
        pushd $(git rev-parse --show-toplevel) > /dev/null
        zle reset-prompt
    fi
}
zle -N __cd_project_root_dir
bindkey "^G" __cd_project_root_dir


zmodload zsh/complist



autoload -Uz vcs_info


zstyle ':vcs_info:git:*' formats ' (%b)%u%m'
zstyle ':vcs_info:git:*' actionformats ' (%b %a)%u%m'
zstyle ':vcs_info:git:*' unstagedstr '+'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git+set-message:*' hooks git-stash-count

# Add stash count to VCS info.
function +vi-git-stash-count() {
    local stash="$(git stash list 2>/dev/null | wc -l | tr -d ' ')"
    if [[ "${stash}" -gt 0 ]]; then
        hook_com[misc]=" [${stash}]"
    else
        hook_com[misc]=""
    fi
}


function __update_vcs_info() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    if [[ -n "$vcs_info_msg_0_" ]]; then
        psvar[1]="$vcs_info_msg_0_"
    fi
}

function precmd() {
    __update_vcs_info
}



PROMPT="
%75F%B%~%b%1(v,%1v,)
%150F❯%153F❯%159F❯%f "

PROMPT2="%63F❯%62F❯%61F❯%f "

SPROMPT="%179F%BDid you mean %r? (n/y):%b%f "


HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=1000000
SAVEHIST=1000000


bindkey -e


function 256colors() {
    local code
    for code in {0..255}; do
        echo -e "\e[38;05;${code}m $code: Test"
    done
}

function truecolors() {
    awk 'BEGIN{
        s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
        for (colnum = 0; colnum < 77; colnum++) {
            r = 255 - (colnum * 255 / 76);
            g = (colnum * 510 / 76);
            b = (colnum * 255 / 76);
            if (g > 255)
                g = 510 - g;
            printf "\033[48;2;%d;%d;%dm", r, g, b;
            printf "\033[38;2;%d;%d;%dm", 255 - r, 255 - g, 255 - b;
            printf "%s\033[0m", substr(s, colnum + 1, 1);
        }
        printf "\n";
    }'
}



# noxxx on  => xxx off
# noxxx off => xxx on
function showoptions() {
    set -o | sed -e 's/^no\(.*\)on$/\1  off/' -e 's/^no\(.*\)off$/\1  on/'
}



function __change_terminal_title() {
    local _title=$(pwd | rev | awk -F \/ '{print "/"$1"/"$2}'| rev)
    echo -ne "\033]0;${_title}\007"
}

function chpwd() {
    __change_terminal_title
}



function mkcd() {
    mkdir -p $1
    cd $_
}


alias cp='cp -i'
alias mkdir='mkdir -p'
alias mv='mv -i'
alias rm="rm -i"
alias ssh='TERM=xterm-256color ssh'
alias tree='tree -N'

alias zmv='noglob zmv -W'
alias fd='noglob fd'

alias g='git'
alias gs='git s'

alias vim='nvim'
alias vimdiff='nvim -d'
alias view='nvim -R'
alias e='nvim'

if [[ "$(uname)" == "Darwin" ]]; then
    alias o='open'
else
    alias o='xdg-open'
fi

if type bat >/dev/null 2>&1; then
    alias cat='bat'
fi

if type rg >/dev/null 2>&1; then
    alias grep='rg'
fi

if [[ "$(uname)" == "Darwin" ]]; then
    alias ls='ls -G'
    alias lsa='ls -G -a'
    alias ll='ls -G -l'
    alias lsal='ls -G -al'
    alias lla='ls -G -al'
else
    alias ls='ls --color=always'
    alias lsa='ls --color=always -a'
    alias ll='ls --color=always -l'
    alias lsal='ls --color=always -al'
    alias lla='ls --color=always -al'
fi

if [[ "$(uname)" == "Darwin" ]]; then
    alias tac='tail -r'
fi


export LD_LIBRARY_PATH=$HOME/lib:$LD_LIBRARY_PATH

# To override system-provided Ruby with brewed Ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"

export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.deno/bin:$PATH"
export PATH=/usr/local/go/bin:$PATH
