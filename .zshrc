# vim:ts=3:et:ft=zsh
#
# zshell config
# joshua stein <jcs@jcs.org>
#

# environment variables
export BLOCKSIZE=1k
export CVS_RSH=/usr/bin/ssh
export IRCNAME="*Unknown*"
unset HISTFILE
export LANG=en_US.UTF-8
export LESS="-i"
export LESSHISTFILE=/dev/null
export MYSQL_HISTFILE=/dev/null
export NO_COLOR=1
export PAGER="less -R"
export PATH=~/bin:~/go/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/X11R6/bin
export SSH_ASKPASS_REQUIRE=prefer

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
alias cdgmp='cd /usr/src/sys/arch/`arch -s`/compile/GENERIC.MP'
alias cdu="cvs -q diff -upRN"
alias cp="cp -i"
alias gd="git diff"
alias gs="git status"
alias hg="history | grep "
alias jobs="jobs -p"
alias k9="kill -9 %1"
alias ll="ls -alF"
alias ltr="ls -alFtr"
alias ls="ls -aF"
alias mv="mv -i"
alias offline_mutt="mutt -R -F ~/.muttrc.offline"
alias patchp0="patch -p0 -V none"
alias ph="ps auwwx | head"
alias pg="ps auwwx | grep -i -e ^USER -e "
alias publicip="curl -w '\n' -s http://ifconfig.me"
alias refetch="cvs -q up -PACd"
alias rg="rg --color=never -N -z"
alias telnet="telnet -K"
alias tm="tail -f /var/log/messages"
alias u="cvs -q up -PAd"
# serve up the current directory
alias webserver="ifconfig | grep 'inet ' | grep -v 127.0.0.1; python2 -m SimpleHTTPServer"

# when i say vi i mean vim (if it's installed)
if [ -x "`which vim`" ]; then
   alias vi="vim"
   alias view="vim -R"
   export EDITOR=`which vim`
else
   export EDITOR=/usr/bin/vi
fi

# options
setopt noclobber                     # halp me
setopt nohup                         # don't kill things when i logout
setopt print_exit_value              # i want to know if something went wrong
HISTSIZE=500
PS1="%m:%~%(!.#.$) "                 # prompt
TMOUT=0                              # don't auto logout

# i am frequently too quick to logout with control+d twice (one to exit ssh,
# another to close the terminal) and will miss the 'you have suspended jobs'
# message, so hitting it twice still logs me out.  prevent that by not sending
# eof on control+d but manually bind to it and run a function that exits.
setopt ignore_eof
_block_quick_bail() {
   _sj=`jobs -sp`
   if [[ $_sj == "" ]]; then
      exit
   else
      _sj=$'\n'${_sj}
      zle -M "zsh: you have suspended jobs:${_sj}"
   fi
}
zle -N _block_quick_bail
bindkey '^d' _block_quick_bail

# show all logins and such
watch=all
WATCHFMT="%B%n%b %a %l at %@"

# etc
limit coredumpsize 0                 # don't know why you'd want anything else
umask 022                            # be nice

# https://superuser.com/questions/458906
__git_files () {
    _wanted files expl 'local files' _files
}

# envs.sh file service
mirror() {
    curl -F "url=$1" https://envs.sh/
}
upload() {
    if [[ -z $1 ]]; then a="file=@-"; else a="file=@$1"; fi
    curl -F $a https://envs.sh/
}

# os-specific tweaks

# mac os
if [[ $OSTYPE = darwin* ]]; then
   export STORE_LASTDIR=1
   export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"

elif [[ $OSTYPE = linux* ]]; then
   alias ls="ls -aFv"
   alias ph="ps auwwx | sort -rk 3,3 | head"
fi

# and the reverse
if [[ $OSTYPE != linux* ]]; then
   # siginfo
   stty status '^T'
fi

if [[ $OSTYPE != darwin* ]]; then
   watch=
fi

case $TERM in
xterm*)
    precmd() { print -Pn "\e]0;%m:%~$\a" }
    preexec() { print -Pn "\e]0;%m:%~$ $1\a" }
;;
esac

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
