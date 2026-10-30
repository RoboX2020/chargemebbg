#!/bin/bash
#!/bin/bash
# download.sh - fetches the starter set of meme sounds from YouTube using
# yt-dlp (a command-line video/audio downloader, expected next to this
# script as ./yt-dlp). Files land in sounds/in (plug-in) and sounds/out
# (unplug). Each line ends in & so all six downloads run at the same time;
# "wait" waits for all of them. "--match-filter duration <= 4" keeps only
# clips of 4 seconds or less. RUN from the repo root: bash scripts/download.sh
./yt-dlp "ytsearch5:ara ara sound effect" --match-filter "duration <= 4" --max-downloads 1 -x --audio-format mp3 -o "sounds/in/ara.%(ext)s" &
./yt-dlp "ytsearch5:anime wow sound effect" --match-filter "duration <= 4" --max-downloads 1 -x --audio-format mp3 -o "sounds/in/wow.%(ext)s" &
./yt-dlp "ytsearch5:uwu sound effect" --match-filter "duration <= 4" --max-downloads 1 -x --audio-format mp3 -o "sounds/in/uwu.%(ext)s" &
./yt-dlp "ytsearch5:tuturu sound effect" --match-filter "duration <= 4" --max-downloads 1 -x --audio-format mp3 -o "sounds/out/tuturu.%(ext)s" &
./yt-dlp "ytsearch5:nani sound effect anime" --match-filter "duration <= 4" --max-downloads 1 -x --audio-format mp3 -o "sounds/out/nani.%(ext)s" &
./yt-dlp "ytsearch5:oh my gah sound effect anime" --match-filter "duration <= 4" --max-downloads 1 -x --audio-format mp3 -o "sounds/out/ohmygah.%(ext)s" &
wait
echo "Done downloading new sounds"
