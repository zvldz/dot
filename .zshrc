# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
#ZSH_THEME="tjkirch"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

HISTSIZE=
HISTFILESIZE=

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(history-substring-search colored-man-pages git httpie command-not-found dircycle encode64 systemd zsh-interactive-cd)

# dircycle - Ctrl+Shift+Left/Right

HIST_FIND_NO_DUPS="true"
HIST_IGNORE_ALL_DUPS="true"

ZSH_COMPDUMP="${HOME}/.zcompdump"

# User configuration

export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/usr/X11R6/bin:$HOME/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

setopt hist_ignore_space
unsetopt correct_all

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
fi

if [[ "$OSTYPE" =~ "freebsd" ]]
then
    export CLICOLOR="YES"
    alias ls='ls -A'
    alias iotop='top -m io -o total'

#   if [[ "$TERM" -ne "su" ]]
#   then
#       tabs -4
#   fi
else
    alias ls='ls -A --color=auto'

#   if [[ -n "$TERM" ]]
#   then
#       tabs 4
#   fi
fi

if [[ "$OSTYPE" =~ "linux" ]]
then
    # Override after other shell
    export SHELL=`whereis -b zsh | cut -f2 -d' '`
    export LANG=en_US.UTF-8

    CENTOSVER=`uname -a | grep -Eo '\.el[0-9]'`
    if [ "$CENTOSVER" = ".el7" ]
    then
        alias dmesg='dmesg -T -L'
    else
        dmesg -V >& /dev/null
        if [ $? -eq 0 ]
        then
            alias dmesg='dmesg -T'
        fi
    fi
    alias realpath='readlink -f'
#   BACKSPACE for Linux
#   stty erase '^H' >& /dev/null
#   stty erase '^?' >& /dev/null
fi

#export LESSCHARSET=UTF-8
#export LESS='-F -X -x4 $LESS'

#alias reload='source ~/.zshrc'
# zsh_reload
alias reload='omz reload'
alias vimrc='vim ~/.vimrc'
alias zshrc='vim ~/.zshrc'
alias cshrc='vim ~/.cshrc'
alias tcshrc='vim ~/.tcshrc'
alias null='cat /dev/null'
alias h='history'
alias clear_history='cat /dev/null > $HISTFILE & source ~/.zshrc'

alias vim='vim -p'
alias apg="apg -m24 -M NCL -a 1"
alias less='less -x4'
alias 7ze='7za a -mhe=on -p'

alias tcpdump='tcpdump -nn'
alias trafshow='trafshow -n'
alias iftop='iftop -nN'
alias tshark='tshark -n'

if [ -f /usr/bin/grc -o -f /usr/local/bin/grc ]
then
    alias ping='grc --colour=auto ping'
    alias traceroute='grc --colour=auto traceroute'
    alias make='grc --colour=auto make'
    alias diff='grc --colour=auto diff'
    alias cvs='grc --colour=auto cvs'
#   alias netstat='grc --colour=auto netstat'
    alias ifconfig='grc --colour=auto ifconfig'
    alias ip='grc --colour=auto ip'
#   alias ps='grc --colour=auto ps'
    alias mtr='grc --colour=auto mtr'
    alias mount='grc --colour=auto mount'
#   alias ll='grc --colour=auto ls -la'
#   alias la='grc --colour=auto ls -la'
    alias dig='grc --colour=auto dig'
fi

#bindkey "^[OB" down-line-or-search
bindkey "^[OC"  forward-char
bindkey "^[OD"  backward-char
bindkey "^[OF"  end-of-line
bindkey "^[OH"  beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[3~" delete-char
bindkey "^[[4~" end-of-line
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history
bindkey "^?"    backward-delete-char

# list of completers to use
#zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
setopt menucomplete
zstyle ':completion:*' menu select=1 _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"

autoload -U zcalc

source ~/.zsh/zsh-command-time/command-time.plugin.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# If command execution time above min. time, plugins will not output time.
ZSH_COMMAND_TIME_MIN_SECONDS=3

# Message to display (set to "" for disable).
ZSH_COMMAND_TIME_MSG="Execution time: %s sec"

# Message color.
ZSH_COMMAND_TIME_COLOR="8"

#push-line-or-edit

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}⚡"
ZSH_THEME_GIT_PROMPT_CLEAN=""

function prompt_char {
    if [ $UID -eq 0 ]; then echo "%{$fg[red]%}#%{$reset_color%}"; else echo $; fi
}

PROMPT='%(?, ,%{$fg[red]%}FAIL: $?%{$reset_color%}
)
%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}: %{$fg_bold[white]%}%~%{$reset_color%}$(git_prompt_info)
%_$(prompt_char) '

# Local settings
if [ -f ~/.zshrc.local ]
then
    source ~/.zshrc.local
fi
