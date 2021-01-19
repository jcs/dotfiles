#!/bin/sh

set -e

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

chmod 700 ~

if [ -d ~/.dotfiles ]; then
	cd ~/.dotfiles
	git pull --ff-only
else
	git clone https://github.com/jcs/dotfiles ~/.dotfiles
fi

cd ~/.dotfiles
for f in .???*; do
	rm -f ~/$f
	(cd ~/; ln -s .dotfiles/$f $f)
done

if [ ! -d ~/.ssh ]; then
	mkdir ~/.ssh
fi

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
	git clone https://github.com/VundleVim/Vundle.vim.git \
		~/.vim/bundle/Vundle.vim
fi

# we're probably being piped to a shell (ftp -o - .. | sh -) so this
# won't work running it ourselves
echo "vim +PlugInstall +qall"
