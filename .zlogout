if [ "$XTERMBG" != "" ] && [ -f ~/.xtermbg ]; then
	xtermcontrol --bg="$XTERMBG"
fi
