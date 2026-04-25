#!/bin/bash

echo "Start charging me bbg... put it in."
echo "Waiting for you to fuck me with that charger of yours!"

# Get the initial power state
PREV_STATE=$(pmset -g batt | awk 'NR==1{print $4}' | tr -d "'")

while true; do
    sleep 0.01
    CURRENT_STATE=$(pmset -g batt | awk 'NR==1{print $4}' | tr -d "'")
    
    if [ "$CURRENT_STATE" != "$PREV_STATE" ]; then
        if [ "$CURRENT_STATE" == "AC" ]; then
            # Plugged in
            echo "Device plugged in!"
            files=(/Users/dr.arora/chargemebbg/sounds/in/*.mp3)
            random_file="${files[RANDOM % ${#files[@]}]}"
            afplay "$random_file" &
        elif [ "$CURRENT_STATE" == "Battery" ]; then
            # Plugged out
            echo "Device unplugged!"
            files=(/Users/dr.arora/chargemebbg/sounds/in/*.mp3)
            random_file="${files[RANDOM % ${#files[@]}]}"
            afplay "$random_file" &
        fi
        PREV_STATE=$CURRENT_STATE
    fi
done
