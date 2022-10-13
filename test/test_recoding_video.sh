#!/bin/bash
#need ffmpeg
youtube-dl -o "video.%(ext)s" --recode-video mkv https://www.youtube.com/watch?v=kt2D7xl06mk

FILE=video.mkv
if [ -f "$FILE" ]
then
  continue
else
  [ -e "video.mkv" ] && rm video.mkv
  [ -e "video.mp4" ] && rm video.mp4
  exit 1
fi

rm video.mkv
