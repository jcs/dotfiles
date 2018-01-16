#!/bin/sh -x

cleanup() {
	echo "cleaning up"
	pkill -9 dzen2 i3status dbus-daemon redshift
	rm -f ~/.Xauthority
}
trap cleanup INT TERM QUIT

export LANG=en_US.UTF-8
export MOZ_USE_XINPUT2=1

SCREEN_WIDTH=`xrandr 2>&1 | grep "Screen 0: minimum" | sed -e 's/.*, current //' -e 's/ x.*//'`
if [ "${SCREEN_WIDTH}" -gt 2000 ]; then
	export HIDPI=1
	echo "using HIDPI"
fi

if [ "$HIDPI" = "1" ]; then
	xrdb -DHIDPI=1 -DHOME=$HOME < ~/.Xdefaults
else
	xrdb -DHOME=$HOME < ~/.Xdefaults
fi

MACHINE="`sysctl -n hw.vendor` `sysctl -n hw.product`"

if [ `uname -s` == "OpenBSD" ]; then
	eval `dbus-launch --sh-syntax`
	ruby ~/code/dzen-jcs/dzen-jcs.rb &

	xmodmap ~/.xmodmap
	xset b off
	xset r rate 350 35
	xset m 3/1 4

	# disable built-in saver, because xidle will handle it
	xset s off
	# disable dpms, because slock will handle it
	xset dpms 0 0 0

	xidle -timeout 500 -ne -program ~/bin/lock &

	xsetroot -solid '#6c7c87' -cursor_name left_ptr

	redshift -l 41.90:-87.66 -t 6500:3500 -m randr:preserve=1 &
	xbanish &

	case $MACHINE in
	"LENOVO 20HRCTO1WW")
		xcalib ~/.icc/x1c5wqhd-LP140QH2_SPB1.icc
		xdimmer -k -t 20 -n &

		synclient \
			PalmDetect=1 \
			PalmMinWidth=8 \
			ClickPad=1 \
			;
		;;

	"HUAWEI HUAWEI MateBook X")
		xcalib ~/.icc/matebookx.icc
		xdimmer -n -a &

		;;

	*)
		echo "running on unknown machine \"${MACHINE}\""
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
