#!/bin/sh
swayidle \
	timeout 1 'swaymsg "output * dpms off"' \
	resume 'swaymsg "output * dpms on"' &
swaylock -c000000
kill %%
