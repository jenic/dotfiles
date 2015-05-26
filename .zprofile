#`.zprofile' is meant as an alternative to `.zlogin' for ksh fans; the two are
#not intended to be used together, although this could certainly be done if
#desired. `.zlogin' is not the place for alias definitions, options,
#environment variable settings, etc.; as a general rule, it should not change
#the shell environment at all. Rather, it should be used to set the terminal
#type and run a series of external commands (fortune, msgs, etc)
#-http://zsh.sourceforge.net/Intro/intro_3.html
# In other words...I'm doing it wrong.
export LANGUAGE='en_US'
export TZ='America/Denver'
export LS_OPTIONS='--color=auto --group-directories-first'
export JAVA_HOME='/usr/lib/jvm/java-default-runtime'
export BOT='CR-TEXAS2|NEW'
export _JAVA_AWT_WM_NONREPARENTING=1

# Make our Environment not retarded
if [ -f ${HOME}/.termcap ]; then
	TERMCAP=$(< ${HOME}/.termcap)
	export TERMCAP
fi
eval `dircolors ~/.dir_colors`

if [ -d "$HOME/bin" ]; then
	export PATH="$HOME/bin:$PATH"
fi
