# .bashrc - bash resource script
# Adapted from tcshrc settings

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Path
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$HOME/bin"

# History settings
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# Command execution time tracking (shows for commands > 3 seconds)
_CMD_TIME_THRESHOLD=3
_cmd_timer_start() {
    _CMD_START_TIME=${_CMD_START_TIME:-$SECONDS}
}
_cmd_timer_show() {
    if [ -n "$_CMD_START_TIME" ]; then
        local elapsed=$((SECONDS - _CMD_START_TIME))
        if [ $elapsed -ge $_CMD_TIME_THRESHOLD ]; then
            local hours=$((elapsed / 3600))
            local minutes=$(( (elapsed % 3600) / 60 ))
            local seconds=$((elapsed % 60))
            printf '\e[38;5;8mExecution time: %dh:%02dm:%02ds\e[0m\n' $hours $minutes $seconds
        fi
        unset _CMD_START_TIME
    fi
}
trap '_cmd_timer_start' DEBUG
PROMPT_COMMAND='_cmd_timer_show'

# Git prompt support
_git_prompt() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null)
    if [ -n "$branch" ]; then
        local dirty=""
        if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
            dirty="\[\e[31m\]⚡"
        fi
        echo -e " \[\e[32m\]${branch}${dirty}\[\e[0m\]"
    fi
}

# Prompt with FAIL status, git branch
# Shows "FAIL: X" in red if previous command failed
_prompt_command() {
    local exit_code=$?
    local fail_status=""
    if [ $exit_code -ne 0 ]; then
        fail_status="\[\e[31m\]FAIL: ${exit_code}\[\e[0m\]\n"
    fi
    PS1="${fail_status}\n\[\e[31;1m\]\u\[\e[37m\]@\[\e[33m\]\h\[\e[37m\]: \[\e[36m\]\w\[\e[37m\]$(_git_prompt) \n\[\e[0m\]# "
}
PROMPT_COMMAND='_cmd_timer_show; _prompt_command'

# Environment
export LANG=en_US.UTF-8
export EDITOR=vim
export PAGER="less -x4"
export BLOCKSIZE=K
export CLICOLOR=YES

# LS_COLORS - purple directories
export LS_COLORS="${LS_COLORS}:di=0;35:"

# Less colors for man pages
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'

# Aliases - basic
alias h='history 1000'
alias j='jobs -l'
alias less='less -x4'
alias vim='vim -p'
alias 7ze='7za a -mhe=on -p'

# Aliases - ls with colors
alias ls='ls --color=auto -A'
alias la='ls --color=auto -a'
alias lf='ls --color=auto -FA'
alias ll='ls --color=auto -lA'
alias grep='grep --color=auto'

# Aliases - network
alias tcpdump='tcpdump -nn'
alias trafshow='TERM=rxvt-unicode-256color trafshow -n'
alias iftop='TERM=rxvt-unicode-256color iftop -nN'
alias bmon='TERM=rxvt-unicode-256color bmon'
alias tshark='tshark -n'

# Aliases - config editing
alias reload='source ~/.bashrc'
alias vimrc='vim ~/.vimrc'
alias bashrc='vim ~/.bashrc'
alias zshrc='vim ~/.zshrc'
alias cshrc='vim ~/.cshrc'
alias tcshrc='vim ~/.tcshrc'
alias null='cat /dev/null'
alias apg='apg -m24 -M NCL -a 1'
alias jlog='journalctl -xe'

# Linux specific
alias dmesg='dmesg -T'
alias realpath='readlink -f'

# Key bindings - arrow keys for history search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Key bindings - Home/End (all terminal variants)
bind '"\e[1~": beginning-of-line'
bind '"\e[7~": beginning-of-line'
bind '"\e[H": beginning-of-line'
bind '"\eOH": beginning-of-line'
bind '"\e[4~": end-of-line'
bind '"\e[8~": end-of-line'
bind '"\e[F": end-of-line'
bind '"\eOF": end-of-line'

# Key bindings - Insert/Delete/Arrows
bind '"\e[2~": overwrite-mode'
bind '"\e[3~": delete-char'
bind '"\eOC": forward-char'
bind '"\eOD": backward-char'

# Key bindings - PageUp/PageDown for history
bind '"\e[5~": history-search-backward'
bind '"\e[6~": history-search-forward'

# Readline settings (like tcsh autolist)
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'set colored-stats on'
bind 'set visible-stats on'

# Enable programmable completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# SSH hosts completion
if [ -f ~/.ssh/known_hosts ]; then
    _ssh_hosts=$(cat ~/.ssh/known_hosts 2>/dev/null | cut -f1 -d' ' | tr ',' '\n' | sort -u)
    complete -W "$_ssh_hosts" ssh scp rsync ping mtr traceroute
fi

# grc - colourify commands
if command -v grc &> /dev/null; then
    alias configure='grc --colour=auto ./configure'
    alias diff='grc --colour=auto diff'
    alias make='grc --colour=auto make'
    alias gcc='grc --colour=auto gcc'
    alias g++='grc --colour=auto g++'
    alias as='grc --colour=auto as'
    alias gas='grc --colour=auto gas'
    alias ld='grc --colour=auto ld'
    alias ping='grc --colour=auto ping'
    alias traceroute='grc --colour=auto traceroute'
    #alias mtr='grc --colour=auto mtr'
    alias dig='grc --colour=auto dig'
    alias ifconfig='grc --colour=auto ifconfig'
    alias ip='grc --colour=auto ip'
    alias mount='grc --colour=auto mount'
    alias df='grc --colour=auto df'
    alias ps='grc --colour=auto ps'
    alias netstat='grc --colour=auto netstat'
    alias head='grc --colour=auto head'
    alias tail='grc --colour=auto tail'
    alias la='ls --color=auto -a'
    alias lf='ls --color=auto -FA'
    alias ll='ls --color=auto -lA'
fi

# tmux completion
if command -v tmux &> /dev/null; then
    _tmux_completions() {
        local cur prev commands
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"

        commands="attach-session bind-key break-pane capture-pane clear-history \
            clock-mode command-prompt confirm-before copy-mode delete-buffer \
            detach-client display-message display-panes has-session if-shell \
            join-pane kill-pane kill-server kill-session kill-window last-pane \
            last-window link-window list-buffers list-clients list-commands \
            list-keys list-panes list-sessions list-windows load-buffer \
            lock-client lock-server lock-session move-window new-session \
            new-window next-layout next-window paste-buffer pipe-pane \
            previous-layout previous-window refresh-client rename-session \
            rename-window resize-pane respawn-pane respawn-window rotate-window \
            run-shell save-buffer select-layout select-pane select-window \
            send-keys send-prefix server-info set-buffer set-environment \
            set-option set-window-option show-buffer show-environment \
            show-messages show-options show-window-options source-file \
            split-window start-server suspend-client swap-pane swap-window \
            switch-client unbind-key unlink-window"

        case "$prev" in
            -t)
                # Complete with sessions, windows, panes, clients
                local targets=""
                targets+=$(tmux list-sessions 2>/dev/null | cut -d: -f1)$'\n'
                targets+=$(tmux list-windows 2>/dev/null | cut -d' ' -f1-2 | sed 's/://')$'\n'
                targets+=$(tmux list-panes 2>/dev/null | cut -d: -f1)$'\n'
                targets+=$(tmux list-clients 2>/dev/null | cut -d' ' -f1)
                COMPREPLY=($(compgen -W "$targets" -- "$cur"))
                return 0
                ;;
            attach*|switch-client)
                COMPREPLY=($(compgen -W "-t" -- "$cur"))
                return 0
                ;;
        esac

        if [ $COMP_CWORD -eq 1 ]; then
            COMPREPLY=($(compgen -W "$commands" -- "$cur"))
        fi
        return 0
    }
    complete -F _tmux_completions tmux
fi

# Local settings
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi
