# Environment Variables
# Enable prompt substitutions for escape sequences
setopt promptsubst
# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"
# Append custom paths to PATH
export PATH="$PATH:$HOME/bin:/usr/local/bin:/usr/local/sbin"
# Default editor for local and remote sessions
export EDITOR='vim'
# Default visual editor
export VISUAL='vim'
# Set language and locale
export LANG=en_US.UTF-8
# Set default shell to zsh
export SHELL=$(command -v zsh)
# Configure less with options for quitting, raw output, and tab stops
export LESS='-F -R -X -x4'

# Oh-My-Zsh Configuration
# Enable automatic updates for oh-my-zsh
zstyle ':omz:update' mode auto
# Set update frequency to every 13 days
zstyle ':omz:update' frequency 13
# List of plugins to load
plugins=(git history-substring-search colored-man-pages command-not-found systemd)
# Install oh-my-zsh if not present and restart zsh
if [[ ! -d "$ZSH" ]]; then
    echo "Installing oh-my-zsh..."
    mkdir -p $ZSH
    # Create backup of existing .zshrc
    if [[ -f ~/.zshrc ]]; then
        cp ~/.zshrc ~/.zshrc.backup-$(date '+%Y%m%d_%H%M%S')
        echo "Created backup of .zshrc"
    fi
    if command -v curl >/dev/null; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended --keep-zshrc
    elif command -v wget >/dev/null; then
        sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended --keep-zshrc
    else
        echo "Error: curl or wget required to install oh-my-zsh"
        return 1
    fi
    if [[ -d "$ZSH" ]]; then
        echo "oh-my-zsh installed, restarting zsh..."
        exec zsh
    else
        echo "Error: oh-my-zsh installation failed"
        return 1
    fi
fi
# Source oh-my-zsh framework
source "$ZSH/oh-my-zsh.sh"

# History Settings
# Number of commands stored in memory
HISTSIZE=10000
# Number of commands stored in history file
HISTFILESIZE=20000
# Format for history timestamps
HIST_STAMPS="yyyy-mm-dd"
# Expire duplicate commands first
setopt HIST_EXPIRE_DUPS_FIRST
# Ignore duplicate commands in history
setopt HIST_IGNORE_DUPS
# Ignore commands starting with a space
setopt HIST_IGNORE_SPACE
# Remove extra blanks from commands
setopt HIST_REDUCE_BLANKS
# Skip duplicates in history search
HIST_FIND_NO_DUPS="true"
# Ignore all duplicate commands
HIST_IGNORE_ALL_DUPS="true"

# Completion Settings
# File for completion dump
ZSH_COMPDUMP="${HOME}/.zcompdump"
# Enable caching for completions
zstyle ':completion:*' use-cache on
# Directory for completion cache
zstyle ':completion:*' cache-path ~/.zsh/cache
# Enable interactive completion menu
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
# Allow one error per three characters typed
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
# Colorize process list in kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"
# Enable case-insensitive and partial matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Enable menu-style completion
setopt menucomplete

# Prompt Configuration
# Load color support
autoload -U colors && colors
# Prefix for git prompt
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%} "
# Suffix for git prompt
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# Indicator for dirty git repository
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}⚡"
# Indicator for clean git repository
ZSH_THEME_GIT_PROMPT_CLEAN=""
# Function to display prompt character based on user privileges
function prompt_char {
    if [ $UID -eq 0 ]; then echo "%{$fg[red]%}#%{$reset_color%}"; else echo "$"; fi
}
# Define newline character for prompt
NEWLINE=$'\n'
# Custom prompt with status, user, host, path, git info, and line breaks
PROMPT='%(?, ,%{$fg[red]%}FAIL: $?%{$reset_color%}${NEWLINE})${NEWLINE}%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}: %{$fg_bold[white]%}%~%{$reset_color%}$(git_prompt_info 2>/dev/null)${NEWLINE}%_$(prompt_char) '
# Aliases
# General
# Reload zsh configuration
alias reload='omz reload'
# Edit vim configuration
alias vimrc='vim ~/.vimrc'
# Edit zsh configuration
alias zshrc='vim ~/.zshrc'
# Edit csh configuration
alias cshrc='vim ~/.cshrc'
# Edit tcsh configuration
alias tcshrc='vim ~/.tcshrc'
# Output empty content
alias null='cat /dev/null'
# Show command history
alias h='history'
# Clear history file
alias clear_history=': > $HISTFILE && echo "History cleared"'
# Open vim with tabs
alias vim='vim -p'
# Generate 24-character password
alias apg="apg -m24 -M NCL -a 1"
# Set less with tab stops
alias less='less -x4'
# Encrypt archive with 7za
alias 7ze='7za a -mhe=on -p'

# Network Tools
# TCP dump without name resolution
alias tcpdump='tcpdump -nn'
# Network traffic monitor
alias trafshow='TERM=rxvt-unicode-256color trafshow -n'
# Interface traffic monitor
alias iftop='TERM=rxvt-unicode-256color iftop -nN'
# bmon traffic monitor
alias bmon='TERM=rxvt-unicode-256color bmon'
# Packet analyzer
alias tshark='tshark -n'
# Show systemd journal
alias jlog='journalctl -xe'

# System Tools
# View system logs
alias logs='journalctl -xe'

# Git
# Show git status
alias gs='git status'
# Commit changes
alias gc='git commit'
# Push to remote
alias gp='git push'

# Platform-Specific
if [[ "$OSTYPE" =~ "freebsd" ]]; then
    # Enable colors for FreeBSD
    export CLICOLOR="YES"
    # List all files
    alias ls='ls -A'
    # IO monitoring
    alias iotop='top -m io -o total'
elif [[ "$OSTYPE" =~ "linux" ]]; then
    # List all files with colors
    alias ls='ls -A --color=auto'
    # Kernel messages with time and colors
    alias dmesg='dmesg -T --color=auto'
    # Resolve absolute path
    alias realpath='readlink -f'
fi

# GRC-Colored Commands
if command -v grc >/dev/null; then
    # Colored ping output
    alias ping='grc --colour=auto ping'
    # Colored traceroute output
    alias traceroute='grc --colour=auto traceroute'
    # Colored make output
    alias make='grc --colour=auto make'
    # Colored diff output
    alias diff='grc --colour=auto diff'
    # Colored cvs output
    alias cvs='grc --colour=auto cvs'
    # Colored netstat output
    alias netstat='grc --colour=auto netstat'
    # Colored ifconfig output
    alias ifconfig='grc --colour=auto ifconfig'
    # Colored ip output
    alias ip='grc --colour=auto ip'
    # Colored ps output
    alias ps='grc --colour=auto ps'
    # Colored mount output
    alias mount='grc --colour=auto mount'
    # Colored ls -la output
    alias ll='grc --colour=auto ls -la'
    # Colored ls -la output
    alias la='grc --colour=auto ls -la'
    # Colored dig output
    alias dig='grc --colour=auto dig'
fi

# Terminal Enhancements
if [[ -n "$TERM" && "$TERM" != "dumb" ]]; then
    export TERM=xterm-256color
    # Set blinking text color
    export LESS_TERMCAP_mb=$(printf "\033[1;31m")
    # Set bold text color
    export LESS_TERMCAP_md=$(printf "\033[1;31m")
    # Reset text attributes
    export LESS_TERMCAP_me=$(printf "\033[0m")
    # End standout mode
    export LESS_TERMCAP_se=$(printf "\033[0m")
    # Set standout mode colors
    export LESS_TERMCAP_so=$(printf "\033[1;44;33m")
    # End underline mode
    export LESS_TERMCAP_ue=$(printf "\033[0m")
    # Set underline text color
    export LESS_TERMCAP_us=$(printf "\033[1;32m")
fi

# External Plugins
# List of zsh plugins with their repository URLs
plugins=(
    "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions"
    "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting"
)
# Update all zsh plugins in ~/.zsh by syncing with original repositories
update_zsh_plugins() {
    local temp_dir="/tmp/zsh-plugins"
    local plugin_dir plugin_name repo_url output
    mkdir -p "$temp_dir"
    for plugin in "${plugins[@]}"; do
        plugin_name=${plugin%% *}
        repo_url=${plugin#* }
        echo "Checking $plugin_name..."
        plugin_dir="$temp_dir/$plugin_name"
        output=$(git clone --depth 1 "$repo_url" "$plugin_dir" 2>&1)
        if [[ $output == *"Cloning into"* ]]; then
            rsync -a --exclude '.git' "$plugin_dir/" ~/.zsh/"$plugin_name"/
            local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
            echo "$timestamp Plugin $plugin_name updated" | tee -a ~/.zsh/update.log
            echo "Plugin $plugin_name updated"
        else
            echo "Plugin $plugin_name failed to update: $output"
        fi
    done
    rm -rf "$temp_dir"
    echo "Plugins updated, reloading zsh..."
    omz reload
}
# Check and update plugins if any are missing or empty
for plugin in "${plugins[@]}"; do
    plugin_name=${plugin%% *}
    if [[ ! -d ~/.zsh/$plugin_name || -z "$(ls -A ~/.zsh/$plugin_name)" ]]; then
        echo "One or more plugins missing or empty, updating..."
        update_zsh_plugins
        break
    fi
done
# Alias for updating zsh plugins
alias update-zsh-plugins='update_zsh_plugins'
# Syntax highlighting for commands
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Autosuggestions for command input
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# Limit suggestion buffer size
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
# Enable asynchronous suggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1
# Use history and completion for suggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Custom command execution time tracking
ZSH_COMMAND_TIME_THRESHOLD=3  # Minimum time for reporting execution (seconds)
zsh_command_time() {
    if [[ -n "$ZSH_COMMAND_TIME_START" ]]; then
        local end=$(date +%s)
        local elapsed=$((end - ZSH_COMMAND_TIME_START))
        if [[ $elapsed -ge $ZSH_COMMAND_TIME_THRESHOLD ]]; then
            local hours=$((elapsed / 3600))
            local minutes=$(( (elapsed % 3600) / 60 ))
            local seconds=$((elapsed % 60))
            local color="\033[38;5;8m"
            local reset="\033[0m"
            printf "${color}Execution time: %dh:%02dm:%02ds${reset}\n" $hours $minutes $seconds
        fi
    fi
}
# Hook before command execution
preexec() {
    ZSH_COMMAND_TIME_START=$(date +%s)
}
# Hook after command execution
precmd() {
    zsh_command_time
    unset ZSH_COMMAND_TIME_START
}

# Tool Integrations
# fzf
if command -v fzf >/dev/null; then
    # Load fzf integration
    [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
    # Configure fzf options
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
fi
# zoxide
if command -v zoxide >/dev/null; then
    # Initialize zoxide navigation
    eval "$(zoxide init zsh --hook prompt)"
    # Custom cd function to fall back to built-in cd if zoxide fails
    cd() {
        z "$@" 2>/dev/null && return
        local error
        error=$(command cd "$@" 2>&1)
        if [[ -n "$error" ]]; then
            echo "${1}: No such file or directory."
            return 1
        fi
    }
    alias zcd='z'
    # Interactive zoxide navigation
    alias cdi='zi'
    # Exclude temporary and mounted directories
    export _ZO_EXCLUDE_DIRS="/tmp/*:/var/tmp/*:/mnt/*"
    # Configure fzf for zoxide
    #export FZF_DEFAULT_OPTS="--preview='head -$LINES {}' --bind=down:preview-down --bind=up:preview-up"
fi

# Key Bindings
# Right arrow key
bindkey "^[OC" forward-char
# Left arrow key
bindkey "^[OD" backward-char
# Home key (multiple bindings for compatibility)
bindkey "^[OH" beginning-of-line
bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
# End key (multiple bindings for compatibility)
bindkey "^[OF" end-of-line
bindkey "^[[F" end-of-line
bindkey "^[[4~" end-of-line
# Delete key
bindkey "^[[3~" delete-char
# Page Up key
bindkey "^[[5~" up-line-or-history
# Page Down key
bindkey "^[[6~" down-line-or-history
# Backspace key
bindkey "^?" backward-delete-char

# Miscellaneous
# Ignore commands starting with a space
setopt hist_ignore_space
# Disable aggressive command correction
unsetopt correct_all

# Local Overrides
# Load local configuration overrides
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

