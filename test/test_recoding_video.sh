#!/bin/bash
#need ffmpeg
VALUE=1
mkdir videofolder
cd ./videofolder

$YTEXEC -o "video.%(ext)s" --recode-video mkv https://www.reddit.com/r/leagueoflegends/comments/y2qtmo/t1_gumayusi_lucian_insane_outplay_in_solo_queue/ && VALUE=0

if [ ! -e "video.mkv" ]; then
  VALUE=1
fi

cd ..
rm -r videofolder
exit $VALUE

