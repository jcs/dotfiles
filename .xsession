#!/bin/sh

export LANG=en_US.UTF-8

# this should be in /etc/X11/xdm/Xsetup_0, but just in case
xrandr --dpi 120

xrdb < ~/.Xdefaults

if [ `uname -s` == "OpenBSD" ]; then
	eval `dbus-launch --sh-syntax`
	ruby ~/code/dzen-jcs/dzen-jcs.rb &

	xmodmap ~/.xmodmap
	xset r rate 350 35
	xset +fp /usr/local/lib/X11/fonts/jcs fp rehash
	xset m 3/1 4

	xidle -timeout 600 -ne -program ~/bin/lock &

	redshift -l 41.90:-87.66 -t 5500:3700 &

	xbanish &
	xdimmer &

	xsetroot -solid '#6C7C87' -cursor_name left_ptr

	synclient ClickPad=1 HorizTwoFingerScroll=1 RightButtonAreaLeft=800 HorizHysteresis=10 VertHysteresis=10

	ruby ~/code/imapbiff/imapbiff.rb &
fi

/usr/local/bin/ratpoison

# cleanup
pkill -9 dzen2 i3status dbus-daemon
