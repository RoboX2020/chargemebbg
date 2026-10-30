#!/bin/bash
#!/bin/bash
# download_pack.sh - downloads eight freesound.org sounds by ID into
# sounds/in, then uses ffmpeg to trim each one to its first 1.5 seconds
# (shorter = punchier reaction). Needs ./yt-dlp and ffmpeg installed.
# RUN from the repo root: bash scripts/download_pack.sh
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
