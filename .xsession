#!/bin/sh

export LANG=en_US.UTF-8

xrdb < ~/.Xdefaults

if [ `uname -s` == "OpenBSD" ]; then
	xmodmap ~/.xmodmap
	xset r rate 350 35
	xset +fp /usr/local/lib/X11/fonts/jcs +fp /usr/local/share/fonts/dina fp rehash
	xset m 3/1 4

	xidle -timeout 240 -ne -program ~/bin/lock &

	/usr/local/bin/ruby ~/code/dzen-jcs/dzen-jcs.rb &

	# define the trackpad surface (ASUS UX305FA)
	synclient LeftEdge=0 RightEdge=3080 TopEdge=10 BottomEdge=2119

	# ignore palm input on right side of trackpad while i type (works better
	# than palm detection)
	synclient AreaRightEdge=2450

	# make clicking with two fingers do a right-click
	synclient ClickFinger2=3
	# and 3-fingers do a middle-click
	synclient ClickFinger3=2

	# ignore lazy thumb on the bottom of the trackpad used to click
	synclient LazyThumbWidth=30 LazyThumbTopEdge=1600

	/usr/local/bin/xbanish &
fi

exec /usr/local/bin/ratpoison
