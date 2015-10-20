# Path to your oh-my-zsh installation.
export ZSH=/root/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="tjkirch"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(history-substring-search colored-man git svn httpie zsh-syntax-highlighting)

# User configuration

export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/usr/X11R6/bin:/root/bin:/usr/local/av/bin/"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

if [ -f /usr/bin/grc -o -f /usr/local/bin/grc ]
then
	alias ping="grc --colour=auto ping"
	alias traceroute="grc --colour=auto traceroute"
	alias make="grc --colour=auto make"
	alias diff="grc --colour=auto diff"
	alias cvs="grc --colour=auto cvs"
	alias netstat="grc --colour=auto netstat"
	alias ifconfig="grc --colour=auto ifconfig"
	alias ps="grc --colour=auto ps"
	alias mtr="grc --colour=auto mtr"
	alias mount="grc --colour=auto mount"
	alias ll="grc --colour=auto ls -la"
	alias la="grc --colour=auto ls -la"
	alias diff="grc --colour=auto diff"
	alias dig="grc --colour=auto dig"
fi

alias reload='source ~/.zshrc'
alias vimrc='vim ~/.vimrc'
alias zshrc='vim ~/.zshrc'
alias cshrc='vim ~/.cshrc'
alias tcshrc='vim ~/.tcshrc'
alias null='cat /dev/null'
alias apg="apg -m24 -M NCL -a 1"


if [ "$OSTYPE" = "linux" -o "$OSTYPE" = "linux-gnu" ]
then
	CENTOSVER=`uname -a | grep -Eo '\.el[0-9]'`
	if [ "$CENTOSVER" = ".el7" ]
	then
		alias dmesg="dmesg -T -L"
	else
		dmesg -V >& /dev/null
		if [ $? -eq 0 ]
		then
			alias dmesg="dmesg -T"
		fi
	fi
fi

bindkey "\033[1~" beginning-of-line	# Home
bindkey "\033[4~" end-of-line		# End

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

# BACKSPACE for Linux 
#stty erase '^H'
