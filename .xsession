#!/bin/sh

cleanup() {
	echo "cleaning up"
	pkill -9 dzen2 i3status dbus-daemon redshift
	rm -f ~/.Xauthority
}
trap cleanup INT TERM QUIT

export LANG=en_US.UTF-8

SCREEN_WIDTH=`xrandr 2>&1 | grep "Screen 0: minimum" | sed -e 's/.*, current //' -e 's/ x.*//'`
if [ "${SCREEN_WIDTH}" -gt 2000 ]; then
	export HIDPI=1
fi

MACHINE=`sysctl -n hw.version`

if [ "$HIDPI" = "1" ]; then
	xrdb -DHIDPI=1 < ~/.Xdefaults
else
	xrdb < ~/.Xdefaults
fi

#exec /usr/local/bin/urxvt

if [ `uname -s` == "OpenBSD" ]; then
	eval `dbus-launch --sh-syntax`
	ruby ~/code/dzen-jcs/dzen-jcs.rb &

	xmodmap ~/.xmodmap
	xset b off
	xset r rate 350 35
	xset +fp /usr/local/lib/X11/fonts/jcs fp rehash
	xset m 3/1 4

	# disable built-in saver, because xidle will handle it
	xset s off
	# disable dpms, because slock will handle it
	xset dpms 0 0 0

	xidle -timeout 500 -ne -program ~/bin/lock &

	xsetroot -solid '#6c7c87' -cursor_name left_ptr

	redshift -l 41.90:-87.66 -t 6500:3500 -m randr:preserve=1 &
	xdimmer -k -t 20 -n &
	xbanish &

	case $MACHINE in
	"ThinkPad X1 Carbon 5th")
		xcalib ~/.icc/x1c5wqhd-LP140QH2_SPB1.icc

		synclient \
			PalmDetect=1 \
			PalmMinWidth=8 \
			ClickPad=1 \
			;
		;;
	*)
		echo "running on unknown machine \"${MACHINE}\""
		return
		;;
	esac

	/usr/local/bin/ratpoison
else
	xset +fp ~/.fontspcf fp rehash
	xset b off

	/usr/local/bin/xbanish &

	xsetroot -cursor_name left_ptr

	/usr/local/bin/ratpoison -f ~/.ratpoisonrc.mac
fi

cleanup
