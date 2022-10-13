#!/bin/bash
mkdir videofolder
cd ./videofolder
VALUE=1

youtube-dl -o "video" https://www.reddit.com/r/leagueoflegends/comments/y2qtmo/t1_gumayusi_lucian_insane_outplay_in_solo_queue/ && VALUE=0
find . -type f -name "video.*" || VALUE=1

cd ..
rm -r videofolder
exit $VALUE
