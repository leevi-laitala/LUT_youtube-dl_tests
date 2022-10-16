#!/bin/bash
[ -z "$YTEXEC" ] && { tput setaf 1; echo "ERROR: No YTEXEC environment variable defined." && exit 1 ; }
VALUE=1
#need ffmpeg
ffmpeg &> /dev/null || { tput setaf 1; echo "ERROR: No ffmpeg installed. Skipping ..." && exit 2 ; }
mkdir videofolder
cd ./videofolder

$YTEXEC -o "video.%(ext)s" --recode-video mkv https://www.reddit.com/r/leagueoflegends/comments/y2qtmo/t1_gumayusi_lucian_insane_outplay_in_solo_queue/ && VALUE=0

if [ ! -e "video.mkv" ]; then
  VALUE=1
fi

cd ..
rm -r videofolder
exit $VALUE

