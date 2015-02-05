# vim:ts=3:et:ft=zsh
#
# zshell config
# joshua stein <jcs@jcs.org>
#

# environment variables
export BLOCKSIZE=1k
export CVS_RSH=/usr/bin/ssh
export IRCNAME="*Unknown*"
export GOPATH=~/code/go

# pass through to bash in case it somehow gets invoked
export HISTFILE=

# ow my security
export MYSQL_HISTFILE=/dev/null

# get off my lawn
export NO_COLOR=1

export PATH=~/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/X11R6/bin

# let control+w only delete one directory of a path, not the whole word
export WORDCHARS='*?_[]~=&;!#$%^(){}'

# on non-interactive shells, just exit here to speed things up
if [[ ! -o interactive ]]; then
   return
fi

# zsh will try to use vi key bindings because of the vi $EDITOR, but i want
# emacs style for control+a/e, etc.
bindkey -e

# i'm too lazy to type these out
alias calc='perl -pe "print eval(\$_) . chr(10);"'
alias ccom='cvs -q diff -upRN \!* || (echo; echo enter to commit; sh -c read && cvs com \!*)'
alias cdu='cvs -q diff -upRN'
alias cp='cp -i'
alias hg='history | grep '
alias jobs='jobs -p'
alias ll='ls -alF'
alias lo='logout'
alias ls='ls -aF'
alias manfile='groff -man -Tascii \!* | less'
alias mv='mv -i'
alias offline_mutt='mutt -R -F ~/.muttrc.offline'
alias ph='ps auwwx | head'
alias pg='ps auwwx | grep -i -e ^USER -e '
alias publicip='curl http://ifconfig.me'
alias refetch='cvs -q up -PACd'
alias telnet='telnet -K'
alias tin='tin -arQ'
alias u='cvs -q up -PAd'
# serve up the current directory
alias webserver="ifconfig | grep 'inet ' | grep -v 127.0.0.1; python -m SimpleHTTPServer"

# when i say vi i mean vim (if it's installed)
if [ -x "`which vim`" ]; then
   alias vi='vim'
   alias view='vim -R'
   export EDITOR=`which vim`
else
   export EDITOR=/usr/bin/vi
fi

# options
setopt NOCLOBBER                     # halp me
setopt PRINT_EXIT_VALUE              # i want to know if something went wrong
HISTSIZE=500
PS1='%n@%m:%~%(!.#.>) '              # prompt
TMOUT=0                              # don't auto logout

setopt nohup                         # don't kill things when i logout

# show all logins and such
watch=all
WATCHFMT="%B%n%b %a %l at %@"

# etc
limit coredumpsize 0                 # don't know why you'd want anything else
umask 022                            # be nice

autoload -Uz compinit
compinit

# os-specific tweaks

# mac os
if [[ $OSTYPE = darwin* ]]; then
   alias ldd='otool -L'
   alias sha1='openssl dgst -sha1'

   # update dotfiles
   alias update_dotfiles='curl https://raw.github.com/jcs/dotfiles/master/move_in.sh | sh -x -'

   # bring in rbenv
   export PATH="${HOME}/.rbenv/shims:${PATH}"
   source "/usr/local/Cellar/rbenv/0.4.0/completions/rbenv.zsh";

# openbsd
elif [[ $OSTYPE = openbsd* ]]; then
   export PKG_PATH=http://mirror.planetunix.net/pub/OpenBSD/`uname -r`/packages/`arch -s`/
   alias watchbw='netstat -w1 -b -I'

   alias update_dotfiles='ftp -Vo - https://raw.github.com/jcs/dotfiles/master/move_in.sh | sh -'

   # for ports
   alias remake='cd ../../; rm w-*/.build*; make; cd -'

# loonix
elif [[ $OSTYPE = linux* ]]; then
   alias ls='ls -aFv'
fi

# and the reverse
if [[ $OSTYPE != linux* ]]; then
   # siginfo
   stty status '^T'
fi

if [[ $OSTYPE != darwin* ]]; then
   watch=
fi

# load any local aliases and machine-specific things
if [[ $OSTYPE = darwin* ]] && [ -f ~/.zshrc.mac ]; then
  source ~/.zshrc.mac
fi

if [ -f ~/.zshrc.local ]; then
   source ~/.zshrc.local
fi

if [ "$STORE_LASTDIR" = "1" ]; then
   # now go to the last dir that was there
   chpwd() {
      pwd >! ~/.zsh.lastdir
   }

   if [ -f ~/.zsh.lastdir ]; then
      if [ -d "`cat ~/.zsh.lastdir`" ]; then
         cd "`cat ~/.zsh.lastdir`"
      else
         rm -f ~/.zsh.lastdir
      fi
   fi
fi
