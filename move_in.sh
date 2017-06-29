#!/bin/sh

# remove cruft installed by default in openbsd
rm -f ~/.cshrc \
	~/.login \
	~/.mailrc \
	~/.profile \
	~/.Xdefaults \
	~/.cvsrc

for f in .bash_history .sqlite_history .mysql_history; do
	rm -f ~/$f
	ln -s /dev/null ~/$f
done

if [ -d ~/.dotfiles ]; then
	echo "~/.dotfiles already exists"
	exit 1
fi

git clone https://github.com/jcs/dotfiles ~/.dotfiles

cd ~/.dotfiles
for f in .???*; do
	rm -f ~/$f
	(cd ~/; ln -s .dotfiles/$f $f)
done
