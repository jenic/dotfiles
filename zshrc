# Make things easier
# Using shorthand %F{} causes weird colors on the line...
RCLR='%{$reset_color%}'
YEL='%{$fg[yellow]%}'
BLU='%{$fg[blue]%}'
GRE='%{$fg[green]%}'
RED='%{$fg[red]%}'
PWDCOLOR=$GRE

autoload -U colors && colors

# Version Control Information
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git cvs svn
zstyle ':vcs_info:*:prompt:*' check-for-changes true # slower, but lets us show changes to working/index
zstyle ':vcs_info:*:prompt:*' unstagedstr "${YEL}*${RCLR}"
zstyle ':vcs_info:*:prompt:*' stagedstr "${YEL}+${RCLR}"
zstyle ':vcs_info:*:prompt:*' formats  " ${GRE}%s${RCLR}:${BLU}(%b${RCLR}%c%u${BLU})${RCLR}" "%a"
zstyle ':vcs_info:*:prompt:*' actionformats  " ${GRE}%s${RCLR}:${BLU}(%b|%a)${RCLR}" "%a"
#zstyle ':vcs_info:*:prompt:*' nvcsformats   "" "%~"
#zstyle ':vcs_info:*:prompt:*' branchformat  "%b:%r" ""
############ End VCS

# Sum Aliases
alias vi=vim
alias sc='sudo systemctl'
alias mv="mv -i"
alias cp="cp -i"
alias ls="ls $LS_OPTIONS"
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias s='echo FAIL && ls'
alias mplayer=mpv
alias vdpau='mpv -vo vdpau -fs --framedrop=yes'
alias mkv='vdpau -demuxer mkv'
alias ..='cd ../ && l'
alias ...='cd ../.. && l'
alias ....='cd ../../.. && l'
alias xclip2b='xclip -o | xclip -i -sel clipboard'
alias b2xclip='xclip -o -sel clipboard | xclip -i'
alias ctof='bc -q ~/lib/bc-scripts/CtoF'
alias ftoc='bc -q ~/lib/bc-scripts/FtoC'
alias ffget='wget --user-agent="Mozilla/5.0 (Windows NT 5.1; rv:2.0) Gecko/20100101 Firefox/4.0"'
alias wgetmp3="ffget -nc -r -l 1 -A '*.mp3' --no-directories"
alias btcotp='wget -q -O - http://bitcoin-otc.com/otps/4174775D7DDF9DCF | gpg -q | xclip -i'
alias mkrpibk='sudo dd if=/dev/mmcblk0 | gzip -c > /mnt/XFSArchive1/Archives/RPI-Backup-`date +%Y%m%d`.iso.gz'
alias isrunning='ps aux | grep'
alias psc='ps xawf -eo pid,user,cgroup,args'
alias sleeptime='mpc add "Snow Patrol/02-chasing_cars.mp3" && mpc play `mpc playlist|wc -l` && suspendin 4.35m'
alias hd='od -A x -t x1z -v'
alias ptun='pcmd'
alias fakefox=ffget
alias weaboo-rename="rename -n 's/.*_(\d+)v?\d?_.*/\$1.mkv/' *.mkv && read && rename 's/.*_(\d+)v?\d?_.*/\$1.mkv/' *.mkv"

# Options
setopt COMPLETE_IN_WORD EXTENDED_GLOB BSD_ECHO CORRECT
setopt nobeep # Don't you ever fucking beep
setopt HIST_IGNORE_SPACE HIST_NO_STORE HIST_REDUCE_BLANKS HIST_IGNORE_DUPS
setopt SHARE_HISTORY EXTENDED_HISTORY INC_APPEND_HISTORY HIST_EXPIRE_DUPS_FIRST
setopt C_PRECEDENCES noclobber

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' use-compctl false
zstyle :compinstall filename '/home/jenic/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# tab completion for PID :D
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER -o pid,tty,time,cmd'

# More Completion stuff
zstyle ':completion:*:history-words'   remove-all-dups yes
# Completion caching
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path .zcache
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Lines configured by zsh-newuser-install
HISTFILE=~/.zhistory
HISTSIZE=5080
SAVEHIST=5000
# End of lines configured by zsh-newuser-install
bindkey -v
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
#bindkey "\e[1~" beginning-of-line
#bindkey "\e[4~" end-of-line

# Functions
ihas() { grep -i $1 ~/Documents/Data/checksums.sha1 | sed 's/\s\s/\t/' | cut -f 2 | sort }
wikit() { dig +short txt "$1.wp.dg.cx"; }
hex2utf8() { echo $1 | perl -nE 'binmode STDOUT, ":utf8";say map chr, map hex, split' }
#command_not_found_handler() { /usr/bin/python /usr/lib/command-not-found -- $1; return $?; }
source /usr/share/doc/pkgfile/command-not-found.zsh
play() { vdpau `xclip -o` }

bdns() { 
    # new openssl puts (stdin)= HASH instead of just outputing the damn hash
    sum=`openssl s_client -connect ${1}:443 < /dev/null 2>/dev/null | openssl x509 -outform DER | openssl sha1 | awk '{print $2}'`
    response=`dig +short txt ${sum}.notary.icsi.berkeley.edu`
    echo "$response"
}

suspendin() {
    if [[ -z $1 ]]; then
        n=60
    else
        n=$1
    fi
    sudo -s sleep $n && systemctl suspend
}

dline() {
    if [[ -z $1 ]]; then
        n='$'
    else
        n=$1
    fi

    if [[ -z $2 ]]; then
        f="$HOME/.ssh/known_hosts"
    else
        f=$2
    fi

    sed -i "${n}d" "$f"
}

# Wrapper for specific xdcc parsers
canhas() {
    FILE="$HOME/Documents/Data/current_weaboos"
    if [[ -z $@ ]]; then
        cat "$FILE"
        return 0
    fi

    eval `grep -i "$*" "$FILE" | \
        awk -F@@ '{print $2}'`
}

# This works for all XDCC lists powered by "XDCC Parser"
xdccq() {
    if [[ -z $2 ]]; then
        N='[UTW]Ariel'
    else
        N=$2
    fi
    if [[ -z $3 ]]; then
        H='xdcc.utw.me'
    else
        H=$3
    fi
    wget -q -O - http://$H/search.php"?nick=$N" | grep -i $1 | \
        awk -F, '{split($2,a,":"); print a[2], $4}'
}

# HTML based
csbots() {
    if [[ -z $2 ]]; then
        H='tori.aoi-chan.com'
    else
        H=$2
    fi

    if [[ -z $3 ]]; then
        P='80'
    else
        P=$3
    fi

    if [[ -z $4 ]]; then
        lynx -dump "http://$H:$P" | grep -i "$1" | less
    else
        echo -e "s=$1\n---" | lynx -post_data \
            -dump "http://$H:$P" | less
    fi
}

# Various file downloaders
mediafire() {
    ffget "$1" -q -O - | grep 'kNO =' | \
        sed 's/\(.*\)kNO\s=\s"\(.*\)"\(.*\)/\2/' | \
        ffget -i -
}

getmp4() {
    ffget "$1" -q -O - | \
        grep '.mp4' | grep file= \
        | sed 's/\(.*\)file="\(.*\)"\s\(.*\)/\2/' | ffget -qi -
}

archer() {
    ffget --post-data='fuck_you=&confirm=yuklen' -q -O - "$@" | grep file= | \
        sed 's/.*file=\(http.*flv\).*/\1/' | urldecode | ffget -i -
}

pcmd() {
    if [[ -z $2 ]]; then
        CMD=ssh
    else
        CMD=$2
    fi

    while true; do command $CMD $1; [ $? -eq 0 ] && break || sleep 2; done
}

rndx() {
    OK='a-zA-Z0-9-_!@#$%^&*()_+{}|:<>?='

    if [ -z $1 ]; then
        COUNT=15
    else
        COUNT=$1
    fi

    if [ -z $2 ]; then
        INPUT=/dev/urandom
    else
        INPUT=/dev/random
    fi

    OUT=""
    # wc -m interprets \n as a character, cut does not
    while [ `wc -m <<<"$OUT"` -lt $(($COUNT+1)) ]
    do
        NEW=`dd if=$INPUT bs=1 count=$COUNT 2>/dev/null | tr -dc "$OK"`
        OUT="$OUT$NEW"
    done

    echo $OUT | cut -c -$COUNT
}

urlencode() {
    if [ -z $@ ]; then
        perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg' \
            < /dev/stdin
    else
        echo -n "$@" | \
            perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'
        echo
    fi
}
urldecode() {
    if [ -z $@ ]; then
        perl -pe's/%([a-fA-F0-9]{2,2})/chr(hex($1))/seg' < /dev/stdin
    else
        echo -n "$@" | \
            perl -pe's/%([a-fA-F0-9]{2,2})/chr(hex($1))/seg'
        echo
    fi
}

stocks() {
    STOCKS=`perl -e'print join "+", @ARGV' "$@"`
    OPTS='snl1d1t1ohgdr'
    wget -qO - "http://finance.yahoo.com/d/quotes.csv?s=$STOCKS&f=$OPTS"
}

sumof() {
    echo "$@" | \
    dc -e "[+pz1!=M]sM?lMx" | tail -1
}

lotusdecode() {
    sed 1d <"$1" | base64 -d | gunzip -c > "$1.xml"
}

lotusencode() {
    echo 'application/vnd.xfdl;content-encoding="base64-gzip"' > "$1.xfdl"
    gzip -c "$1" | base64 >> "$1.xfdl"
}

scancode() { 
    printf "$@" |
        tr '1234567890qwertyuiopasdfghjklzxcvbnm' '\2-\13\20-\31\36-\46\54-\62'
}

precmd() {
    vcs_info 'prompt'
    if [[ -w $PWD ]]; then
        PWDCOLOR=$GRE
    else
        PWDCOLOR=$RED
    fi

    PROMPT="${GRE}%n${RCLR}@${BLU}%m${RCLR} ${PWDCOLOR}%1~ ${RCLR}%# "
    RPROMPT="${RCLR}${vcs_info_msg_0_}[${YEL}%?:%l${RCLR}]"
}
