#!/bin/bash
DIR="/Users/dr.arora/chargemebbg/sounds/in"

say -v "Samantha" "[[rate 120]] Ooooch,,." -o "$DIR/ai_ouch_1.aiff"
say -v "Samantha" "[[rate 120]] Oow,,." -o "$DIR/ai_ouch_2.aiff"
say -v "Samantha" "[[rate 140]] Heey,,." -o "$DIR/ai_hey.aiff"
say -v "Samantha" "[[rate 130]] Stoop itt,,." -o "$DIR/ai_stop_it.aiff"
say -v "Samantha" "[[rate 120]] That huurts,,." -o "$DIR/ai_that_hurts.aiff"
say -v "Samantha" "[[rate 120]] Whhyy,,?" -o "$DIR/ai_why.aiff"

say -v "Victoria" "[[rate 110]] [[pbas 40]] Ohh,, yeaah." -o "$DIR/ai_oh_yeah_1.aiff"
say -v "Victoria" "[[rate 115]] [[pbas 45]] Ohh,, yeaah!." -o "$DIR/ai_oh_yeah_2.aiff"
say -v "Victoria" "[[rate 100]] [[pbas 40]] Mmm,,." -o "$DIR/ai_mmm.aiff"
say -v "Victoria" "[[rate 110]] [[pbas 40]] Doo itt,, again." -o "$DIR/ai_do_it_again.aiff"
say -v "Victoria" "[[rate 110]] [[pbas 40]] Haaarder." -o "$DIR/ai_harder.aiff"
say -v "Victoria" "[[rate 110]] [[pbas 40]] Ohh baaby." -o "$DIR/ai_oh_baby.aiff"
echo "Generated AI sounds!"
