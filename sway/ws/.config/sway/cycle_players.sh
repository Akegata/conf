#!/bin/bash

# File to store the current player name
CURRENT_PLAYER_FILE="$HOME/.config/sway/current_player"

# Get the list of active players
PLAYERS=($(playerctl -l 2>/dev/null))

# If no players are available, exit
if [ ${#PLAYERS[@]} -eq 0 ]; then
	notify-send "No media players found"
	exit 1
fi

# Get the current player from the file
if [ -f "$CURRENT_PLAYER_FILE" ]; then
	CURRENT_PLAYER=$(cat "$CURRENT_PLAYER_FILE")
else
	CURRENT_PLAYER=""
fi

# Pause the current player (if it exists and is playing)
if [[ -n "$CURRENT_PLAYER" ]] && playerctl --player="$CURRENT_PLAYER" status 2>/dev/null | grep -q "Playing"; then
	playerctl --player="$CURRENT_PLAYER" pause
fi

# Find the index of the current player in the list
CURRENT_INDEX=-1
for i in "${!PLAYERS[@]}"; do
	if [ "${PLAYERS[$i]}" = "$CURRENT_PLAYER" ]; then
		CURRENT_INDEX=$i
		break
	fi
done

# If the current player is not found in the list, default to the first player
if [ "$CURRENT_INDEX" -eq -1 ]; then
	NEXT_PLAYER="${PLAYERS[0]}"
else
	# Calculate the index of the next player (with wrap-around)
	NEXT_INDEX=$(((CURRENT_INDEX + 1) % ${#PLAYERS[@]}))
	NEXT_PLAYER="${PLAYERS[$NEXT_INDEX]}"
fi

# Save the next player to the file
echo "$NEXT_PLAYER" >"$CURRENT_PLAYER_FILE"

# Notify the user of the switch
notify-send "Switched to player: $NEXT_PLAYER"

## Optionally start playing the new player (if it was paused)
#if playerctl --player="$NEXT_PLAYER" status 2>/dev/null | grep -q "Paused"; then
#    playerctl --player="$NEXT_PLAYER" play
#fi

# Refresh Waybar's mpris module
pkill -RTMIN+8 waybar
