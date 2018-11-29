#!/bin/bash
# by EgorDm

PROGRAM_NAME=$1
DELAY=${2:-3}
MIN_SIZE=${3:-50}

# Start the program
echo "Starting program $PROGRAM_NAME"
$PROGRAM_NAME &

echo "Sleeping until it starts"
sleep $DELAY

echo "Attempting to close the window"
IFS=$'\n'
for i in $(xdotool search $PROGRAM_NAME)
do
	# Obtain all windows
	WID=$(echo $i | tr -dc '0-9')
	if [ -z "$WID" ]; then
		continue
	fi

	# Check if the window is actually a window and not an icon or tray item
	WSIZE=$(xdotool getwindowgeometry $WID | grep -o -E '[0-9]+' | tail -n 1)
	if [ -z "$WSIZE" ] || [ $WSIZE -lt "$MIN_SIZE" ]; then
		continue
	fi

	# Close the window
	echo "Closing window WID: $WID and SIZE: $WSIZE"
	xdotool windowactivate --sync $WID key --clearmodifiers --delay 100 alt+F4
done

