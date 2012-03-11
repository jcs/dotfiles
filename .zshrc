# vim:ts=3:et:ft=zsh
#
# zshell config
# joshua stein <jcs@jcs.org>
#

# environment variables
export BLOCKSIZE=1k
export CVS_RSH=/usr/bin/ssh
export IRCNAME="*Unknown*"

# ow my security
export MYSQL_HISTFILE=/dev/null

# pass through to bash in case it somehow gets invoked
export HISTFILE=

export PATH=~/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/X11R6/bin

# on non-interactive shells, just exit here to speed things up
if [[ ! -o interactive ]]; then
	return
	exit
fi

# i'm too lazy to type these out
alias ccom='cvs -q diff -upRN \!* || (echo; echo enter to commit; sh -c read && cvs com \!*)'
alias cdu='cvs -q diff -upRN'
alias cp='cp -i'
alias hg='history | grep '
alias jobs='jobs -p'
alias ll='ls -alF'
alias lo='logout'
alias ls='ls -aF'
if [[ $OSTYPE = linux* ]]; then
	alias ls='ls -aFv'
fi
alias manfile='groff -man -Tascii \!* | less'
alias mv='mv -i'
alias offline_mutt='mutt -R -F ~/.muttrc.offline'
alias ph='ps auwwx | head'
alias pg='ps auwwx | grep -i -e ^USER -e '
alias refetch='cvs -q up -PACd'
alias telnet='telnet -K'
alias tin='tin -arQ'
alias u='cvs -q up -PAd'

# for openbsd ports
alias remake='cd ../../; rm w-*/.build*; make; cd -'

if [[ $OSTYPE = darwin* ]]; then
   # mac os'isms
   alias ldd='otool -L'
   alias sha1='openssl dgst -sha1'

   # pre-lion uses dscacheutil
   alias dnsflush='dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

   # update dotfiles
   alias update_dotfiles='curl https://raw.github.com/jcs/dotfiles/master/move_in.sh | sh -x -'

elif [[ $OSTYPE = OpenBSD* ]]; then
   export PKG_PATH=http://mirror.planetunix.net/pub/OpenBSD/snapshots/packages/`arch -s`/
   alias watchbw='netstat -w1 -b -I'

   alias update_dotfiles='ftp -Vo - https://raw.github.com/jcs/dotfiles/master/move_in.sh | sh -'
fi

# where am i
alias publicip='curl http://ifconfig.me'

# when i say vi i mean vim (if it's installed)
if [ -x "`which vim`" ]; then
   alias vi='vim'
   alias view='vim -R'
   export EDITOR=`which vim`
else
   export EDITOR=/usr/bin/vi
fi

# zsh will try to use vi key bindings because of the vi $EDITOR, but i want
# emacs style for control+a/e, etc.
bindkey -e

# options
setopt NOCLOBBER                     # halp me
setopt PRINT_EXIT_VALUE              # i want to know if something went wrong
HISTSIZE=500
PS1='%n@%m:%~%(!.#.>) '              # prompt
TMOUT=0                              # don't auto logout

# show all logins and such
watch=all
WATCHFMT="%B%n%b %a %l at %@"

# old tcsh options needing counterparts
#set autocorrect                      # fix typos

# etc
limit coredumpsize 0                 # don't know why you'd want anything else
umask 022                            # be nice

# load any local aliases and machine-specific things
if [ -f ~/.zshrc.local ]; then
   source ~/.zshrc.local
fi

if [[ $OSTYPE != linux* ]]; then
	# siginfo
	stty status '^T'
fi
