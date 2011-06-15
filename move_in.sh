#!/bin/sh
#
# download dot files from github, install them to ~
# joshua stein <jcs@jcs.org>
#
# usage: sh -c `ftp -o - http://github.com/jcs/dotfiles/raw/master/move_in.sh`
#

if [ ! -d ~/.ssh/ ]; then
	mkdir ~/.ssh/
fi

TD=`mktemp -d XXXXXX`

ftp -o - http://github.com/jcs/dotfiles/tarball/master | tar -C $TD -xvzf -
rm -f $TD/jcs-*/move_in.sh
mv -f $TD/jcs-*/.???* ~/
rm -rf $TD

rm -f ~/.bash_history
ln -s /dev/null ~/.bash_history

# remove cruft installed by default in openbsd
rm -f ~/.Xdefaults \
	~/.cshrc \
	~/.login \
	~/.mailrc \
	~/.profile
