#!/bin/sh

export LANG=en_US.UTF-8

# tell gtk+3 to scale up
export GDK_SCALE=2
# but not fonts
export GDK_DPI_SCALE=0.75

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

	# quickly set at startup, then run in background to slowly adjust
	redshift -l 41.90:-87.66 -t 5500:3700 -o
	redshift -l 41.90:-87.66 -t 5500:3700 &

	xbanish &

	# 8 is as low as it will go without making an annoying sound
	xdimmer -a -k -p 8 -t 120 &

	xsetroot -solid "#e3e0d5" -cursor_name left_ptr

	# not sure why this dance is required for RightButtonAreaLeft to show up
#	synclient ClickPad=1
#	synclient ClickPad=0
#	synclient ClickPad=1
#	synclient HorizTwoFingerScroll=1 RightButtonAreaLeft=525

	# slow down usb mouse
	xinput set-prop /dev/wsmouse 254 1
fi

/usr/local/bin/ratpoison

# cleanup
pkill -9 dzen2 i3status dbus-daemon redshift
