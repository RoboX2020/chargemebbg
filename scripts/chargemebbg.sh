#!/bin/bash
# ============================================================================
# chargemebbg.sh - the OLD, simple Bash version of ChargeMeBBG.
# (The real version is chargemebbg.swift in the repo root - read its header
# first. This script is kept as a fallback / for learning.)
#
# DIFFERENCE FROM THE SWIFT VERSION: this one POLLS - it asks macOS for the
# battery state 100 times a second in a loop (sleep 0.01). That is simpler
# but wasteful and slower to react; the Swift version gets tapped on the
# shoulder by macOS instead.
#
# RUN IT:  bash scripts/chargemebbg.sh   (macOS only: needs pmset + afplay)
# NOTE: the sound folder is hardcoded to /Users/dr.arora/... below, so on
# any other Mac you must edit the path or nothing plays.
# ============================================================================

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
