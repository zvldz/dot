# .cshrc - csh resource script

set path = (/sbin /bin /usr/sbin /usr/bin /usr/games /usr/local/sbin /usr/local/bin /usr/X11R6/bin $HOME/bin)

alias h         history 1000
alias j         jobs -l
alias less      less -x4
alias vim       vim -p
alias 7ze       7za a -mhe=on -p

alias tcpdump   tcpdump -nn
alias trafshow  env TERM=rxvt-unicode-256color trafshow -n
alias iftop     env TERM=rxvt-unicode-256color iftop -nN
alias bmon      env TERM=rxvt-unicode-256color bmon
alias tshark    tshark -n
alias jlog      'journalctl -xe'

if ($OSTYPE == 'FreeBSD') then
    alias ls    ls -A
    alias la    ls -a
    alias lf    ls -FA
    alias ll    ls -lA
    alias grep  grep --color=auto
    alias iotop top -m io -o total

    setenv LSCOLORS 'fxfxcxdxbxegedabagacad'
else
    alias ls    ls --color=auto -A
    alias la    ls --color=auto -a
    alias lf    ls --color=auto -FA
    alias ll    ls --color=auto -lA
    alias grep  grep --color=auto

    if ($?LS_COLORS) then
        setenv LS_COLORS "${LS_COLORS}:di=0;35:"
    else
        setenv LS_COLORS ':di=0;35:'
    endif
endif

umask 22

#setenv LESS        '-F -X -x4 $LESS'

setenv  LANG        en_US.UTF-8
setenv  CLICOLOR    YES
setenv  EDITOR      vim
#setenv PAGER       more
setenv  PAGER       "less -x4"
setenv  BLOCKSIZE   K

if ($?prompt) then
    if ($?TERM && $TERM != "dumb") then
        #set prompt      = "\n%{\e[31;1m%}`whoami`%{\e[37m%}@%{\e[33m%}%m%{\e[37m%}: %{\e[36m%}%/%{\e[37m%} \n#%{\e[0m%} "
        #set prompt      = "%{\033[1;31m%}%n%{\033[0m%}@%{\033[1;33m%}%m%{\033[0m%}: %{\033[1;36m%}%~%{\033[0m%}%{\n%}# "
        set prompt      = "\n%{\e[31;1m%}%n%{\e[37m%}@%{\e[33m%}%m%{\e[37m%}: %{\e[36m%}%/%{\e[37m%} \n#%{\e[0m%} "
    else
        set prompt = "%n@%m:%~\\n# "
    endif

    set filec
    set history     = 1000
    set savehist    = 1000
    #set mail        = (/var/mail/$USER)
    if ( $?tcsh ) then
        if ( "$TERM" == "" || "$TERM" == "dumb" ) then
            setenv TERM xterm-256color
        endif
        bindkey "^W"    backward-delete-word
        bindkey -k up   history-search-backward
        bindkey -k down history-search-forward
        bindkey "\e[1~" beginning-of-line       # Home
        bindkey "\e[7~" beginning-of-line       # Home rxvt
        bindkey "\e[H"  beginning-of-line       # Home xterm
        bindkey "\eOH"  beginning-of-line       # Home alternative
        bindkey "\e[4~" end-of-line             # End
        bindkey "\e[8~" end-of-line             # End rxvt
        bindkey "\e[F"  end-of-line             # End xterm
        bindkey "\eOF"  end-of-line             # End alternative
        bindkey "\e[2~" overwrite-mode          # Ins
        bindkey "\e[3~" delete-char             # Delete
        bindkey "\eOC"  forward-char            # Right arrow
        bindkey "\eOD"  backward-char           # Left arrow
    endif
endif

set autolist
set histdup = prev

if ($?TERM && $TERM != "dumb") then
    setenv LESS_TERMCAP_mb `printf "\033[1;31m"`
    setenv LESS_TERMCAP_md `printf "\033[1;31m"`
    setenv LESS_TERMCAP_me `printf "\033[0m"`
    setenv LESS_TERMCAP_se `printf "\033[0m"`
    setenv LESS_TERMCAP_so `printf "\033[1;44;33m"`
    setenv LESS_TERMCAP_ue `printf "\033[0m"`
    setenv LESS_TERMCAP_us `printf "\033[1;32m"`
endif

if ($shell =~ *tcsh) then
    alias reload    'source ~/.tcshrc'
else
    alias reload    'source ~/.cshrc'
endif
alias vimrc     'vim ~/.vimrc'
alias zshrc     'vim ~/.zshrc'
alias cshrc     'vim ~/.cshrc'
alias tcshrc    'vim ~/.tcshrc'
alias null      'cat /dev/null'
alias apg       'apg -m24 -M NCL -a 1'

set _complete=1

set hosts = (127.0.0.1 localhost)
if ( -r ~/.ssh/known_hosts ) then
    set hosts = ($hosts `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | tr ',' "\n"`)
endif

complete ssh        'p/1/$hosts/ c/-/"(l n)"/   n/-l/u/ N/-l/c/ n/-/c/ p/2/c/ p/*/f/'
complete scp        "c,*:/,F:/," "c,*:,F:$HOME," 'c/*@/$hosts/:/'
complete rsync      "c,*:/,F:/," "c,*:,F:$HOME," 'c/*@/$hosts/:/'
complete ping       'p/1/$hosts/'
complete traceroute 'p/1/$hosts/'
#complete mtr        'p/1/$hosts/'
complete telnet     'p/1/$hosts/' "p/2/x:'<port>'/" "n/*/n/"
complete kill       'c/-/S/' 'p/1/(-)//'
complete killall    'p/1/c/'
complete pkill      'p/1/c/'
complete man        'p/1/c/'
complete cd         'C/*/d/'
complete which      'p/1/c/'
complete where      'p/1/c/'
complete unsetenv   'p/1/e/'
complete setenv     'p/1/e/'
complete env        'c/*=/f/' 'p/1/e/=/' 'p/2/c/'
complete chgrp      'p/1/g/'
complete chown      'p/1/u/'
complete gdb        'n/-d/d/ n/*/c/'
complete uncomplete 'p/*/X/'
complete find       'n/-name/f/' 'n/-newer/f/' 'n/-{,n}cpio/f/' \
            'n/-exec/c/' 'n/-ok/c/' 'n/-user/u/' 'n/-group/g/' \
            'n/-fstype/(nfs 4.2)/' 'n/-type/(b c d f l p s)/' \
            'c/-/(name newer cpio ncpio exec ok user group fstype type atime \
            ctime depth inum ls mtime nogroup nouser perm print prune \
            size xdev)/' \
            'p/*/d/'
complete ln         'C/?/f/' 'p/1/(-s)/' 'n/-s/x:[first arg is path to original file]/' \
            'N/-s/x:[second arg is new link]/'
complete ipfw       'p/1/(flush add delete list show zero table)/' \
            'n/add/(allow permit accept pass deny drop reject \
            reset count skipto num divert port tee port)/'
complete wget       'c/--/(accept= append-output= background cache= \
            continue convert-links cut-dirs= debug \
            delete-after directory-prefix= domains= \
            dont-remove-listing dot-style= exclude-directories= \
            exclude-domains= execute= follow-ftp \
            force-directories force-html glob= header= help \
            http-passwd= http-user= ignore-length \
            include-directories= input-file= level= mirror \
            no-clobber no-directories no-host-directories \
            no-host-lookup no-parent non-verbose \
            output-document= output-file= passive-ftp \
            proxy-passwd= proxy-user= proxy= quiet quota= \
            recursive reject= relative retr-symlinks save-headers \
            server-response span-hosts spider timeout= \
            timestamping tries= user-agent= verbose version wait=)/'


if ( -r ~/.inputrc) then
    setenv INPUTRC ~/.inputrc
endif

set GRC = `which grc`
if ($?TERM != "dumb" && $GRC != "") then
    alias colourify     "$GRC --colour auto"
    alias configure     'colourify ./configure'
    alias diff          'colourify diff'
    alias make          'colourify make'
    alias gcc           'colourify gcc'
    alias g++           'colourify g++'
    alias as            'colourify as'
    alias gas           'colourify gas'
    alias ld            'colourify ld'
    alias netstat       'colourify netstat'
    alias ping          'colourify ping'
    alias traceroute    'colourify traceroute'
    alias head          'colourify head'
    alias tail          'colourify tail'
    alias dig           'colourify dig'
    alias mount         'colourify mount'
    alias ps            'colourify ps'
    alias mtr           'colourify mtr'
    alias df            'colourify df'
    alias la            'colourify ls -a'
    alias lf            'colourify ls -FA'
    alias ll            'colourify ls -lA'
endif

if ( `where tmux` != "" ) then
    set __tmux_cmd_names = (attach-session bind-key break-pane capture-pane clear-history \
        clock-mode command-prompt confirm-before copy-mode \
        delete-buffer detach-client display-message display-panes \
        has-session if-shell join-pane kill-pane kill-server \
        kill-session kill-window last-pane last-window link-window \
        list-buffers list-clients list-commands list-keys list-panes \
        list-sessions list-windows load-buffer lock-client lock-server \
        lock-session move-window new-session new-window next-layout \
        next-window paste-buffer pipe-pane previous-layout previous-window \
        refresh-client rename-session rename-window resize-pane \
        respawn-pane respawn-window rotate-window run-shell save-buffer \
        select-layout select-pane select-window send-keys send-prefix \
        server-info set-buffer set-environment set-option set-window-option \
        show-buffer show-environment show-messages show-options \
        show-window-options source-file split-window start-server \
        suspend-client swap-pane swap-window switch-client unbind-key \
        unlink-window)

    alias __tmux_sessions 'tmux list-sessions | cut -d : -f 1'
    alias __tmux_windows  'tmux list-windows  | cut -d " " -f 1-2 | sed -e "s/://"'
    alias __tmux_panes    'tmux list-panes    | cut -d : -f 1'
    alias __tmux_clients  'tmux list-clients  | cut -d " " -f 1-2 | sed -e "s/://"'

    # Define the completions (see the tcsh man page).
    complete tmux \
        'p/1/$__tmux_cmd_names/' \
        'n/*-session/(-t)/' \
        'n/*-window/(-t)/' \
        'n/*-pane/(-t)/' \
        'n/*-client/(-t)/' \
        'N/*-session/`__tmux_sessions`/' \
        'N/*-window/`__tmux_windows`/' \
        'N/*-pane/`__tmux_panes`/' \
        'N/*-client/`__tmux_clients`/' \
        'n/-t/`__tmux_clients; __tmux_panes; __tmux_windows; __tmux_sessions`/'
endif

if ($OSTYPE == "linux" || $OSTYPE == "linux-gnu") then
    setenv LANG en_US.UTF-8
    set CENTOSVER=`uname -a | grep -Eo '\.el[0-9]'`
    if ($CENTOSVER == ".el7") then
        alias dmesg "dmesg -T -L"
    else
        dmesg -V >& /dev/null
        if ($? == 0) then
            alias dmesg "dmesg -T"
        endif
    endif

    alias realpath  readlink -f
endif

#if ( `where zoxide` != "" ) then
#    echo 111
#    eval `zoxide init tcsh`
#    echo 222
#    alias cd 'z'
#    if ( `where  fzf` != "") then
#        alias cdi 'zi'
#    endif
#    # Display the resolved path before changing directories
#    #setenv _ZO_ECHO 1
#    # Exclude temporary and mounted directories from zoxide's database
#    setenv _ZO_EXCLUDE_DIRS "/tmp/*:/var/tmp/*:/mnt/*"
#    # Customize fzf appearance for interactive directory selection
#    #setenv _ZO_FZF_OPTS "--height 40% --reverse --border"
#endif

if ( `where zoxide` != "" ) then
    if ( ! -f ~/.zoxide.tcsh ) then
        zoxide init tcsh > ~/.zoxide.tcsh
    endif
    if ( -f ~/.zoxide.tcsh ) then
        source ~/.zoxide.tcsh
        alias zcd 'z'
        if ( `where  fzf` != "" ) then
            alias cdi 'zi'
        endif
    else
        echo "Error: Failed to initialize zoxide"
    endif
endif

# Local settings
if ( -f ~/.tcshrc.local ) then
    source ~/.tcshrc.local
endif
