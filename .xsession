#!/bin/sh -x

cleanup() {
	echo "cleaning up"
	pkill -9 dzen2 i3status dbus-daemon redshift compton
	rm -f ~/.Xauthority
}
trap cleanup INT TERM QUIT

if [ `uname -o` = "GNU/Linux" ]; then
	MACHINE="`cat /sys/devices/virtual/dmi/id/sys_vendor` `cat /sys/devices/virtual/dmi/id/product_name`"
else
	MACHINE="`sysctl -n hw.vendor` `sysctl -n hw.product`"
fi

export LANG=en_US.UTF-8

export MOZ_USE_XINPUT2=1

SCREEN_WIDTH=`xrandr 2>&1 | grep "Screen 0: minimum" | sed -e 's/.*, current //' -e 's/ x.*//'`
if [ "${SCREEN_WIDTH}" -gt 2000 ]; then
	echo "using HIDPI"
	export HIDPI=1
	export GDK_SCALE=1.5
	export QT_SCALE_FACTOR=1.5
fi

if [ "$HIDPI" = "1" ]; then
	xrdb -DHIDPI=1 -DHOME=$HOME < ~/.Xdefaults
else
	xrdb -DHOME=$HOME < ~/.Xdefaults
fi

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

xidle -timeout 300 -ne -program ~/bin/lock &

redshift -l 41.90:-87.66 -t 6500:3250 -m randr &
xbanish &

case $MACHINE in
"HUAWEI HUAWEI MateBook X")
	xcalib ~/.icc/matebookx.icc
	hsetroot -solid '#83988E'
	compton -b
	xdimmer -n -a &
	;;
*)
	echo "running on unknown machine \"${MACHINE}\""
	xsetroot -solid '#6c7c87' -cursor_name left_ptr
	;;
esac

if [ -f ~/.xsession.local ]; then
	. ~/.xsession.local
fi

ratpoison

cleanup
