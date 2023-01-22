#!/bin/sh -x

cleanup() {
	echo "cleaning up"
	pkill ssh-agent-card-prompt dbus-daemon redshift picom
	pkill -f "ruby.*sdorfehs-bar"
	rm -f ~/.Xauthority
	rm -f ~/audacious.core
	rm -rf ~/.local/share/Trash
}
trap cleanup INT TERM QUIT

if [ X`uname -s` = X"Linux" ]; then
	MACHINE="`cat /sys/devices/virtual/dmi/id/sys_vendor` `cat /sys/devices/virtual/dmi/id/product_name`"
else
	MACHINE="`sysctl -n hw.vendor` `sysctl -n hw.product`"
fi

export LANG=en_US.UTF-8

# better two-finger touchpad scrolling
export MOZ_USE_XINPUT2=1
# opengl acceleration
export MOZ_ACCELERATED=1
# force webrender to enable
export MOZ_WEBRENDER=1

# to allow style changes with qt5ct
export QT_QPA_PLATFORMTHEME="qt5ct"

SCREEN_WIDTH=`xrandr 2>&1 | grep "Screen 0: minimum" | sed -e 's/.*, current //' -e 's/ x.*//'`
if [ "${SCREEN_WIDTH}" -ge 1920 ]; then
	echo "using HIDPI"
	export HIDPI=1
	export GDK_SCALE=1.5
	export QT_SCALE_FACTOR=1.5
fi

if [ "$HIDPI" = "1" ]; then
	xrdb -DHIDPI=1 -DHOME=$HOME < ~/.Xresources
else
	xrdb -DHOME=$HOME < ~/.Xresources
fi

xsetroot -cursor_name left_ptr

xmodmap ~/.xmodmap
xset b 0 0 0
xset r rate 350 35

# disable built-in saver, because xidle will handle it
xset s off
# disable dpms, because slock will handle it
xset dpms 0 0 0

# ~/bin/music called from lock needs DBUS_SESSION_BUS_ADDRESS
eval `dbus-launch --sh-syntax`

# ~/bin/lock does some protections and runs slock
xidle -timeout 900 -ne -program ~/bin/lock &

xbanish &

hsetroot -solid "#a3ccbd"
picom -b

#xdimmer -n -a &

# turn off the touchscreen
#xinput disable /dev/wsmouse2

# run after any icc profile loading
redshift -l 41.90:-87.66 -t 6500:3500 -m randr &

# finally, run the window manager and block
if [ -x ~/code/sdorfehs/sdorfehs ]; then
	~/code/sdorfehs/sdorfehs
elif [ -x /usr/local/bin/sdorfehs ]; then
	/usr/local/bin/sdorfehs
else
	/usr/X11R6/bin/fvwm
fi

cleanup
