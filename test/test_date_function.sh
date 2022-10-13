#!/bin/bash

VALUE=1

mkdir videofolder
cd videofolder

youtube-dl -o "video" --date "20221013" https://www.reddit.com/r/leagueoflegends/comments/y2qtmo/t1_gumayusi_lucian_insane_outplay_in_solo_queue/ && VALUE=0
find . -type f -name "video.*" || VALUE=1

cd ..
rm -r videofolder
exit $VALUE
