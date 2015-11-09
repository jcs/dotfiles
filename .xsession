#!/bin/sh

export LANG=en_US.UTF-8

# this should be in /etc/X11/xdm/Xsetup_0, but just in case
xrandr --dpi 192

xrdb < ~/.Xdefaults

if [ `uname -s` == "OpenBSD" ]; then
	xmodmap ~/.xmodmap
	xset r rate 350 35
	xset +fp /usr/local/lib/X11/fonts/jcs fp rehash
	xset m 3/1 4

	xidle -timeout 240 -ne -program ~/bin/lock &

	ruby ~/code/dzen-jcs/dzen-jcs.rb &

	redshift -l 41.90:-87.66 -t 5500:3700 &

	xbanish &
	xdimmer &

	xsetroot -solid '#6C7C87' -cursor_name left_ptr
fi

exec /usr/local/bin/ratpoison
