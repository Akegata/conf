#!/bin/bash

# Take a screenshot with grim
grim /tmp/screen.png

# Apply blur to the screenshot with imagemagick
convert /tmp/screen.png -blur 0x6 /tmp/screen.png

# Use swaylock to lock the screen with the blurred screenshot
swaylock -i /tmp/screen.png

# Clean up the temporary screenshot file
rm /tmp/screen.png
