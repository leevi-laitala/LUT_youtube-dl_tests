#!/bin/bash
#change video
youtube-dl -o "video" https://www.youtube.com/watch?v=kt2D7xl06mk

FILE=testi.mp4
if [ -f "$FILE" ]
then
  continue
else
  [ -e "video" ] && rm video
  exit 1
fi

rm video
