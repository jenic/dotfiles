#!/usr/bin/env bash

# .Xdefaults is deprecated, xrdb better solution:
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
# To quote archwiki: The older .Xdefaults file is read every time you start an
# X11 program such as xterm, but only if xrdb has not ever been used in the
# current X session.

# Map mod5 to Menu key for URxvt
#xmodmap -e 'add mod5 = Menu'

export OOO_FORCE_DESKTOP=gnome
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export EDITOR="vim"
export MPD_HOST="localhost"
export MPD_PORT="6600"
#export PENTADACTYL_INIT=':source ~/.pentadactyl.conf'

#source /etc/X11/xinit/xinitrc.d/30-dbus
# Start Gnome-Keyring
#eval $(gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
#export GNOME_KEYRING_SOCKET
#export GNOME_KEYRING_PID
#export GNOME_KEYRING_CONTROL
#export SSH_AUTH_SOCK

# Start Shit
/usr/bin/urxvtd -q -f -o
/usr/bin/xsetroot -cursor_name left_ptr &
/usr/bin/xcompmgr &
/usr/bin/xscreensaver -no-splash &
/bin/sh ~/.fehbg &
/usr/bin/trayer --edge bottom --align left --SetDockType true \
    --SetPartialStrut true \
    --expand true --width 3 --transparent true \
    --tint 0x000000 --height 10&
#--distance 279 & # Dirty hack for TwinView

#/usr/bin/batti &

~/bin/pafix

killall dyn-mpd
/usr/bin/mpd && mpc consume on && mpc repeat on
# Lol startup music
mpc add 'Sound Clips/invader_zim-bowdown.ogg'
/home/jenic/bin/dyn-mpd -c 200 &
#/usr/bin/pidgin &

exec /usr/bin/xmonad
