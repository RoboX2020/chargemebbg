#!/bin/bash
./yt-dlp "ytsearch5:ara ara sound effect" --match-filter "duration <= 4" --max-downloads 1 -x --audio-format mp3 -o "sounds/in/ara.%(ext)s" &
./yt-dlp "ytsearch5:anime wow sound effect" --match-filter "duration <= 4" --max-downloads 1 -x --audio-format mp3 -o "sounds/in/wow.%(ext)s" &
./yt-dlp "ytsearch5:uwu sound effect" --match-filter "duration <= 4" --max-downloads 1 -x --audio-format mp3 -o "sounds/in/uwu.%(ext)s" &
./yt-dlp "ytsearch5:tuturu sound effect" --match-filter "duration <= 4" --max-downloads 1 -x --audio-format mp3 -o "sounds/out/tuturu.%(ext)s" &
./yt-dlp "ytsearch5:nani sound effect anime" --match-filter "duration <= 4" --max-downloads 1 -x --audio-format mp3 -o "sounds/out/nani.%(ext)s" &
./yt-dlp "ytsearch5:oh my gah sound effect anime" --match-filter "duration <= 4" --max-downloads 1 -x --audio-format mp3 -o "sounds/out/ohmygah.%(ext)s" &
wait
echo "Done downloading new sounds"
