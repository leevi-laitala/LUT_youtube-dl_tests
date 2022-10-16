#!/bin/bash

[ -z "$YTEXEC" ] && { tput setaf 1; echo "ERROR: No YTEXEC environment variable defined." && exit 1 ; }

mkdir "out" || exit 1
cd "out" || exit 1

$YTEXEC -o "video.%(ext)s" "https://www.youtube.com/watch?v=d5jXgio4VDM"

[ "$(find . -type f | wc -l)" -gt "0" ] && { rm -rf "out"; exit 1 ; }

cd .. || exit 1
rm -rf "out" || exit 1
