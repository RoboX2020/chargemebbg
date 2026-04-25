#!/bin/bash
./yt-dlp "https://freesound.org/people/ellenmentor/sounds/459126/" -x --audio-format mp3 -o "sounds/in/free2.%(ext)s" &
./yt-dlp "https://freesound.org/people/StormwaveAudio/sounds/614067/" -x --audio-format mp3 -o "sounds/in/free3.%(ext)s" &
./yt-dlp "https://freesound.org/people/8bitmyketison/sounds/699858/" -x --audio-format mp3 -o "sounds/out/free4.%(ext)s" &
./yt-dlp "https://freesound.org/people/From_Freesound_org/sounds/166989/" -x --audio-format mp3 -o "sounds/out/free5.%(ext)s" &
./yt-dlp "https://freesound.org/people/Schulze/sounds/23251/" -x --audio-format mp3 -o "sounds/out/free6.%(ext)s" &
wait
echo "Done downloading freesound sounds"
