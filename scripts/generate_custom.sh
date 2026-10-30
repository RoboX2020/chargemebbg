#!/bin/bash
#!/bin/bash
# generate_custom.sh - makes three custom voice clips with the Mac's
# built-in text-to-speech ("say" command, Victoria voice) and saves them
# into sounds/in. The [[rate]] and [[pbas]] tags slow the speech down and
# lower the pitch. macOS only. NOTE: output folder is hardcoded to
# /Users/dr.arora/... - edit it on any other machine.
DIR="/Users/dr.arora/chargemebbg/sounds/in"

say -v "Victoria" "[[rate 90]] [[pbas 35]] Nauuughtyy,, yoouuu." -o "$DIR/ai_naughty.aiff"
say -v "Victoria" "[[rate 80]] [[pbas 30]] fuck,,." -o "$DIR/ai_fuck.aiff"
say -v "Victoria" "[[rate 100]] [[pbas 35]] Nooobody,, doeess itt,, beeetteer." -o "$DIR/ai_nobody.aiff"

echo "Custom AI sounds generated!"
