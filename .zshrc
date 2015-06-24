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
zstyle ':vcs_info:*' enable git cvs svn hg bzr
# slower, but lets us show changes to working/index
zstyle ':vcs_info:*:prompt:*' check-for-changes true
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
alias ..='cd ../ && l'
alias ...='cd ../.. && l'
alias ....='cd ../../.. && l'
alias xclip2b='xclip -o | xclip -i -sel clipboard'
alias b2xclip='xclip -o -sel clipboard | xclip -i'
alias x2b=xclip2b
alias b2x=b2xclip
alias psc='ps xawf -eo pid,user,cgroup,args'
#alias sleeptime='mpc add "Snow Patrol/10-crack_the_shutters.mp3" && mpc play `mpc playlist|wc -l` && suspendin 4.35m'
alias sleeptime='mplay "Snow Patrol/10-crack_the_shutters.mp3" && suspendin 3.2m'
alias isrunning='ps aux | grep'
alias mkrpibk='sudo dd if=/dev/mmcblk0 | gzip -c > /mnt/XFSArchive1/Archives/RPI-Backup-`date +%Y%m%d`.iso.gz'
# http://lcamtuf.blogspot.com/2014/10/psa-dont-run-strings-on-untrusted-files.html
alias strings='strings -a'
alias hd='od -A x -t x1z -v'
alias battlenet="cd $HOME/'.wine/drive_c/Program Files (x86)/World of Warcraft' && wine 'World of Warcraft Launcher.exe'"
alias csvtr="tr '\n' ','"
alias weabformat="cut -d ' ' -f 1 | tr '\n' ' '"
alias record-desktop="ffmpeg -f alsa -ac 1 -i hw:2 -f x11grab -s 1920x1080 -framerate 25 -i :0.0"

## Video related
alias 3d='mpv -vo opengl-old:stereo=3'
alias mplayer=mpv
alias vdpau='mpv -vo vdpau -fs --framedrop=decoder+vo'
alias mkv='vdpau -demuxer mkv'

## BC Scripts
alias ctof='bc -q ~/lib/bc-scripts/CtoF'
alias ftoc='bc -q ~/lib/bc-scripts/FtoC'
alias stoploss='bc -q ~/lib/bc-scripts/getP'
alias hr2yr='bc -q ~/lib/bc-scripts/hr2yr'
alias yr2hr='bc -q ~/lib/bc-scripts/yr2hr'

## Network related
alias ffget='wget -4 --user-agent="Mozilla/5.0 (Windows NT 5.1; rv:2.0) Gecko/20100101 Firefox/4.0"'
alias wgetmp3="ffget -nc -r -l 1 -A '*.mp3' --no-directories"
alias btcotp='ffget -q -O - http://bitcoin-otc.com/otps/4174775D7DDF9DCF | gpg -q | xclip -i'
alias ptun='pcmd'
alias unfucklink="xclip -o | tr -d '\n' && echo"
alias mywanip="lynx -dump -nolist ipchicken.com | perl -ne 'print unless(/\]$/ || /^\s+$/)'"
alias fakefox=ffget

# Options
setopt COMPLETE_IN_WORD EXTENDED_GLOB BSD_ECHO CORRECT
setopt nobeep # Don't you ever fucking beep
setopt HIST_IGNORE_SPACE HIST_NO_STORE HIST_REDUCE_BLANKS HIST_IGNORE_DUPS
setopt SHARE_HISTORY EXTENDED_HISTORY INC_APPEND_HISTORY HIST_EXPIRE_DUPS_FIRST
setopt C_PRECEDENCES noclobber

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: TAB for more, or character to insert%s
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
#command_not_found_handler() { /usr/bin/python /usr/lib/command-not-found -- $1; return $?; }

#
## Network Related
#
wikit() { dig +short txt "$1.wp.dg.cx"; }

bdns() { 
    # new openssl puts (stdin)= HASH instead of just outputing the damn hash
    sum=`openssl s_client -connect ${1}:443 </dev/null 2>/dev/null | \
        openssl x509 -outform DER | openssl sha1 | awk '{print $2}'`
    response=`dig +short txt ${sum}.notary.icsi.berkeley.edu`
    echo "$response"
}

# Various file downloaders
## Helper for file downloaders
getfoo() {
    ffget "$1" "$4" -q -O - | \
        grep "$2" | tr -d \' | \
        sed 's/'"$3"'/\2/' | \
        urldecode | ffget -i -
}

mediafire() {
    getfoo "$1" 'kNO =' '\(.*\)kNO\s=\s"\(.*\)"\(.*\)'
}

getml() {
    getfoo "$1" '__fileurl' '\(.*\) \(.*\);\(.*\)'
}

getx() {
    getfoo "$1" 'flv_url' '\(.*\)flv_url=\(.*\)&amp;related\(.*\)'
}

getmp4() {
    getfoo "$1" '.mp4' '\(.*\)file="\(.*\)"\s\(.*\)'
}

archer() {
    getfoo "$1" 'file: ' '\(.*\)"\(.*\)".*' \
        --post-data='fuck_you=&confirm=yuklen'
}

toontv() {
    ffget -q -O - "$@" | grep '_url = ' | \
        sed 's/.*"\(.*\)".*/\1/' | urldecode | ffget -i - && \
        rename 's/(.*?)\?.*/$1/' *.mp4\?*
}

#s = stock
#n = name
#l1 = last trade (price only)
#d1 = last trade date
#t1 = last trade time
#h = high
#g = low
#r = P/E ratio
#p2 = percent change
stocks() {
    STOCKS=`tr ' ' '+' <<<"$@"`
    [ -z $OPTS ] && OPTS='sl1p2hgrnd1t1'

    raw=`ffget -qO - "http://finance.yahoo.com/d/quotes.csv?s=$STOCKS&f=$OPTS"`
    while read line; do
        change=`awk -F, '{print $3}' <<<"$line"`
        if [[ "${change:1:1}" == "-" ]]; then
            echo -e "$fg[red]${line}${reset_color}"
        else
            echo -e "$fg[green]${line}${reset_color}"
        fi
    done <<<`tr -d "\r" <<<"$raw"`
}

proxy_get() {
    ssh angry.goos.es "./bin/proxy_get $1" | gzip -dc > `date +%s`.mp4
}

dpaste() {
    [ -z $1 ] && DAYS=1 || DAYS=$1

    curl -si -F "expiry_days=$DAYS" -F "content=<-" \
        http://dpaste.com/api/v2/ | \
        grep '^Location:' | colrm 1 10
}

imgur() {
    [ -z "$CLIENTID" ] && CLIENTID='83486f068fd3b4f'

    for img in $@; do
        curl -sH "Authorization: Client-ID $CLIENTID" -F "image=@$img" \
            https://api.imgur.com/3/upload | \
            sed -e 's/\\//g'
    done;
}

del_imgur() {
    [ -z "$CLIENTID" ] && CLIENTID='83486f068fd3b4f'

    for img in $@; do
        curl -sH "Authorization: Client-ID $CLIENTID" \
            -X DELETE "https://api.imgur.com/3/image/@$img" | \
            sed -e 's/\\//g'
    done;
}

#
##Encoding/Decoding
#
hex2utf8() {
    if [ -z $@ ]; then
        perl -nE 'binmode STDOUT, ":utf8";say map chr, map hex, split' \
            < /dev/stdin
    else
        perl -nE 'binmode STDOUT, ":utf8";say map chr, map hex, split' \
            <<<"$@"
    fi
}

urlencode() {
    if [ -z $@ ]; then
        perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg' \
            < /dev/stdin
    else
        perl -pe\
            's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg' \
            <<<"$@"
        echo
    fi
}

urldecode() {
    if [ -z $@ ]; then
        perl -pe's/%([a-fA-F0-9]{2,2})/chr(hex($1))/seg' < /dev/stdin
    else
        perl -pe's/%([a-fA-F0-9]{2,2})/chr(hex($1))/seg' <<<"$@"
        echo
    fi
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

#
## System
#
suspendin() {
    if [[ -z $1 ]]; then
        n=60
    else
        n=$1
    fi
    sudo -s sleep $n && systemctl suspend
}

suspendafter() {
   sudo -s sh -c "while sleep 2; do ps aux | grep $@ | grep -qv grep || break; done && systemctl suspend"
}

pcmd() {
    [ -z $2 ] && CMD=ssh || CMD=$2

    while true; do command $CMD $1; [ $? -eq 0 ] && break || sleep 2; done
}

#
## Various Helpers
#
rndx() {
    [ -z "$OK" ] && OK='a-zA-Z0-9-_!@#$%^&*()_+{}|:<>?='

    [ -z $1 ] && COUNT=15 || COUNT=$1
    [ -z $2 ] && INPUT=/dev/urandom || INPUT=/dev/random

    OUT=""
    # wc -m interprets \n as a character, cut does not
    while [ `wc -m <<<"$OUT"` -lt $(($COUNT+1)) ]
    do
        NEW=`dd if=$INPUT bs=1 count=$COUNT 2>/dev/null | tr -dc "$OK"`
        OUT="$OUT$NEW"
    done

    echo $OUT | cut -c -$COUNT
}

sumof() {
    dc -e "[+pz1!=M]sM?lMx" <<<"$@" | tail -1
}

# Frequency Analysis helper
charfreq() {
    perl -le \
        'my%i;for(grep(!/\s/,split"",<STDIN>)){$i{$_}++}while(my($k,$v)=each%i){print"$k\t$v"}' \
        <<<"$@"
}

dline() {
    [ -z $1 ] && f="$HOME/.ssh/known_hosts" || f=$1
    [ -z $2 ] && n='$' || n=$2

    sed -i "${n}d" "$f"
}

epoch() {
    for x in $@; do
        date --date="@$x";
    done
}

quotesearch() {
    STR="$@"
    awk "BEGIN { RS=\"=\";IGNORECASE=1 } \$0 ~ /$STR/" </opt/qs/quotes
}

ihas() {
    STR=`tr ' ' '.' <<<"$1"`
    grep -ie "$STR" ~/Documents/Data/checksums.sha1 | \
        sed 's/\s\s/\t/' | \
        cut -f 2 | sort
}

# Video related
mplay() { mpc add <<<"$@" && mpc play "`mpc playlist|wc -l`" }
# Moved to a shell script so xmonad can play too
#play() { vdpau `xclip -o` }

### ZSH Specific
precmd() {
    vcs_info 'prompt'
    [ -w $PWD ] && PWDCOLOR=$GRE || PWDCOLOR=$RED

    PROMPT="${GRE}%n${RCLR}@${BLU}%m${RCLR} ${PWDCOLOR}%1~ ${RCLR}%# "
    RPROMPT="${RCLR}${vcs_info_msg_0_}[${YEL}%?:%l${RCLR}]"
}

# Include
source /usr/share/doc/pkgfile/command-not-found.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/Projects/weaboo-tools/neet-shell.zsh
