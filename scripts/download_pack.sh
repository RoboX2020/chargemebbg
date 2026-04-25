#!/bin/bash
ids=(561339 67682 337997 679731 522949 819615 692783 829388)
for id in "${ids[@]}"; do
    echo "Downloading freesound ID $id"
    ./yt-dlp "https://freesound.org/s/$id/" -x --audio-format mp3 -o "sounds/in/pack_${id}.%(ext)s"
    if [ -f "sounds/in/pack_${id}.mp3" ]; then
        ffmpeg -y -i "sounds/in/pack_${id}.mp3" -t 1.5 -c copy "sounds/in/pack_${id}.trim.mp3"
        mv "sounds/in/pack_${id}.trim.mp3" "sounds/in/pack_${id}.mp3"
    fi
done
echo "Done fetching and trimming new pack"
