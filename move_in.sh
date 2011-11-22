#!/bin/sh
#
# download dot files from github, install them to ~
# joshua stein <jcs@jcs.org>
#

if [ `uname` = "Linux" -o `uname` = "Darwin" ]; then
	FETCH="curl -L"
else
	FETCH="ftp -o -"
fi

TD=`mktemp -d XXXXXX`

if [ ! -d ~/.ssh/ ]; then
	mkdir ~/.ssh/
fi

$FETCH https://github.com/jcs/dotfiles/tarball/master | tar -C $TD -xzf -
rm -f $TD/jcs-*/move_in.sh
cd $TD/jcs-* && tar -cf - . | (cd; tar -xvf -)
rm -rf $TD

for f in .bash_history .sqlite_history .mysql_history; do
	rm -f ~/$f
	ln -s /dev/null ~/$f
done

# remove cruft installed by default in openbsd
rm -f ~/.cshrc \
	~/.login \
	~/.mailrc \
	~/.profile
