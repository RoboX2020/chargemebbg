#!/bin/bash
./yt-dlp "ytsearch3:short moan sound effect" --match-filter "duration <= 3" --max-downloads 1 -x --audio-format mp3 -o "sounds/in/moan1.%(ext)s" &
./yt-dlp "ytsearch3:anime girl ahh sound effect short" --match-filter "duration <= 3" --max-downloads 1 -x --audio-format mp3 -o "sounds/in/moan2.%(ext)s" &
./yt-dlp "ytsearch3:female short sigh sound effect" --match-filter "duration <= 3" --max-downloads 1 -x --audio-format mp3 -o "sounds/out/sigh1.%(ext)s" &
./yt-dlp "ytsearch3:female small gasp sound effect" --match-filter "duration <= 3" --max-downloads 1 -x --audio-format mp3 -o "sounds/out/gasp1.%(ext)s" &
wait
echo "Done downloading literal sounds"
