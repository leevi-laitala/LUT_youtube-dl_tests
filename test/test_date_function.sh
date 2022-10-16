#!/bin/bash
[ -z "$YTEXEC" ] && { tput setaf 2; echo "ERROR: No YTEXEC environment variable defined." && exit 1 ; }
VALUE=1

mkdir videofolder
cd videofolder

$YTEXEC -o "video" --date "20221013" https://www.reddit.com/r/leagueoflegends/comments/y2qtmo/t1_gumayusi_lucian_insane_outplay_in_solo_queue/ && VALUE=0
find . -type f -name "video.*" || VALUE=1

cd ..
rm -r videofolder
exit $VALUE
